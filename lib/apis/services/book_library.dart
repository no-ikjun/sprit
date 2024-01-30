import 'package:flutter/cupertino.dart';
import 'package:sprit/apis/auth_dio.dart';
import 'package:sprit/apis/services/book.dart';

class BookMarkCallback {
  final List<BookMarkInfo> bookMarkInfoList;
  final bool moreAvailable;

  BookMarkCallback({
    required this.bookMarkInfoList,
    required this.moreAvailable,
  });
}

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

class BookMarkInfo {
  final String bookUuid;
  final String thumbnail;
  final int lastPage;
  const BookMarkInfo({
    required this.bookUuid,
    required this.thumbnail,
    required this.lastPage,
  });

  BookMarkInfo.fromJson(Map<String, dynamic> json)
      : bookUuid = json['book_uuid'],
        thumbnail = json['thumbnail'],
        lastPage = json['last_page'];

  Map<String, dynamic> toJson() => {
        'book_uuid': bookUuid,
        'thumbnail': thumbnail,
        'last_page': lastPage,
      };
}

class BookMarkResponse {
  final List<dynamic> bookMarkInfo;
  final bool moreAvailable;
  const BookMarkResponse({
    required this.bookMarkInfo,
    required this.moreAvailable,
  });

  BookMarkResponse.fromJson(Map<String, dynamic> json)
      : bookMarkInfo = json['book_marks'],
        moreAvailable = json['more_available'];

  Map<String, dynamic> toJson() => {
        'book_marks': bookMarkInfo,
        'more_available': moreAvailable,
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

  static Future<BookLibraryInfo> findBookLibrary(
    BuildContext context,
    String bookUuid,
  ) async {
    BookLibraryInfo bookLibraryInfo = const BookLibraryInfo(
      libraryRegisterUuid: '',
      userUuid: '',
      bookUuid: '',
      state: '',
      createdAt: '',
      updatedAt: '',
    );
    final dio = await authDio(context);
    try {
      final response = await dio.get(
        '/book-library/find',
        queryParameters: {
          'book_uuid': bookUuid,
        },
      );
      if (response.statusCode == 200) {
        var result = response.data;
        bookLibraryInfo = BookLibraryInfo.fromJson(result);
      } else {
        debugPrint('도서 등록 정보 조회 실패');
      }
    } catch (e) {
      debugPrint('도서 등록 정보 조회 실패 $e');
    }
    return bookLibraryInfo;
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
        debugPrint('$state 도서 등록 정보 조회 실패 (상태별)');
      }
    } catch (e) {
      debugPrint('$state 도서 등록 정보 조회 실패 (상태별) $e');
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

  static Future<BookMarkCallback> getBookMark(
    BuildContext context,
    int page,
  ) async {
    List<BookMarkInfo> bookMarkInfoList = [];
    bool moreAvailable = false;
    final dio = await authDio(context);
    try {
      final response = await dio.get(
        '/book-library/bookmark',
        queryParameters: {
          'page': page.toString(),
        },
      );
      if (response.statusCode == 200) {
        var result = BookMarkResponse.fromJson(response.data);
        moreAvailable = result.moreAvailable;
        for (var book in result.bookMarkInfo) {
          bookMarkInfoList.add(BookMarkInfo.fromJson(book));
        }
      } else {
        debugPrint('북마크 조회 실패');
      }
    } catch (e) {
      debugPrint('북마크 조회 실패 $e');
    }
    return BookMarkCallback(
      bookMarkInfoList: bookMarkInfoList,
      moreAvailable: moreAvailable,
    );
  }
}
