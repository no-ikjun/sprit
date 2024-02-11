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

  void updateNickname(String nickname) {
    _userInfo = UserInfo(
      userUuid: _userInfo.userUuid,
      userNickname: nickname,
      registerType: _userInfo.registerType,
    );
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
