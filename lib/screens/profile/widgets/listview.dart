import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../config/config.dart';
import '../bloc/profile_bloc.dart';
import 'widgets.dart';

class PersistentListView extends StatefulWidget {
  final BuildContext context;
  final ProfileState state;

  PersistentListView({required this.context, required this.state});

  @override
  _PersistentListViewState createState() => _PersistentListViewState();
}

class _PersistentListViewState extends State<PersistentListView> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return _buildListView(widget.context, widget.state); // Your existing _buildListView code here
  }
}


  Widget _buildListView(BuildContext context, ProfileState state) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildButtonsSection(state),
          _buildLocationSection(),
          _buildSocialNetworksSection(),
          _buildAboutSection(state),
        ],
      ),
    );
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

  Widget _buildLocationSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        children: [
          const Text(
            "Localisation",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 8,
          ),
          const Text(
            "Marseille, France",
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialNetworksSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        children: [
          const Text(
            "Réseaux",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              FaIcon(FontAwesomeIcons.facebook, color: grey, size: 20),
              FaIcon(FontAwesomeIcons.instagram, color: grey, size: 20),
              FaIcon(FontAwesomeIcons.tiktok, color: grey, size: 20),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(ProfileState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        children: [
          const Text(
            "A propos",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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
    );
  }
