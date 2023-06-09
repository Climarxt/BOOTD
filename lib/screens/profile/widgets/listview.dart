import 'package:flutter/material.dart';
import '../bloc/profile_bloc.dart';
import 'widgets.dart';

class PersistentListView extends StatefulWidget {
  final BuildContext context;
  final ProfileState state;

  const PersistentListView(
      {super.key, required this.context, required this.state});

  @override
  // ignore: library_private_types_in_public_api
  _PersistentListViewState createState() => _PersistentListViewState();
}

class _PersistentListViewState extends State<PersistentListView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _buildListView(widget.context, widget.state);
  }
}

Widget _buildListView(BuildContext context, ProfileState state) {
  return SingleChildScrollView(
    child: Column(
      children: [
        ButtonsSection(state: state),
        LocationSection(location: state.user.username),
        const SocialNetSection(),
        AboutSection(state: state),
      ],
    ),
  );
}
