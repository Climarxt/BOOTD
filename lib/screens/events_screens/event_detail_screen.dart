import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import '../../models/event.dart';
import '../../providers/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/event.dart';
import '../../repositories/repositories.dart';
import '../screens.dart';
import 'events.dart';
import '../../config/config.dart';

import 'package:provider/provider.dart';

import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:intl/date_symbol_data_local.dart';

class PostEventCard extends StatefulWidget {
  Event? event;

  PostEventCard({Key? key, required this.event}) : super(key: key);

  @override
  State<PostEventCard> createState() => _PostEventCardState();
}

class _PostEventCardState extends State<PostEventCard> {
  late final DateTime dateEventNew = DateTime.fromMicrosecondsSinceEpoch(
      widget.event!.dateEvent.microsecondsSinceEpoch);
  late final String dateEventNewFR = dateFormat.format(dateEventNew);

  bool isLikeAnimating = false;

  int commentLen = 0;

  int participantLen = 0;

  late DateFormat dateFormat;
  late DateFormat timeFormat;

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  void getNombre() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('events')
          .doc(widget.event!.eventId)
          .collection('comments')
          .get();
      commentLen = snap.docs.length;

      QuerySnapshot snap2 = await FirebaseFirestore.instance
          .collection('events')
          .doc(widget.event!.eventId)
          .collection('eventposts')
          .get();
      participantLen = snap2.docs.length;
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    setStateIfMounted(() {});
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    getNombre();
    dateFormat = DateFormat.yMMMMd('fr');
    timeFormat = DateFormat.Hms('fr');
  }

  @override
  Widget build(BuildContext context) {
    // final model.User user = Provider.of<UserProvider>(context).getUser;

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: CachedNetworkImageProvider((widget.event!.eventUrl)),
        ),
      ),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.center,
            end: Alignment.bottomCenter,
            colors: [Colors.black12, Colors.black54],
          ),
        ),
        child: Scaffold(
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: couleurBleuClair2,
            foregroundColor: white,
            onPressed: () {
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (context) =>
              //         EventAddPostScreen(snap: widget.event),
              //   ),
              // );
            },
            label: const Text('Participer'),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(0, 0, 0, 0),
            elevation: 0,
          ),
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Positioned(
                top: 160,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.event!.title,
                          style: const TextStyle(
                              fontSize: 25,
                              color: white,
                              fontWeight: FontWeight.bold,
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
                              ])),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text(dateEventNewFR,
                              style: const TextStyle(
                                  fontSize: 15,
                                  color: white,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(
                            width: 5,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Positioned.directional(
                textDirection: Directionality.of(context),
                end: 10,
                top: 300,
                child: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        "Nombre de participants",
                        style: TextStyle(
                          fontSize: 15,
                          color: white,
                          fontWeight: FontWeight.bold,
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
                      Text(
                        '$participantLen',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white.withOpacity(0.85),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "1er Prix",
                        style: TextStyle(
                          fontSize: 15,
                          color: white,
                          fontWeight: FontWeight.bold,
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
                      Text(widget.event!.reward,
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: white)),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        // User + Détails
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection('users')
                                        .snapshots(),
                                    builder: (context,
                                        AsyncSnapshot<
                                                QuerySnapshot<
                                                    Map<String, dynamic>>>
                                            snapshot) {
                                      return InkWell(
                                        onTap: () {},
                                        // =>
                                        //     Navigator.of(context).push(
                                        //   MaterialPageRoute(
                                        //     builder: (context) =>
                                        //         ProfileScreen(
                                        //       uid: widget.event!.uid,
                                        //     ),
                                        //   ),
                                        // ),
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  widget.event!.profImage),
                                              radius: 20,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              widget.event!.username,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                                const SizedBox(height: 10),
                                Text(
                                  widget.event!.description,
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 80,
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // Commentaires
                              SizedBox(
                                height: 80,
                                child: Column(
                                  children: [
                                    IconButton(
                                      padding: EdgeInsets.zero,
                                      onPressed: () {}, //  =>
                                      //     Navigator.of(context).push(
                                      //   MaterialPageRoute(
                                      //     builder: (context) =>
                                      //         EventCommentsScreen(
                                      //       snap: widget.event,
                                      //     ),
                                      //   ),
                                      // ),
                                      icon: Icon(
                                        Icons.comment_outlined,
                                        color: Colors.white.withOpacity(0.85),
                                        size: 30,
                                      ),
                                    ),
                                    Text(
                                      '$commentLen',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white.withOpacity(0.85),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Partage
                              SizedBox(
                                height: 50,
                                child: Column(
                                  children: [
                                    IconButton(
                                      onPressed: () async {
                                        final uri =
                                            Uri.parse(widget.event!.eventUrl);
                                        final res = await http.get(uri);
                                        final bytes = res.bodyBytes;

                                        final temp =
                                            await getTemporaryDirectory();
                                        final path = '${temp.path}/image.jpg';
                                        File(path).writeAsBytesSync(bytes);

                                        // ignore: deprecated_member_use
                                        await Share.shareFiles([path]);
                                      },
                                      icon: Icon(
                                        Icons.share,
                                        color: Colors.white.withOpacity(0.85),
                                        size: 30,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
