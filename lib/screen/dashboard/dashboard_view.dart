import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vishisht_project/constant/colors_constants.dart';
import 'package:vishisht_project/constant/string_constants.dart';
import 'package:vishisht_project/screen/authenication/bloc/authenication_bloc.dart';
import 'package:vishisht_project/screen/authenication/bloc/authenication_event.dart';
import 'package:vishisht_project/screen/postDetails/post_details_view.dart';
import 'package:vishisht_project/screen/theme/theme_bloc.dart';
import 'package:vishisht_project/screen/theme/theme_event.dart';
import 'bloc/posts_bloc.dart';
import 'bloc/posts_event.dart';
import 'bloc/posts_state.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late PostsBloc _postsBloc;
  late ScrollController _scrollController;
  int _currentPage = 1;
  bool _isFetching = false;

  @override
  void initState() {
    super.initState();
    _postsBloc = PostsBloc()..add(FetchPostsEvent(_currentPage));
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_isFetching) {
      _isFetching = true;
      _currentPage++;
      _postsBloc.add(FetchPostsEvent(_currentPage));
    }
  }

  @override
  void dispose() {
    _postsBloc.close();
    _scrollController.dispose();
    super.dispose();
  }

  Future<String?> _getEmail() async {
  final prefs = await SharedPreferences.getInstance();
  final email = prefs.getString('email');
  print("Fetched email: $email"); 
  return email;
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [lightBlue, blue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
     StringConstants.dashBoard,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6, color: white),
            onPressed: () {
              context.read<ThemeBloc>().add(ToggleThemeEvent());
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: white),
            onPressed: () {
              context.read<AuthenticationBloc>().add(LogoutEvent());
            },
          ),
        ],
      ),
      body: FutureBuilder<String?>(
        future: _getEmail(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final email = snapshot.data ?? "Guest";

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
           Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            shadowColor: Colors.blueAccent.withOpacity(0.5),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Color(0xFF6DD5FA),
                    child: Icon(
                      Icons.person,
                      size: 35,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      "Welcome, $email", 
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),  Expanded(
                child: BlocBuilder<PostsBloc, PostsState>(
                  bloc: _postsBloc,
                  builder: (context, state) {
                    if (state is PostsLoading && state is! PostsLoaded) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is PostsLoaded) {
                      return RefreshIndicator(
                        onRefresh: () async {
                          _currentPage = 1;
                          _postsBloc.add(FetchPostsEvent(_currentPage));
                        },
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: state.posts.length + (state.hasMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index >= state.posts.length) {
                              return const Center(child: CircularProgressIndicator());
                            }

                            final post = state.posts[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                shadowColor: Colors.black.withOpacity(0.1),
                                child: ListTile(
                                  title: Text(
                                    post.title ?? "",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      (post.body ?? "").split('\n').first,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PostDetailsScreen(
                                          title: post.title ?? "",
                                          body: post.body ?? "",
                                          postId: post.id ?? 0,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    } else if (state is PostsError) {
                      return Center(child: Text(state.message));
                    }

                    return const Center(
                      child: Text(
                       StringConstants.noPostsAvailable,
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),

    
    );
  }


}
