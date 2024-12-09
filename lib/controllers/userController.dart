import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  User? _user;

  UserController(User user) {
    this._user = user;
  }

  String getUserId() {
    return _user!.uid;
  }
}