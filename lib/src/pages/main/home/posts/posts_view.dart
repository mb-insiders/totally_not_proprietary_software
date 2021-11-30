import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insidersapp/src/pages/main/home/posts/bloc/posts_filter_bloc.dart';
import 'package:insidersapp/src/pages/main/home/posts/posts_list.dart';

class PostsView extends StatelessWidget {
  const PostsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> _filters = ['Trending', 'Following', 'Interests'];

    return _PostsFilterBlocProvider(
      filters: _filters,
      child: PostsList(
        filters: _filters,
      ),
    );
  }
}

class _PostsFilterBlocProvider extends StatelessWidget {
  const _PostsFilterBlocProvider(
      {Key? key, required this.child, required this.filters})
      : super(key: key);

  final Widget child;
  final List<String> filters;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return PostsFilterBloc(initialFilterName: filters.first);
      },
      child: child,
    );
  }
}
