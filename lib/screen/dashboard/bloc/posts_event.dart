abstract class PostsEvent {}

class FetchPostsEvent extends PostsEvent {
  final int page;

  FetchPostsEvent(this.page);
}
