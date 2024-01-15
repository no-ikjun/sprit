import 'package:flutter/cupertino.dart';

class FcmTokenState with ChangeNotifier {
  String _fcmToken = '';
  String get fcmToken => _fcmToken;

  void updateFcmToken(String fcmToken) {
    _fcmToken = fcmToken;
    notifyListeners();
  }

  void removeFcmToken() {
    _fcmToken = '';
    notifyListeners();
  }
}
