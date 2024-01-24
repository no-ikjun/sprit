import 'package:flutter/material.dart';
import 'package:sprit/apis/services/book.dart';

class SelectedBookInfoState with ChangeNotifier {
  BookInfo _selectedBookInfo = const BookInfo(
    bookUuid: '',
    isbn: '',
    title: '',
    authors: [],
    publisher: '',
    translators: [],
    searchUrl: '',
    thumbnail: '',
    content: '',
    publishedAt: '',
    updatedAt: '',
    score: 0,
    star: 0,
    starCount: 0,
  );
  BookInfo get getSelectedBookInfo => _selectedBookInfo;

  void updateSelectedBookUuid(BookInfo selectedBookInfo) {
    _selectedBookInfo = selectedBookInfo;
    notifyListeners();
  }

  void removeSelectedBookUuid() {
    _selectedBookInfo = const BookInfo(
        bookUuid: '',
        isbn: '',
        title: '',
        authors: [],
        publisher: '',
        translators: [],
        searchUrl: '',
        thumbnail: '',
        content: '',
        publishedAt: '',
        updatedAt: '',
        score: 0);
    notifyListeners();
  }
}
