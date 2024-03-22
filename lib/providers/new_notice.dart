import 'package:flutter/material.dart';

class NewNoticeState with ChangeNotifier {
  bool _newNotice = false;
  bool get newNotice => _newNotice;

  void updateNewNotice(bool newNotice) {
    _newNotice = newNotice;
    notifyListeners();
  }
}
