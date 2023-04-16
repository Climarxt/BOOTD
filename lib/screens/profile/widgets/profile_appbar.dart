import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/blocs.dart';
import '../../../config/config.dart';
import '../../../main.dart';
import '../../screens.dart';
import '../bloc/profile_bloc.dart';

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  final ProfileState state;
  final BuildContext parentContext;
  const ProfileAppBar(
      {Key? key, required this.parentContext, required this.state})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildProfileAppBar(state);
  }

  AppBar _buildProfileAppBar(ProfileState state) {
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
            parentContext.read<AuthBloc>().add(AuthLogoutRequested());
            MyApp.navigatorKey.currentState!
                .pushReplacementNamed(LoginScreen.routeName);
          },
        ),
      ];
    }
    return [];
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
