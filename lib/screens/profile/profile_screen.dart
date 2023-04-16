import 'package:app_6/blocs/auth/auth_bloc.dart';
import 'package:app_6/config/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../main.dart';
import '../../repositories/repositories.dart';
import '../../widgets/widgets.dart';
import '../screens.dart';
import 'bloc/profile_bloc.dart';
import 'widgets/button.dart';
import 'widgets/widgets.dart';

class ProfileScreenArgs {
  final String userId;

  const ProfileScreenArgs({required this.userId});
}

class ProfileScreen extends StatefulWidget {
  static const String routeName = '/profile';
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();

  static Route route({required ProfileScreenArgs args}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider<ProfileBloc>(
        create: (context) => ProfileBloc(
          userRepository: context.read<UserRepository>(),
          postRepository: context.read<PostRepository>(),
          authBloc: context.read<AuthBloc>(),
        )..add(ProfileLoadUser(userId: args.userId)),
        child: const ProfileScreen(),
      ),
    );
  }
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state.status == ProfileStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state.status == ProfileStatus.loaded) {
          return Scaffold(appBar: _buildAppBar(state), body: _buildBody(state));
        } else {
          return const Text(
            'Something went wrong.',
            style: TextStyle(color: white),
          );
        }
      },
    );
  }

  AppBar _buildAppBar(ProfileState state) {
    return AppBar(
      backgroundColor: mobileBackgroundColor,
      iconTheme: const IconThemeData(
        color: black,
      ),
      elevation: 3,
      centerTitle: true,
      title: Text(
        state.user.username,
        style: const TextStyle(color: black),
      ),
      actions: _buildAppBarActions(state),
    );
  }

  List<Widget> _buildAppBarActions(ProfileState state) {
    if (state.isCurrentUser) {
      return [
        IconButton(
          icon: const Icon(Icons.exit_to_app),
          onPressed: () {
            context.read<AuthBloc>().add(AuthLogoutRequested());
            MyApp.navigatorKey.currentState!
                .pushReplacementNamed(LoginScreen.routeName);
          },
        ),
      ];
    }
    return [];
  }

  Widget _buildBody(ProfileState state) {
    switch (state.status) {
      case ProfileStatus.loading:
        return const Center(child: CircularProgressIndicator());
      default:
        return RefreshIndicator(
          onRefresh: () async {
            context
                .read<ProfileBloc>()
                .add(ProfileLoadUser(userId: state.user.id));
          },
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildProfileInfo(state)),
              SliverToBoxAdapter(child: _buildTabBar(context, state)),
              SliverFillRemaining(child: _buildTabBarView(context, state)),
            ],
          ),
        );
    }
  }

  Widget _buildProfileInfo(ProfileState state) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0),
          child: Row(
            children: [
              UserProfileImage(
                radius: 40.0,
                radiusbackground: 41,
                profileImageUrl: state.user.profileImageUrl,
              ),
              ProfileStats(
                isCurrentUser: state.isCurrentUser,
                isFollowing: state.isFollowing,
                posts: state.posts.length,
                followers: state.user.followers,
                following: state.user.following,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10.0,
          ),
          child: ProfileInfo(
            username: state.user.username,
            bio: state.user.bio,
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar(BuildContext context, ProfileState state) {
    return TabBar(
      controller: _tabController,
      labelColor: Theme.of(context).primaryColor,
      unselectedLabelColor: Colors.grey,
      tabs: const [
        Tab(icon: Icon(Icons.grid_on, size: 28.0)),
        Tab(icon: Icon(Icons.list, size: 28.0)),
      ],
      indicatorWeight: 3.0,
      onTap: (i) {
        setState(() {
          _currentIndex = i;
        });
        context
            .read<ProfileBloc>()
            .add(ProfileToggleGridView(isGridView: i == 0));
      },
    );
  }

  Widget _buildTabBarView(BuildContext context, ProfileState state) {
    return TabBarView(
      controller: _tabController,
      children: [
        PersistentGridView(
            context: context,
            state: state), 
        PersistentListView(
            context: context,
            state: state),
      ],
    );
  }
}
