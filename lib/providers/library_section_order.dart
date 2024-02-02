import 'package:flutter/material.dart';

enum LibrarySection {
  bookMark,
  bookInfo,
  phrase,
  report,
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
}
