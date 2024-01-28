import 'package:flutter/cupertino.dart';
import 'package:sprit/apis/auth_dio.dart';

class BookReportInfo {
  final String bookReportUuid;
  final String bookUuid;
  final String userUuid;
  final String report;
  final String createdAt;
  const BookReportInfo({
    required this.bookReportUuid,
    required this.bookUuid,
    required this.userUuid,
    required this.report,
    required this.createdAt,
  });

  factory BookReportInfo.fromJson(Map<String, dynamic> json) {
    return BookReportInfo(
      bookReportUuid: json['book_report_uuid'] as String,
      bookUuid: json['book_uuid'] as String,
      userUuid: json['user_uuid'] as String,
      report: json['report'] as String,
      createdAt: json['created_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'book_report_uuid': bookReportUuid,
      'book_uuid': bookUuid,
      'user_uuid': userUuid,
      'report': report,
      'created_at': createdAt,
    };
  }
}

class BookReportService {
  static Future<bool> setNewBookReport(
    BuildContext context,
    String bookUuid,
    String report,
  ) async {
    final dio = await authDio(context);
    try {
      final response = await dio.post(
        '/book-report',
        data: {
          'book_uuid': bookUuid,
          'report': report,
        },
      );
      if (response.statusCode == 201) {
        return true;
      } else {
        debugPrint('독후감 생성 실패');
        return false;
      }
    } catch (e) {
      debugPrint('독후감 생성 실패 $e');
      rethrow;
    }
  }

  static Future<List<BookReportInfo>> getBookReportByUserUuid(
    BuildContext context,
  ) async {
    final dio = await authDio(context);
    try {
      final response = await dio.get(
        '/book-report/user',
      );
      if (response.statusCode == 200) {
        final List<dynamic> bookReportList = response.data as List<dynamic>;
        return bookReportList
            .map((bookReport) =>
                BookReportInfo.fromJson(bookReport as Map<String, dynamic>))
            .toList();
      } else {
        debugPrint('독후감 조회 실패');
        return [];
      }
    } catch (e) {
      debugPrint('독후감 조회 실패 $e');
      return [];
    }
  }

  static Future<BookReportInfo> getBookReportByBookReportUuid(
    BuildContext context,
    String bookReportUuid,
  ) async {
    final dio = await authDio(context);
    try {
      final response = await dio.get(
        '/book-report/uuid',
        queryParameters: {
          'book_report_uuid': bookReportUuid,
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> bookReport =
            response.data as Map<String, dynamic>;
        return BookReportInfo.fromJson(bookReport);
      } else {
        debugPrint('독후감 조회 실패');
        return const BookReportInfo(
          bookReportUuid: '',
          bookUuid: '',
          userUuid: '',
          report: '',
          createdAt: '',
        );
      }
    } catch (e) {
      debugPrint('독후감 조회 실패 $e');
      return const BookReportInfo(
        bookReportUuid: '',
        bookUuid: '',
        userUuid: '',
        report: '',
        createdAt: '',
      );
    }
  }

  static Future<BookReportInfo> getBookReportByUserUuidAndBookUuid(
    BuildContext context,
    String bookUuid,
  ) async {
    final dio = await authDio(context);
    try {
      final response = await dio.get(
        '/book-report/user/book',
        queryParameters: {
          'book_uuid': bookUuid,
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> bookReport =
            response.data as Map<String, dynamic>;
        return BookReportInfo.fromJson(bookReport);
      } else {
        debugPrint('독후감 조회 실패');
        return const BookReportInfo(
          bookReportUuid: '',
          bookUuid: '',
          userUuid: '',
          report: '',
          createdAt: '',
        );
      }
    } catch (e) {
      debugPrint('독후감 조회 실패 $e');
      return const BookReportInfo(
        bookReportUuid: '',
        bookUuid: '',
        userUuid: '',
        report: '',
        createdAt: '',
      );
    }
  }

  static Future<bool> updateBookReport(
    BuildContext context,
    String bookReportUuid,
    String report,
  ) async {
    final dio = await authDio(context);
    try {
      final response = await dio.patch(
        '/book-report',
        data: {
          'book_report_uuid': bookReportUuid,
          'report': report,
        },
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        debugPrint('독후감 수정 실패');
        return false;
      }
    } catch (e) {
      debugPrint('독후감 수정 실패 $e');
      rethrow;
    }
  }

  static Future<bool> deleteBookReport(
    BuildContext context,
    String bookReportUuid,
  ) async {
    final dio = await authDio(context);
    try {
      final response = await dio.delete(
        '/book-report',
        queryParameters: {
          'book_report_uuid': bookReportUuid,
        },
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        debugPrint('독후감 삭제 실패');
        return false;
      }
    } catch (e) {
      debugPrint('독후감 삭제 실패 $e');
      rethrow;
    }
  }
}
