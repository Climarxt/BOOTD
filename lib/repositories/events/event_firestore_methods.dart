import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_helpers/firebase_helpers.dart';

import '../../models/models.dart';
import '../../config/config.dart';
import 'storage_methods.dart';

class EventFirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Upload Event
  Future<String> uploadEvent(
    String description,
    String title,
    Uint8List file,
    String uid,
    String username,
    String profImage,
    String dateEvent,
    String reward,
  ) async {
    String res = "some error occured";
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('events', file, true);

      String eventId = const Uuid().v1();

      DateTime tempDate =
          new DateFormat("yyyy-MM-dd hh:mm:ss").parse(dateEvent);

      Event post = Event(
        description: description,
        title: title,
        uid: uid,
        username: username,
        eventId: eventId,
        datePublished: DateTime.now(),
        eventUrl: photoUrl,
        profImage: profImage,
        dateEvent: tempDate,
        reward: reward,
      );

      _firestore.collection('events').doc(eventId).set(
            post.toJson(),
          );

      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Post Event comment
  Future<void> postEventComment(String eventId, String text, String uid,
      String username, String profilePic) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        // if the likes list contains the user uid, we need to remove it
        String commentId = const Uuid().v1();
        await _firestore
            .collection('events')
            .doc(eventId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'username': username,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
      } else {
        print('Text is empty');
      }
    } catch (e) {
      print(
        e.toString(),
      );
    }
  }

  // Delete Event
  Future<String> deleteEvent(String eventId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('posts').doc(eventId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Like Event
  Future<String> likeEvent(String eventId, String uid, List likes) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(uid)) {
        // if the likes list contains the user uid, we need to remove it
        _firestore.collection('events').doc(eventId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        // else we need to add uid to the likes arra y
        _firestore.collection('events').doc(eventId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

// Upload Event Post
  // Future<String> uploadEventPost(
  //   String description,
  //   Uint8List file,
  //   String uid,
  //   String username,
  //   String profImage,
  //   String eventId,
  // ) async {
  //   String res = "some error occured";
  //   try {
  //     String photoUrl =
  //         await StorageMethods().uploadImageToStorage('posts', file, true);

  //     String postId = const Uuid().v1();

  //     Post post = Post(
  //       description: description,
  //       uid: uid,
  //       username: username,
  //       postId: postId,
  //       datePublished: DateTime.now(),
  //       postUrl: photoUrl,
  //       profImage: profImage,
  //       likes: [],
  //     );

  //     _firestore
  //         .collection('events')
  //         .doc(eventId)
  //         .collection('eventposts')
  //         .doc(postId)
  //         .set(
  //           post.toJson(),
  //         );

  //     res = 'success';
  //   } catch (err) {
  //     res = err.toString();
  //   }
  //   return res;
  // }
}

final eventDBS = DatabaseService<Event>(
  AppDBConstants.eventsCollection,
  fromDS: (id, data) => Event.fromDS(id, data!),
  toMap: (event) => event.toMap(),
);
