import 'package:flutter/material.dart';
import 'package:sprit/apis/auth_dio.dart';
import 'package:sprit/apis/services/book.dart';

class ReviewInfo {
  final String reviewUuid;
  final int score;
  final String createdAt;
  final String userUuid;
  final BookInfo book;
  final String content;
  const ReviewInfo({
    required this.reviewUuid,
    required this.score,
    required this.createdAt,
    required this.userUuid,
    required this.book,
    required this.content,
  });

  ReviewInfo.fromJson(Map<String, dynamic> json)
      : reviewUuid = json['review_uuid'],
        score = json['score'],
        createdAt = json['created_at'],
        userUuid = json['user_uuid'],
        book = BookInfo.fromJson(json['book']),
        content = json['content'];
  Map<String, dynamic> toJson() => {
        'review_uuid': reviewUuid,
        'score': score,
        'created_at': createdAt,
        'user_uuid': userUuid,
        'book_uuid': book,
        'content': content,
      };
}

class ReviewService {
  static Future<bool> setReview(
    BuildContext context,
    int score,
    String bookUuid,
    String content,
  ) async {
    final dio = await authDio(context);
    try {
      final response = await dio.post(
        '/review',
        data: {
          'score': score,
          'book_uuid': bookUuid,
          'content': content,
        },
      );
      if (response.statusCode == 201) {
        return true;
      } else {
        debugPrint('리뷰 생성 실패');
        return false;
      }
    } catch (e) {
      debugPrint('리뷰 생성 실패 $e');
      return false;
    }
  }

  Future<List<ReviewInfo>> getReviewByBookUuid(
      BuildContext context, String bookUuid) async {
    List<ReviewInfo> reviews = [];
    final dio = await authDio(context);
    try {
      final response = await dio.get(
        '/review',
        queryParameters: {
          'book_uuid': bookUuid,
        },
      );
      if (response.statusCode == 200) {
        reviews =
            (response.data as List).map((e) => ReviewInfo.fromJson(e)).toList();
      } else {
        debugPrint('리뷰 불러오기 실패');
      }
    } catch (e) {
      debugPrint('리뷰 불러오기 실패 $e');
    }
    return reviews;
  }
}
