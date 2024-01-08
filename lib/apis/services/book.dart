import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sprit/apis/auth_dio.dart';

class PopularbookResponse {
  final List<dynamic> books;
  final bool moreAvailable;

  const PopularbookResponse({
    required this.books,
    required this.moreAvailable,
  });

  PopularbookResponse.fromJson(Map<String, dynamic> json)
      : books = json['books'],
        moreAvailable = json['more_available'];
  Map<String, dynamic> toJson() => {
        'books': books,
        'moreAvailable': moreAvailable,
      };
}

class BookInfo {
  final String bookUuid;
  final String isbn;
  final String title;
  final List<String> authors;
  final String publisher;
  final List<String> translators;
  final String searchUrl;
  final String thumbnail;
  final String content;
  final String publishedAt;
  final String updatedAt;
  final int score;

  const BookInfo({
    required this.bookUuid,
    required this.isbn,
    required this.title,
    required this.authors,
    required this.publisher,
    required this.translators,
    required this.searchUrl,
    required this.thumbnail,
    required this.content,
    required this.publishedAt,
    required this.updatedAt,
    required this.score,
  });

  BookInfo.fromJson(Map<String, dynamic> json)
      : bookUuid = json['book_uuid'],
        isbn = json['isbn'],
        title = json['title'],
        authors = jsonDecode(json['authors']).cast<String>(),
        publisher = json['publisher'],
        translators = jsonDecode(json['translators']).cast<String>(),
        searchUrl = json['search_url'],
        thumbnail = json['thumbnail'],
        content = json['content'],
        publishedAt = json['published_at'],
        updatedAt = json['updated_at'],
        score = json['score'];
  Map<String, dynamic> toJson() => {
        'book_uuid': bookUuid,
        'isbn': isbn,
        'title': title,
        'authors': authors,
        'publisher': publisher,
        'translators': translators,
        'search_url': searchUrl,
        'thumbnail': thumbnail,
        'content': content,
        'published_at': publishedAt,
        'updated_at': updatedAt,
        'score': score,
      };
}

class BookInfoService {
  static Future<BookInfo> getBookInfoByISBN(
    BuildContext context,
    String isbn,
  ) async {
    BookInfo bookInfo = const BookInfo(
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
    );
    final dio = await authDio(context);
    try {
      final response = await dio.get(
        '/book/find/isbn',
        queryParameters: {
          'isbn': isbn,
        },
      );
      if (response.statusCode == 200) {
        bookInfo = BookInfo.fromJson(response.data);
      } else {
        debugPrint('도서 정보 조회 실패');
      }
    } catch (e) {
      debugPrint('도서 정보 조회 실패 $e');
    }
    return bookInfo;
  }

  static Future<BookInfo> getBookInfoByUuid(
    BuildContext context,
    String uuid,
  ) async {
    BookInfo bookInfo = const BookInfo(
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
    );
    final dio = await authDio(context);
    try {
      final response = await dio.get(
        '/book/find/uuid',
        queryParameters: {
          'book_uuid': uuid,
        },
      );
      if (response.statusCode == 200) {
        bookInfo = BookInfo.fromJson(response.data);
      } else {
        debugPrint('도서 정보 조회 실패');
      }
    } catch (e) {
      debugPrint('도서 정보 조회 실패 $e');
    }
    return bookInfo;
  }

  static Future<void> registerBook(
    BuildContext context,
    String isbn,
  ) async {
    final dio = await authDio(context);
    try {
      final response = await dio.post(
        '/book/register',
        queryParameters: {
          'isbn': isbn,
        },
      );
      if (response.statusCode == 201) {
        debugPrint('도서 등록 성공');
      } else {
        debugPrint('도서 등록 실패');
      }
    } catch (e) {
      debugPrint('도서 등록 실패 $e');
    }
  }

  static Future<Map<String, dynamic>> getPopularBook(
    BuildContext context,
    int page,
  ) async {
    List<BookInfo> bookInfoList = [];
    bool moreAvailable = false;
    final dio = await authDio(context);
    try {
      final response = await dio.get(
        '/book/popular',
        queryParameters: {
          'page': page,
        },
      );
      if (response.statusCode == 200) {
        var result = PopularbookResponse.fromJson(response.data);
        moreAvailable = result.moreAvailable;
        for (var book in result.books) {
          bookInfoList.add(BookInfo.fromJson(book));
        }
      } else {
        debugPrint('도서 검색 실패');
      }
    } catch (e) {
      debugPrint('도서 검색 실패 $e');
    }
    return {
      'books': bookInfoList,
      'more_available': moreAvailable,
    };
  }
}
