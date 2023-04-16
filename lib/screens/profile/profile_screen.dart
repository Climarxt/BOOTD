import 'package:app_6/blocs/auth/auth_bloc.dart';
import 'package:app_6/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/repositories.dart';
import 'bloc/profile_bloc.dart';
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
  bool _forceLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Forcer le chargement du CircularProgressIndicator pendant x secondes
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _forceLoading = false;
      });
    });
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
        if (_forceLoading) {
          return Scaffold(
            appBar: ProfileAppBar(parentContext: context, state: state),
            body: Stack(
              children: [
                Offstage(
                  child: _buildBody(state),
                ),
                const Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            ),
          );
        }
        if (state.status == ProfileStatus.loaded) {
          return Scaffold(
            appBar: ProfileAppBar(parentContext: context, state: state),
            body: _buildBody(state),
          );
        } else {
          return const Text(
            'Something went wrong.',
            style: TextStyle(color: white),
          );
        }
      },
    );
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
              SliverToBoxAdapter(
                  child: ProfileInfo(context: context, state: state)),
              SliverToBoxAdapter(child: _buildTabBar(context, state)),
              SliverFillRemaining(child: _buildTabBarView(context, state)),
            ],
          ),
        );
    }
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
        PersistentGridView(context: context, state: state),
        PersistentListView(context: context, state: state),
      ],
    );
  }
}
