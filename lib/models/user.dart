import 'package:mikata/models/post.dart';

class User {
  // public member
    String userName;

  // private member
    final List<Post> _userPosts = [];
    final List<Post> _bookmarkPost = [];
    final List<Post> _likePost = [];

    //public method
    User({required this.userName});

    void addUserPost(Post post) {
        _userPosts.add(post);
    }

    void removeUserPost(Post post) {
        _userPosts.remove(post);
    }

    void addBookmark(Post post) {
        _bookmarkPost.add(post);
    }

    void remove(Post post) {
        _bookmarkPost.remove(post);
    }

    void addLikePost(Post post) {
        _likePost.add(post);
    }

    void removeLikePost(Post post) {
        _likePost.remove(post);
    }

  // private method
}
