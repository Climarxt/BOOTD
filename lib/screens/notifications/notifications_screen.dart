import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../config/config.dart';
import '../../models/models.dart';
import '/screens/notifications/bloc/notifications_bloc.dart';
import '/screens/notifications/widgets/widgets.dart';
import '/widgets/widgets.dart';

// This class represents the Notifications screen in the application.
class NotificationsScreen extends StatelessWidget {
  static const String routeName = '/notifications';

  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildNotificationsList(),
    );
  }

  // Builds and returns the AppBar for the Notifications screen.
  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: true,
      backgroundColor: mobileBackgroundColor,
      iconTheme: const IconThemeData(color: black),
      actions: const <Widget>[
        Icon(Icons.message, size: 30),
        SizedBox(width: 13),
      ],
      elevation: 3,
      title: const Text('Notifications', style: TextStyle(color: black)),
    );
  }

  // Builds and returns the notifications list by handling different states.
  Widget _buildNotificationsList() {
    return BlocBuilder<NotificationsBloc, NotificationsState>(
      builder: (context, state) {
        switch (state.status) {
          case NotificationsStatus.error:
            return _buildErrorMessage(state.failure.message);
          case NotificationsStatus.loaded:
            return _buildLoadedNotificationsList(state.notifications);
          default:
            return _buildLoadingIndicator();
        }
      },
    );
  }

  // Builds and returns a widget displaying an error message.
  Widget _buildErrorMessage(String message) {
    return CenteredText(text: message);
  }

  // Builds and returns the list of notifications when the state is loaded.
  Widget _buildLoadedNotificationsList(List<Notif?> notifications) {
    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (BuildContext context, int index) {
        final notification = notifications[index];
        if (notification == null) {
          return Container();
        }
        return NotificationTile(notification: notification);
      },
    );
  }

  // Builds and returns a loading indicator when the state is not yet loaded.
  Widget _buildLoadingIndicator() {
    return const Center(child: CircularProgressIndicator());
  }
}
