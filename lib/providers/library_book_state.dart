import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum LibraryBookState {
  before,
  reading,
  after,
}

LibraryBookState stringToLibraryBookState(String state) {
  switch (state) {
    case 'LibraryBookState.before':
      return LibraryBookState.before;
    case 'LibraryBookState.reading':
      return LibraryBookState.reading;
    case 'LibraryBookState.after':
      return LibraryBookState.after;
    default:
      return LibraryBookState.before;
  }
}

String getSelectedKindString(List<LibraryBookState> libraryBookState) {
  if (libraryBookState.length > 1) {
    return '${libraryBookState.length}개 선택됨';
  } else {
    if (libraryBookState[0] == LibraryBookState.before) {
      return '읽을 책';
    } else if (libraryBookState[0] == LibraryBookState.reading) {
      return '읽고있는 책';
    } else {
      return '읽은 책';
    }
  }
}

class LibraryBookListState with ChangeNotifier {
  List<LibraryBookState> _libraryBookState = [
    LibraryBookState.reading,
  ];

  List<LibraryBookState> get getLibraryBookState => _libraryBookState;

  void updateLibraryBookState(List<LibraryBookState> libraryBookState) {
    _libraryBookState = libraryBookState;
    notifyListeners();
  }

  void removeLibraryBookState() {
    _libraryBookState = [
      LibraryBookState.reading,
    ];
    notifyListeners();
  }

  Future<void> loadBookStateFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final orderString = prefs.getString('bookState');
    if (orderString != null) {
      try {
        final orderList = json.decode(orderString) as List<dynamic>;
        _libraryBookState =
            orderList.map((item) => stringToLibraryBookState(item)).toList();
        notifyListeners();
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }
}
