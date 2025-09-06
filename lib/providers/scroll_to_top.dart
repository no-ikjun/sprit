import 'package:flutter/foundation.dart';

class ScrollToTopProvider with ChangeNotifier {
  int? _triggeredIndex;

  int? get triggeredIndex => _triggeredIndex;

  void trigger(int index) {
    _triggeredIndex = index;
    notifyListeners();
  }

  void clear() {
    _triggeredIndex = null;
  }
}
