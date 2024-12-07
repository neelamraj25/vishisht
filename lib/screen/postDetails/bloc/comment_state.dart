import 'package:vishisht_project/model/comments_model.dart';

abstract class CommentsState {}

class CommentsInitial extends CommentsState {}

class CommentsLoading extends CommentsState {}

class CommentsLoaded extends CommentsState {
  final List<Comments> comments;
  CommentsLoaded({required this.comments});
}

class CommentsError extends CommentsState {
  final String error;
  CommentsError({required this.error});
}
