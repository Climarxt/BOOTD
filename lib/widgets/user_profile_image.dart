import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../config/config.dart';

class UserProfileImage extends StatelessWidget {
  final double radius;
  final double radiusbackground;
  final String profileImageUrl;
  final File? profileImage;

  const UserProfileImage({
    Key? key,
    required this.radius,
    required this.radiusbackground,
    required this.profileImageUrl,
    this.profileImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radiusbackground,
      backgroundColor: white,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: Colors.grey[200],
        backgroundImage: profileImage != null
            ? FileImage(profileImage!) as ImageProvider
            : profileImageUrl.isNotEmpty
                ? CachedNetworkImageProvider(profileImageUrl)
                : null,
        child: _noProfileIcon(),
      ),
    );
  }

  Icon? _noProfileIcon() {
    if (profileImage == null && profileImageUrl.isEmpty) {
      return Icon(
        Icons.account_circle,
        color: Colors.grey[400],
        size: radius * 2,
      );
    }
    return null;
  }
}
