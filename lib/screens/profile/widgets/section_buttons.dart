import 'package:flutter/material.dart';
import '../bloc/profile_bloc.dart';
import 'widgets.dart';

class ButtonsSection extends StatelessWidget {
  final ProfileState state;

  const ButtonsSection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return _buildButtonsSection(state);
  }

  Widget _buildButtonsSection(ProfileState state) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 32.0, 24.0, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildTwoButtons(state.posts.length, "OOTD", 0, "BOOTD"),
          const SizedBox(
            height: 10,
          ),
          _buildTwoButtons(state.user.following, "ABONNEMENTS",
              state.user.followers, "ABONNÉS"),
        ],
      ),
    );
  }

  Widget _buildTwoButtons(
      int count1, String label1, int count2, String label2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(child: buildButton(count1, label1)),
        const SizedBox(
          width: 10,
        ),
        Expanded(child: buildButton(count2, label2)),
      ],
    );
  }
}
