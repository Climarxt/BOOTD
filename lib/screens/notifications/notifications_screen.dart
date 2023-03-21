import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../config/config.dart';
import '/screens/notifications/bloc/notifications_bloc.dart';
import '/screens/notifications/widgets/widgets.dart';
import '/widgets/widgets.dart';

class NotificationsScreen extends StatelessWidget {
  static const String routeName = '/notifications';

  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: mobileBackgroundColor,
        iconTheme: const IconThemeData(
          color: black,
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.message,
              size: 30,
            ),
            onPressed: () {},
          ),
          const SizedBox(
            width: 13,
          ),
        ],
        elevation: 3,
        title: const Text(
          'Notifications',
          style: TextStyle(color: black),
        ),
      ),
      body: BlocBuilder<NotificationsBloc, NotificationsState>(
        builder: (context, state) {
          switch (state.status) {
            case NotificationsStatus.error:
              return CenteredText(text: state.failure.message);
            case NotificationsStatus.loaded:
              return ListView.builder(
                itemCount: state.notifications.length,
                itemBuilder: (BuildContext context, int index) {
                  final notification = state.notifications[index];
                  return NotificationTile(notification: notification!);
                },
              );
            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
