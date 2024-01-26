import 'package:flutter/cupertino.dart';
import 'package:sprit/apis/auth_dio.dart';
import 'package:sprit/apis/services/book.dart';

class BookLibraryInfo {
  final String libraryRegisterUuid;
  final String userUuid;
  final String bookUuid;
  final String state;
  final String createdAt;
  final String updatedAt;
  const BookLibraryInfo({
    required this.libraryRegisterUuid,
    required this.userUuid,
    required this.bookUuid,
    required this.state,
    required this.createdAt,
    required this.updatedAt,
  });

  BookLibraryInfo.fromJson(Map<String, dynamic> json)
      : libraryRegisterUuid = json['library_register_uuid'],
        userUuid = json['user_uuid'],
        bookUuid = json['book_uuid'],
        state = json['state'],
        createdAt = json['created_at'],
        updatedAt = json['updated_at'];
  Map<String, dynamic> toJson() => {
        'library_register_uuid': libraryRegisterUuid,
        'user_uuid': userUuid,
        'book_uuid': bookUuid,
        'state': state,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}

class BookLibraryService {
  static Future<bool> setBookLibrary(
    BuildContext context,
    String bookUuid,
    String state,
  ) async {
    final dio = await authDio(context);
    try {
      final response = await dio.post(
        '/book-library/register',
        data: {
          'book_uuid': bookUuid,
          'state': state,
        },
      );
      if (response.statusCode == 201 && response.data == 'true') {
        return true;
      } else {
        debugPrint('도서 정보 등록 실패');
        return false;
      }
    } catch (e) {
      debugPrint('도서 정보 등록 실패 $e');
      return false;
    }
  }

  static Future<List<BookInfo>> getBookLibrary(
    BuildContext context,
    String state,
  ) async {
    List<BookInfo> beforeBookLibrary = [];
    final dio = await authDio(context);
    String stateUrl = 'before';
    if (state == 'BEFORE') {
      stateUrl = 'before';
    } else if (state == 'READING') {
      stateUrl = 'reading';
    } else if (state == 'AFTER') {
      stateUrl = 'after';
    }
    try {
      final response = await dio.get(
        '/book-library/$stateUrl',
      );
      if (response.statusCode == 200) {
        var result = response.data;
        for (var book in result) {
          beforeBookLibrary.add(BookInfo.fromJson(book));
        }
      } else {
        debugPrint('$state 도서 정보 조회 실패');
      }
    } catch (e) {
      debugPrint('$state 도서 정보 조회 실패 $e');
    }
    return beforeBookLibrary;
  }

  static Future<bool> deleteBookLibrary(
    BuildContext context,
    String bookUuid,
  ) async {
    final dio = await authDio(context);
    try {
      final response = await dio.delete(
        '/book-library/delete',
        queryParameters: {
          'book_uuid': bookUuid,
        },
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        debugPrint('도서 정보 삭제 실패');
        return false;
      }
    } catch (e) {
      debugPrint('도서 정보 삭제 실패 $e');
      return false;
    }
  }

  static Future<bool> updateBookLibrary(
    BuildContext context,
    String bookUuid,
    String state,
  ) async {
    final dio = await authDio(context);
    try {
      final response = await dio.patch(
        '/book-library/update',
        data: {
          'book_uuid': bookUuid,
          'state': state,
        },
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        debugPrint('도서 정보 수정 실패');
        return false;
      }
    } catch (e) {
      debugPrint('도서 정보 수정 실패 $e');
      return false;
    }
  }
}
