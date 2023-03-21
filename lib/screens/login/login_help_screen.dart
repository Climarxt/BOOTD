import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/repositories.dart';
import 'cubit/login_cubit.dart';

class LoginHelpScreen extends StatelessWidget {
  static const String routeName = '/loginhelp';

  static Route route() {
    return PageRouteBuilder(
        settings: const RouteSettings(name: routeName),
        transitionDuration: const Duration(seconds: 0),
        pageBuilder: (context, _, __) => BlocProvider<LoginCubit>(
              create: (_) =>
                  LoginCubit(authRepository: context.read<AuthRepository>()),
              child: const LoginHelpScreen(),
            ));
  }

  const LoginHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('LoginHelpScreen')),
    );
  }
}
