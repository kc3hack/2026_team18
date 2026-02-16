// import 'package:flutter_test/flutter_test.dart';
// import 'package:mikata/models/post.dart';

// void main() {
//   	group('Post - formatRelativeTime 実行時時刻によるテスト', () {
//     	test('相対時間による表示のテスト', () {
//     	final post = Post(postDate: DateTime.now());

//     	post.postDate = DateTime.now().subtract(const Duration(seconds: 30));
//     	post.formatRelativeTime();
//     	expect(post.relativeTime, 'たった今');

//     	post.postDate = DateTime.now().subtract(const Duration(minutes: 10, seconds: 10));
//     	post.formatRelativeTime();
//     	expect(post.relativeTime, '10分前');

//     	post.postDate = DateTime.now().subtract(const Duration(hours: 5));
//     	post.formatRelativeTime();
//     	expect(post.relativeTime, '5時間前');

//     	post.postDate = DateTime.now().subtract(const Duration(days: 3));
//     	post.formatRelativeTime();
//     	expect(post.relativeTime, '3日前');

//     	post.postDate = DateTime.now().subtract(const Duration(days: 14));
//     	post.formatRelativeTime();
//     	expect(post.relativeTime, '2週間前');

//     	post.postDate = DateTime.now().subtract(const Duration(days: 60));
//     	post.formatRelativeTime();
//     	expect(post.relativeTime, '2ヶ月前');

//     	post.postDate = DateTime.now().subtract(const Duration(days: 730));
//     	post.formatRelativeTime();
//     	expect(post.relativeTime, '2年前');
//     	});
//   	});
// }
