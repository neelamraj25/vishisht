abstract class CommentsEvent {}

class FetchCommentsEvent extends CommentsEvent {
  final int postId;
  FetchCommentsEvent({required this.postId});
}
