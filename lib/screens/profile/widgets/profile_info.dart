import 'package:flutter/material.dart';
import '../../../widgets/widgets.dart';
import '../bloc/profile_bloc.dart';
import 'widgets.dart';

class ProfileInfo extends StatelessWidget {
  final ProfileState state;
  final BuildContext context;
  const ProfileInfo({super.key, required this.context, required this.state});

  @override
  Widget build(BuildContext context) {
    return _buildProfileInfo(state);
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
          child: ProfileUserBio(
            username: state.user.username,
            bio: state.user.bio,
          ),
        ),
      ],
    );
  }
}
