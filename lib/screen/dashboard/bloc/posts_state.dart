
import 'package:vishisht_project/model/posts_model.dart';

abstract class PostsState {}

class PostsInitial extends PostsState {}

class PostsLoading extends PostsState {}

class PostsLoaded extends PostsState {
  final List<Posts> posts;
  final bool hasMore;

  PostsLoaded({required this.posts, required this.hasMore});
}

class PostsError extends PostsState {
  final String message;

  PostsError(this.message);
}
