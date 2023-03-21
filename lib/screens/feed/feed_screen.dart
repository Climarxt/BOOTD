import 'package:app_6/config/colors.dart';
import 'package:app_6/cubits/liked_posts/liked_posts_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../events_screens/events.dart';
import '../profile/widgets/widgets.dart';
import '../search/cubit/search_cubit.dart';
import '/cubits/cubits.dart';
import '/screens/feed/bloc/feed_bloc.dart';
import '/widgets/widgets.dart';

class FeedScreen extends StatefulWidget {
  static const String routeName = '/feed';

  const FeedScreen();

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> with TickerProviderStateMixin {
  late ScrollController _scrollController;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.offset >=
                _scrollController.position.maxScrollExtent &&
            !_scrollController.position.outOfRange &&
            context.read<FeedBloc>().state.status != FeedStatus.paginating) {
          context.read<FeedBloc>().add(FeedPaginatePosts());
        }
      });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 3, vsync: this);

    return BlocConsumer<FeedBloc, FeedState>(
      listener: (context, state) {
        if (state.status == FeedStatus.error) {
          showDialog(
            context: context,
            builder: (context) => ErrorDialog(content: state.failure.message),
          );
        } else if (state.status == FeedStatus.paginating) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Theme.of(context).primaryColor,
              duration: const Duration(seconds: 1),
              content: const Text('Charge plus de posts...'),
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 130,
            centerTitle: true,
            backgroundColor: white,
            iconTheme: const IconThemeData(
              color: black,
            ),
            elevation: 0,
            title: Column(
              children: [
                TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    fillColor: Colors.grey[200],
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: const BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    contentPadding: EdgeInsets.all(5),
                    prefixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        context.read<SearchCubit>().clearSearch();
                        _textController.clear();
                      },
                    ),
                  ),
                  textInputAction: TextInputAction.search,
                  textAlignVertical: TextAlignVertical.center,
                  onSubmitted: (value) {
                    if (value.trim().isNotEmpty) {
                      context.read<SearchCubit>().searchUsers(value.trim());
                    }
                  },
                ),
                SizedBox(height: 12),
                TabBar(
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: couleurBleuClair2),
                    controller: tabController,
                    labelColor: white,
                    unselectedLabelColor: Colors.white.withOpacity(0.20),
                    tabs: tabs),
              ],
            ),
          ),
          body: _buildBody(state),
        );
      },
    );
  }

  Widget _buildBody(FeedState state) {
    switch (state.status) {
      case FeedStatus.loading:
        return const Center(child: CircularProgressIndicator());
      default:
        return RefreshIndicator(
          onRefresh: () async {
            context.read<FeedBloc>().add(FeedFetchPosts());
            context.read<LikedPostsCubit>().clearAllLikedPosts();
          },
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            cacheExtent: 5500,
            controller: _scrollController,
            itemCount: state.posts.length,
            itemBuilder: (BuildContext context, int index) {
              final post = state.posts[index];
              final likedPostsState = context.watch<LikedPostsCubit>().state;
              final isLiked = likedPostsState.likedPostIds.contains(post!.id);
              final recentlyLiked =
                  likedPostsState.recentlyLikedPostIds.contains(post.id);
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: PostView(
                  post: post,
                  isLiked: isLiked,
                  recentlyLiked: recentlyLiked,
                  onLike: () {
                    if (isLiked) {
                      context.read<LikedPostsCubit>().unlikePost(post: post);
                    } else {
                      context.read<LikedPostsCubit>().likePost(post: post);
                    }
                  },
                ),
              );
            },
          ),
        );
    }
  }

  List<Tab> tabs = [
    const Tab(
      child: Text(
        "BOOTD1",
        style: TextStyle(shadows: [
          Shadow(
              // bottomLeft
              offset: Offset(-0.1, -0.1),
              color: Colors.grey),
          Shadow(
              // bottomRight
              offset: Offset(0.1, -0.1),
              color: Colors.grey),
          Shadow(
              // topRight
              offset: Offset(0.1, 0.1),
              color: Colors.grey),
          Shadow(
              // topLeft
              offset: Offset(-0.1, 0.1),
              color: Colors.grey),
        ]),
      ),
    ),
    const Tab(
      child: Text(
        "BOOTD2",
        style: TextStyle(shadows: [
          Shadow(
              // bottomLeft
              offset: Offset(-0.1, -0.1),
              color: Colors.grey),
          Shadow(
              // bottomRight
              offset: Offset(0.1, -0.1),
              color: Colors.grey),
          Shadow(
              // topRight
              offset: Offset(0.1, 0.1),
              color: Colors.grey),
          Shadow(
              // topLeft
              offset: Offset(-0.1, 0.1),
              color: Colors.grey),
        ]),
      ),
    ),
    const Tab(
        child: Text(
      "BOOTD3",
      style: TextStyle(shadows: [
        Shadow(
            // bottomLeft
            offset: Offset(-0.1, -0.1),
            color: Colors.grey),
        Shadow(
            // bottomRight
            offset: Offset(0.1, -0.1),
            color: Colors.grey),
        Shadow(
            // topRight
            offset: Offset(0.1, 0.1),
            color: Colors.grey),
        Shadow(
            // topLeft
            offset: Offset(-0.1, 0.1),
            color: Colors.grey),
      ]),
    )),
  ];
  List<Widget> tabsContent = [
    Container(
      color: couleurBleu,
    ),
    Container(
      color: couleurBleu1,
    ),
    Container(
      color: couleurBleu2,
    ),
  ];
}
