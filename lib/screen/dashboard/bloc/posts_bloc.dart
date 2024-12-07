import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vishisht_project/model/posts_model.dart';
import 'posts_event.dart';
import 'posts_state.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  static const int postsPerPage = 10;

  PostsBloc() : super(PostsInitial()) {
    on<FetchPostsEvent>(_fetchPosts);
  }

Future<void> _fetchPosts(FetchPostsEvent event, Emitter<PostsState> emit) async {
  if (state is PostsLoaded && !(state as PostsLoaded).hasMore) return;

  try {
    emit(PostsLoading());
    final response = await http.get(
      Uri.parse("https://jsonplaceholder.typicode.com/posts?_start=${(event.page - 1) * postsPerPage}&_limit=$postsPerPage"),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final posts = data.map((json) => Posts.fromJson(json)).toList();

      final currentPosts = state is PostsLoaded ? List<Posts>.from((state as PostsLoaded).posts) : <Posts>[];
      emit(PostsLoaded(posts: currentPosts + posts, hasMore: posts.length == postsPerPage));
    } else {
      emit(PostsError("Failed to fetch posts"));
    }
  } catch (e) {
    emit(PostsError("An error occurred: $e"));
  }
}

}
