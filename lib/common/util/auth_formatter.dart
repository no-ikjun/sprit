class AuthFormatter {
  static bool isAllowedId(String id) {
    if (id.length < 5 || id.length > 12) {
      return false;
    }
    return true;
  }

  static bool isAllowedNickname(String nickname) {
    if (nickname.length < 2 || nickname.length > 8) {
      return false;
    }
    return true;
  }

  static bool passwordCheck(String password, String confirmPassword) {
    if (password.isEmpty || password != confirmPassword) {
      return false;
    }
    return true;
  }
}
