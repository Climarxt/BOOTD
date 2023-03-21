import '/repositories/repositories.dart';
import 'package:flutter/cupertino.dart';
import '../models/models.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  final AuthRepository _authMethods = AuthRepository();

  User get getUser =>
      _user ??
      const User(
          id: "0MR3cHOr3xZXHE2soYgmjX0gOau1",
          username: "ctbast1",
          email: "christianbastide95@gmail.com",
          profileImageUrl:
              "https://firebasestorage.googleapis.com/v0/b/app4-f4c8e.appspot.com/o/profilePics%2F0oCc5CXo49cDqXfMCQPmIdpMehX2?alt=media&token=d2d0cf46-41b5-4498-816a-3e17cdbb2444",
          followers: 0,
          bio:
              " quaerebatur ministris fucandae purpurae tortis confessisque pectoralem tuniculam sine manicis textam",
          following: 0);

  // Future<void> refreshUser() async {
  //   User user = await _authMethods.getUserDetails();
  //   _user = user;
  //   notifyListeners();
  // }
}
