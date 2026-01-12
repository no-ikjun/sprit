import 'package:dio/dio.dart';
import 'package:sprit/core/network/api_client.dart';
import 'package:sprit/core/network/api_exception.dart';
import 'package:sprit/core/util/logger.dart';

class ArticleInfo {
  final String articleUuid;
  final String bookUuid;
  final String userUuid;
  final String type;
  final String data;
  final String createdAt;
  const ArticleInfo({
    required this.articleUuid,
    required this.bookUuid,
    required this.userUuid,
    required this.type,
    required this.data,
    required this.createdAt,
  });
  ArticleInfo.fromJson(Map<String, dynamic> json)
      : articleUuid = json['article_uuid'],
        bookUuid = json['book_uuid'],
        userUuid = json['user_uuid'],
        type = json['type'],
        data = json['data'] ?? '',
        createdAt = json['created_at'];
  Map<String, dynamic> toJson() => {
        'article_uuid': articleUuid,
        'book_uuid': bookUuid,
        'user_uuid': userUuid,
        'type': type,
        'data': data,
        'created_at': createdAt,
      };
}

class ArticleService {
  /// 게시글 목록 조회
  static Future<List<ArticleInfo>> getArticleList(
    String userUuid,
    int page,
  ) async {
    try {
      final dio = ApiClient.instance.dio;
      final response = await dio.get('/article/list', queryParameters: {
        'user_uuid': userUuid,
        'page': page,
      });

      if (response.statusCode == 200) {
        return (response.data as List)
            .map((e) => ArticleInfo.fromJson(e))
            .toList();
      } else {
        throw ServerException.fromResponse(response);
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e, stackTrace) {
      AppLogger.error('게시글 조회 실패', e, stackTrace);
      rethrow;
    }
  }

  /// 사용자 게시글 목록 조회
  static Future<List<ArticleInfo>> getUserArticleList(
    String userUuid,
    int page,
  ) async {
    try {
      final dio = ApiClient.instance.dio;
      final response = await dio.get('/article/user', queryParameters: {
        'user_uuid': userUuid,
        'page': page,
      });

      if (response.statusCode == 200) {
        return (response.data as List)
            .map((e) => ArticleInfo.fromJson(e))
            .toList();
      } else {
        throw ServerException.fromResponse(response);
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e, stackTrace) {
      AppLogger.error('사용자 게시글 조회 실패', e, stackTrace);
      rethrow;
    }
  }

  /// 좋아요 수 조회
  static Future<int> getLikeCount(String articleUuid) async {
    try {
      final dio = ApiClient.instance.dio;
      final response = await dio.get('/article/like-count', queryParameters: {
        'article_uuid': articleUuid,
      });

      if (response.statusCode == 200) {
        return int.parse(response.data.toString());
      } else {
        throw ServerException.fromResponse(response);
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e, stackTrace) {
      AppLogger.error('좋아요 수 조회 실패', e, stackTrace);
      rethrow;
    }
  }

  /// 좋아요 여부 확인
  static Future<bool> checkLike(
    String articleUuid,
    String userUuid,
  ) async {
    try {
      final dio = ApiClient.instance.dio;
      final response = await dio.get('/article/is-liked', queryParameters: {
        'article_uuid': articleUuid,
        'user_uuid': userUuid,
      });

      if (response.statusCode == 200) {
        return response.data.toString() == 'true';
      } else {
        throw ServerException.fromResponse(response);
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e, stackTrace) {
      AppLogger.error('좋아요 여부 조회 실패', e, stackTrace);
      rethrow;
    }
  }

  /// 게시글 좋아요
  static Future<void> likeArticle(
    String articleUuid,
    String userUuid,
  ) async {
    try {
      final dio = ApiClient.instance.dio;
      final response = await dio.post('/article/like', queryParameters: {
        'article_uuid': articleUuid,
        'user_uuid': userUuid,
      });

      if (response.statusCode != 201) {
        throw ServerException.fromResponse(response);
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e, stackTrace) {
      AppLogger.error('게시글 좋아요 실패', e, stackTrace);
      rethrow;
    }
  }

  /// 게시글 좋아요 취소
  static Future<void> unlikeArticle(
    String articleUuid,
    String userUuid,
  ) async {
    try {
      final dio = ApiClient.instance.dio;
      final response = await dio.post('/article/unlike', queryParameters: {
        'article_uuid': articleUuid,
        'user_uuid': userUuid,
      });

      if (response.statusCode != 201) {
        throw ServerException.fromResponse(response);
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e, stackTrace) {
      AppLogger.error('게시글 좋아요 취소 실패', e, stackTrace);
      rethrow;
    }
  }
}
