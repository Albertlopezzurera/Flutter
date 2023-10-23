import 'package:flutter/foundation.dart';
class UserCredentials with ChangeNotifier{
  String user;
  String password;
  String gender;

  UserCredentials({required this.user, required this.password, required this.gender});
}
