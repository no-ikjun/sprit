import 'package:flutter/cupertino.dart';

class AnalyticsIndex with ChangeNotifier {
  int _index = 0;
  int get index => _index;

  void updateIndex(int index) {
    _index = index;
    notifyListeners();
  }

  void reset() {
    _index = 0;
    notifyListeners();
  }
}
