import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../config/config.dart';
import '../screens/comments/comments_screen.dart';
import '/extensions/extensions.dart';
import '/models/models.dart';
import '/screens/screens.dart';
import '/widgets/widgets.dart';

class PostView extends StatelessWidget {
  final Post post;
  final bool isLiked;
  final VoidCallback onLike;
  final bool recentlyLiked;

  const PostView({
    Key? key,
    required this.post,
    required this.isLiked,
    required this.onLike,
    this.recentlyLiked = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        height: MediaQuery.of(context).size.height / 1.5,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: CachedNetworkImageProvider((post.imageUrl)),
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.grey,
                offset: Offset(0, 3), // hide shadow top
                blurRadius: 6),
          ],
        ),
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 75,
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            // leading: IconButton(
            //   icon: const Icon(
            //     Icons.more_vert,
            //     color: white,
            //     size: 30,
            //   ),
            //   onPressed: () {},
            // ),
            title: Column(children: [
              const SizedBox(
                height: 8,
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).pushNamed(
                  ProfileScreen.routeName,
                  arguments: ProfileScreenArgs(userId: post.author.id),
                ),
                child: UserProfileImage(
                  radius: 22.0,
                  radiusbackground: 23,
                  profileImageUrl: post.author.profileImageUrl,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                post.author.username,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: white,
                  shadows: [
                    Shadow(
                        // bottomLeft
                        offset: Offset(-0.2, -0.2),
                        color: Colors.grey),
                    Shadow(
                        // bottomRight
                        offset: Offset(0.2, -0.2),
                        color: Colors.grey),
                    Shadow(
                        // topRight
                        offset: Offset(0.2, 0.2),
                        color: Colors.grey),
                    Shadow(
                        // topLeft
                        offset: Offset(-0.2, 0.2),
                        color: Colors.grey),
                  ],
                ),
              ),
            ]),
          ),
          backgroundColor: Colors.transparent,
          body: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    const Spacer(),
                    Column(
                      children: [
                        IconButton(
                          icon: isLiked
                              ? const Icon(Icons.favorite, color: Colors.red)
                              : const Icon(
                                  Icons.favorite,
                                  color: white,
                                ),
                          onPressed: onLike,
                        ),
                        Text(
                          '${recentlyLiked ? post.likes + 1 : post.likes}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: white,
                            shadows: [
                              Shadow(
                                  // bottomLeft
                                  offset: Offset(-0.2, -0.2),
                                  color: Colors.grey),
                              Shadow(
                                  // bottomRight
                                  offset: Offset(0.2, -0.2),
                                  color: Colors.grey),
                              Shadow(
                                  // topRight
                                  offset: Offset(0.2, 0.2),
                                  color: Colors.grey),
                              Shadow(
                                  // topLeft
                                  offset: Offset(-0.2, 0.2),
                                  color: Colors.grey),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 38,
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.comment_outlined,
                            color: white,
                          ),
                          onPressed: () => Navigator.of(context).pushNamed(
                            CommentsScreen.routeName,
                            arguments: CommentsScreenArgs(post: post),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
