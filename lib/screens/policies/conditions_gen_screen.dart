import 'package:flutter/material.dart';

class ConditionsGenScreen extends StatelessWidget {
  static const String routeName = '/conditionsgen';

  static Route route() {
    return PageRouteBuilder(
      settings: const RouteSettings(name: routeName),
      transitionDuration: const Duration(seconds: 0),
      pageBuilder: (context, _, __) => const ConditionsGenScreen(),
    );
  }

  const ConditionsGenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('ConditionsGenScreen'),
      ),
    );
  }
}
