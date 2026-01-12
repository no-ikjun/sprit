import 'package:dio/dio.dart';
import 'package:sprit/apis/services/book.dart';
import 'package:sprit/core/network/api_client.dart';
import 'package:sprit/core/network/api_exception.dart';
import 'package:sprit/core/util/logger.dart';

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
  /// 리뷰 생성
  static Future<bool> setReview(
    int score,
    String bookUuid,
    String content,
  ) async {
    try {
      final dio = ApiClient.instance.dio;
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
        throw ServerException.fromResponse(response);
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e, stackTrace) {
      AppLogger.error('리뷰 생성 실패', e, stackTrace);
      rethrow;
    }
  }

  /// 도서 UUID로 리뷰 목록 조회
  static Future<List<ReviewInfo>> getReviewByBookUuid(String bookUuid) async {
    try {
      final dio = ApiClient.instance.dio;
      final response = await dio.get(
        '/review',
        queryParameters: {
          'book_uuid': bookUuid,
        },
      );
      
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((e) => ReviewInfo.fromJson(e))
            .toList();
      } else {
        throw ServerException.fromResponse(response);
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e, stackTrace) {
      AppLogger.error('리뷰 불러오기 실패', e, stackTrace);
      rethrow;
    }
  }
}