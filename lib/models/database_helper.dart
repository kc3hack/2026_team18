// Package imports:

// Package imports:
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// Project imports:
import 'package:mikata/models/account.dart';
import 'package:mikata/models/direct_message.dart';
import 'package:mikata/models/file_utils.dart';
import 'package:mikata/models/post.dart';

class DatabaseHelper {
    static final DatabaseHelper _instance = DatabaseHelper._internal();
    static Database? _database;

    DatabaseHelper._internal();

    factory DatabaseHelper() => _instance;

    Future<Database> get database async {
        if (_database != null) return _database!;
        _database = await _initDatabase();
        return _database!;
    }

    Future<Database> _initDatabase() async {
        String path = join(await FileIO().localPath, 'database.db');
    
        return await openDatabase(
            path,
            version: 1,
            onCreate: _onCreate,
        );
    }

    Future<void> _onCreate(Database db, int version) async {
        await db.execute('''
            CREATE TABLE accounts (
                account_uuid TEXT PRIMARY KEY,
                account_name TEXT,
                account_id TEXT,
                account_type INTEGER -- 0: User, 1: Bot
            )
        ''');

    await db.execute('''
            CREATE TABLE posts (
                post_uuid TEXT PRIMARY KEY,
                author_uuid TEXT,
                post_date INTEGER, -- ミリ秒単位
                content TEXT,
                parent_post_uuid TEXT,
                reply_count INTEGER DEFAULT 0,
                like_count INTEGER DEFAULT 0,
                view_count INTEGER DEFAULT 0,
                is_like INTEGER DEFAULT 0, -- 0 or 1
                is_bookmark INTEGER DEFAULT 0, -- 0 or 1
                FOREIGN KEY (author_uuid) REFERENCES accounts (account_uuid) ON DELETE CASCADE
            )
        ''');

    await db.execute('''
            CREATE TABLE follows (
                follower_uuid TEXT,
                followee_uuid TEXT,
                PRIMARY KEY (follower_uuid, followee_uuid),
                FOREIGN KEY (follower_uuid) REFERENCES accounts (account_uuid) ON DELETE CASCADE,
                FOREIGN KEY (followee_uuid) REFERENCES accounts (account_uuid) ON DELETE CASCADE
          )
        ''');

    await db.execute('''
            CREATE TABLE direct_messages (
                dm_uuid TEXT PRIMARY KEY,
                bot_uuid TEXT, -- 追加：DM相手のBot UUID
                from_account_uuid TEXT,
                content TEXT,
                date_time INTEGER,
                FOREIGN KEY (bot_uuid) REFERENCES accounts (account_uuid) ON DELETE CASCADE,
                FOREIGN KEY (from_account_uuid) REFERENCES accounts (account_uuid) ON DELETE CASCADE,
            )
        ''');

        await db.execute('CREATE INDEX idx_post_date ON posts (post_date DESC)');
    }

    Future<void> insertPost(Post post) async {
        final db = await database;
        await db.insert(
            'posts',
            post.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
        );
    }

    Future<void> deletePost(String postUuid) async {
        final db = await database;
        await db.delete(
            'posts',
            where: 'post_uuid = ?',
            whereArgs: [postUuid],
        );
    }

    Future<List<Post>> _getPostsFiltered(String whereClause, List<dynamic> whereArgs) async {
        final db = await database;
        final List<Map<String, dynamic>> maps = await db.query(
            'posts',
            where: whereClause,
            whereArgs: whereArgs,
            orderBy: 'post_date DESC',
        );
        return maps.map((m) => Post.fromMap(m)).toList();
    }

    Future<List<Post>> getLikedPosts() => _getPostsFiltered('is_like = ?', [1]);

    Future<List<Post>> getBookmarkedPosts() => _getPostsFiltered('is_bookmark = ?', [1]);

    Future<List<Post>> getPostsByAuthor(String authorUUID) => 
    _getPostsFiltered('author_uuid = ?', [authorUUID]);

    Future<List<Post>> getReplies(String parentPostUUID) => 
        _getPostsFiltered('parent_post_uuid = ?', [parentPostUUID]);

    Future<void> updateAuthorName(String accountUuid, String newName) async {
        final db = await database;
        await db.update(
            'accounts',
            {'account_name': newName},
            where: 'account_uuid = ?',
            whereArgs: [accountUuid],
        );
    }

    Future<void> updateAccountID(String uuid, String newID) async {
        final db = await database;
        await db.update(
            'accounts',
            {'account_id': newID},
            where: 'account_uuid = ?',
            whereArgs: [uuid],
        );
    }

    Future<List<Post>> getTimeline({int limit = 40, int offset = 0}) async {
        final db = await database;

        final List<Map<String, dynamic>> maps = await db.rawQuery('''
            SELECT 
                p.*, 
                a.account_name AS author_name 
            FROM posts p
            LEFT JOIN accounts a ON p.author_uuid = a.account_uuid
            ORDER BY p.post_date DESC
            LIMIT ? OFFSET ?
        ''', [limit, offset]);

        return maps.map((m) {
            var post = Post.fromMap(m);
            post.authorName = m['author_name'] ?? 'Unknown';
            return post;
        }).toList();
    }

    Future<void> insertAccount(Account account) async {
        final db = await database;
        await db.insert(
            'accounts',
            account.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
        );
    }

    Future<List<Account>> getAllAccount() async {
        final db = await database;
        final List<Map<String, dynamic>> maps = await db.query(
            'accounts',
        );
        
        if (maps.isEmpty) return [];

        return maps.map((m) => Account.fromMap(m)).toList();
    }

    Future<void> insertDirectMessage(DirectMessage dm) async {
        final db = await database;
        await db.insert(
            'direct_messages',
            dm.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
        );
    }

    Future<void> deleteDirectMessage(String dmUuid) async {
        final db = await database;
        await db.delete(
            'direct_messages',
            where: 'dm_uuid = ?',
            whereArgs: [dmUuid],
        );
    }

    Future<List<DirectMessage>> getDirectMessagesByBotUUID(String botUuid) async {
        final db = await database;
        final List<Map<String, dynamic>> maps = await db.rawQuery('''
            SELECT 
                dm.*, 
                a.account_name, 
                a.account_id 
            FROM direct_messages dm
            LEFT JOIN accounts a ON dm.from_account_uuid = a.account_uuid
            WHERE dm.bot_uuid = ?
            ORDER BY dm.date_time ASC -- 古い順（チャット形式）
        ''', [botUuid]);

        return maps.map((m) => DirectMessage.fromMap(m)).toList();
    }
}
