import 'package:flutter/material.dart';
import 'package:sprit/apis/services/user_info.dart';

class UserInfoState with ChangeNotifier {
  UserInfo _userInfo = const UserInfo(
    userUuid: '',
    userNickname: '',
    registerType: '',
  );
  UserInfo get userInfo => _userInfo;

  void updateUserInfo(UserInfo userInfo) {
    _userInfo = userInfo;
    notifyListeners();
  }

  void removeUserInfo() {
    _userInfo = const UserInfo(
      userUuid: '',
      userNickname: '',
      registerType: '',
    );
    notifyListeners();
  }
}
