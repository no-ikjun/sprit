import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum LibrarySection {
  bookMark,
  bookInfo,
  phrase,
  report,
}

LibrarySection stringToEnum(String section) {
  switch (section) {
    case 'LibrarySection.bookMark':
      return LibrarySection.bookMark;
    case 'LibrarySection.bookInfo':
      return LibrarySection.bookInfo;
    case 'LibrarySection.phrase':
      return LibrarySection.phrase;
    case 'LibrarySection.report':
      return LibrarySection.report;
    default:
      return LibrarySection.bookMark;
  }
}

String getName(LibrarySection librarySection) {
  switch (librarySection) {
    case LibrarySection.bookMark:
      return '책갈피 기능';
    case LibrarySection.bookInfo:
      return '나의 책 정보';
    case LibrarySection.phrase:
      return '저장된 문구(스크랩)';
    case LibrarySection.report:
      return '내가 작성한 독후감';
    default:
      return '';
  }
}

class LibrarySectionOrderState with ChangeNotifier {
  List<LibrarySection> _sectionOrder = [
    LibrarySection.bookMark,
    LibrarySection.bookInfo,
    LibrarySection.phrase,
    LibrarySection.report,
  ];

  List<LibrarySection> get getSectionOrder => _sectionOrder;

  void updateSectionOrder(List<LibrarySection> sectionOrder) {
    _sectionOrder = sectionOrder;
    notifyListeners();
  }

  void removeSectionOrder() {
    _sectionOrder = [
      LibrarySection.bookMark,
      LibrarySection.bookInfo,
      LibrarySection.phrase,
      LibrarySection.report,
    ];
    notifyListeners();
  }

  Future<void> loadOrderFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final orderString = prefs.getString('sectionOrder');
    if (orderString != null) {
      try {
        final orderList = json.decode(orderString) as List<dynamic>;
        _sectionOrder = orderList.map((item) => stringToEnum(item)).toList();
        notifyListeners();
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }
}
