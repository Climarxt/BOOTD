import 'package:flutter/material.dart';

class PolitiqueConfScreen extends StatelessWidget {
  static const String routeName = '/politiqueconf';

  static Route route() {
    return PageRouteBuilder(
      settings: const RouteSettings(name: routeName),
      transitionDuration: const Duration(seconds: 0),
      pageBuilder: (context, _, __) => const PolitiqueConfScreen(),
    );
  }

  const PolitiqueConfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('PolitiqueConfScreen'),
      ),
    );
  }
}
