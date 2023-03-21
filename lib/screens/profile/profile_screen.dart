import 'package:app_6/blocs/auth/auth_bloc.dart';
import 'package:app_6/config/colors.dart';
import 'package:app_6/cubits/liked_posts/liked_posts_cubit.dart';
import 'package:app_6/repositories/auth/auth_repository.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
          return Scaffold(
              appBar: AppBar(
                // systemOverlayStyle: SystemUiOverlayStyle.light,
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
                actions: [
                  if (state.isCurrentUser)
                    IconButton(
                      icon: const Icon(Icons.exit_to_app),
                      onPressed: () {
                        context.read<AuthBloc>().add(AuthLogoutRequested());
                        MyApp.navigatorKey.currentState!
                            .pushReplacementNamed(LoginScreen.routeName);
                      },
                    ),
                ],
              ),
              body: _buildBody(state));
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
                child: Column(
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
                ),
              ),
              SliverToBoxAdapter(
                child: TabBar(
                  controller: _tabController,
                  labelColor: Theme.of(context).primaryColor,
                  unselectedLabelColor: Colors.grey,
                  tabs: const [
                    Tab(icon: Icon(Icons.grid_on, size: 28.0)),
                    Tab(icon: Icon(Icons.list, size: 28.0)),
                  ],
                  indicatorWeight: 3.0,
                  onTap: (i) => context
                      .read<ProfileBloc>()
                      .add(ProfileToggleGridView(isGridView: i == 0)),
                ),
              ),
              state.isGridView
                  ? SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 2.0,
                        crossAxisSpacing: 2.0,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final post = state.posts[index];
                          return GestureDetector(
                            onTap: () {},
                            //  => Navigator.of(context).pushNamed(
                            //   CommentsScreen.routeName,
                            //   arguments: CommentsScreenArgs(post: post!),
                            // ),
                            child: CachedNetworkImage(
                              fadeInDuration: const Duration(microseconds: 0),
                              fadeOutDuration: const Duration(microseconds: 0),
                              imageUrl: post!.imageUrl,
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                        childCount: state.posts.length,
                      ),
                    )
                  : SliverToBoxAdapter(
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(24.0, 32.0, 24.0, 0),
                            child: ListView(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              children: [
                                // 4 buttons
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Expanded(
                                            child: buildButton(
                                                state.posts.length, "OOTD")),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                            child: buildButton(0, "BOOTD")),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Expanded(
                                            child: buildButton(
                                                state.user.following,
                                                "ABONNEMENTS")),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                            child: buildButton(
                                                state.user.followers,
                                                "ABONNÉS")),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                // Localisation
                                const Text(
                                  "Localisation",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                const Text(
                                  "Marseille, France",
                                  style: TextStyle(fontSize: 12),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                // Réseaux
                                const Text(
                                  "Réseaux",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(top: 4),
                                      child: const FaIcon(
                                          FontAwesomeIcons.facebook,
                                          color: grey,
                                          size: 20),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(top: 4),
                                      child: const FaIcon(
                                          FontAwesomeIcons.instagram,
                                          color: grey,
                                          size: 20),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(top: 4),
                                      child: const FaIcon(
                                          FontAwesomeIcons.tiktok,
                                          color: grey,
                                          size: 20),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                // A propos
                                const Text(
                                  "A propos",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  state.user.bio,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        );
    }
  }
}
