import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vishisht_project/model/comments_model.dart';
import 'package:vishisht_project/screen/postDetails/bloc/comment_event.dart';
import 'package:vishisht_project/screen/postDetails/bloc/comment_state.dart';

class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  CommentsBloc() : super(CommentsInitial()) {
    on<FetchCommentsEvent>(_fetchComments);
  }

  Future<void> _fetchComments(
      FetchCommentsEvent event, Emitter<CommentsState> emit) async {
    try {
      emit(CommentsLoading());
      final response = await http.get(Uri.parse(
          "https://jsonplaceholder.typicode.com/comments?postId=${event.postId}"));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final comments = data.map((json) => Comments.fromJson(json)).toList();
        emit(CommentsLoaded(comments: comments));
      } else {
        emit(CommentsError(error: "Failed to fetch comments"));
      }
    } catch (e) {
      emit(CommentsError(error: "An error occurred: $e"));
    }
  }
}
