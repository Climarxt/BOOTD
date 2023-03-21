import 'package:flutter/material.dart';
import '../screens/comments/comments_screen.dart';
import '../screens/events_screens/events.dart';
import '../screens/screens.dart';

class CustomRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    print('Route: ${settings.name}');
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          settings: const RouteSettings(name: '/'),
          builder: (_) => const Scaffold(),
        );
      case SplashScreen.routeName:
        return SplashScreen.route();
      case LoginScreen.routeName:
        return LoginScreen.route();
      case SignupScreen.routeName:
        return SignupScreen.route();
      case SignupDemoScreen.routeName:
        return SignupDemoScreen.route();
      case NavScreen.routeName:
        return NavScreen.route();
      case LoginHelpScreen.routeName:
        return LoginHelpScreen.route();
      case LoginMailScreen.routeName:
        return LoginMailScreen.route();
      case PolitiqueConfScreen.routeName:
        return PolitiqueConfScreen.route();
      case ConditionsGenScreen.routeName:
        return ConditionsGenScreen.route();

      default:
        return _errorRoute();
    }
  }

  static Route onGenerateNestedRoute(RouteSettings settings) {
    print('Nested Route: ${settings.name}');
    switch (settings.name) {
      case ProfileScreen.routeName:
        return ProfileScreen.route(
          args: settings.arguments as ProfileScreenArgs,
        );
      case EditProfileScreen.routeName:
        return EditProfileScreen.route(
          args: settings.arguments as EditProfileScreenArgs,
        );
      case EventCalendarScreen.routeName:
        return EventCalendarScreen.route();
      case CommentsScreen.routeName:
        return CommentsScreen.route(
          args: settings.arguments as CommentsScreenArgs,
        );
      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: '/error'),
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('Something went wrong!'),
        ),
      ),
    );
  }
}
