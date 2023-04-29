import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:app_6/config/enums/enums.dart';

import '/models/models.dart';
import '/screens/screens.dart';
import '/widgets/widgets.dart';
import 'package:intl/intl.dart';

class NotificationTile extends StatelessWidget {
  final Notif notification;

  const NotificationTile({
    Key? key,
    required this.notification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: UserProfileImage(
        radius: 18.0,
        outerCircleRadius: 19,
        profileImageUrl: notification.fromUser.profileImageUrl,
      ),
      title: buildNotificationText(),
      subtitle: buildDateText(),
      trailing: buildTrailing(context),
      onTap: () => navigateToProfileScreen(context),
    );
  }

  // Builds the text for the notification.
  Text buildNotificationText() {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: notification.fromUser.username,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          const TextSpan(text: ' '),
          TextSpan(text: getNotificationMessage()),
        ],
      ),
    );
  }

  // Gets the appropriate message for the notification type.
  String getNotificationMessage() {
    switch (notification.type) {
      case NotifType.like:
        return 'a aimé votre post.';
      case NotifType.comment:
        return 'a commenté votre post.';
      case NotifType.follow:
        return 'vous a suivi.';
      default:
        return '';
    }
  }

  // Builds the date text for the notification.
  Text buildDateText() {
    return Text(
      DateFormat.yMd('fr_FR').add_jm().format(notification.date),
      style: TextStyle(
        color: Colors.grey[600],
        fontWeight: FontWeight.w500,
      ),
    );
  }

  // Navigates to the profile screen.
  void navigateToProfileScreen(BuildContext context) {
    Navigator.of(context).pushNamed(
      ProfileScreen.routeName,
      arguments: ProfileScreenArgs(userId: notification.fromUser.id),
    );
  }

  // Builds the trailing widget for the notification.
  Widget buildTrailing(BuildContext context) {
    if (notification.type == NotifType.like || notification.type == NotifType.comment) {
      return buildPostImage(context);
    } else if (notification.type == NotifType.follow) {
      return const SizedBox(
        height: 60.0,
        width: 60.0,
        child: Icon(Icons.person_add),
      );
    }
    return const SizedBox.shrink();
  }

  // Builds the post image for the notification.
  Widget buildPostImage(BuildContext context) {
    return GestureDetector(
      onTap: () => navigateToCommentsScreen(context),
      child: CachedNetworkImage(
        height: 60.0,
        width: 60.0,
        imageUrl: notification.post!.imageUrl,
        fit: BoxFit.cover,
      ),
    );
  }

  // Navigates to the comments screen.
  void navigateToCommentsScreen(BuildContext context) {
    Navigator.of(context).pushNamed(
      CommentsScreen.routeName,
      arguments: CommentsScreenArgs(post: notification.post!),
    );
  }
}
