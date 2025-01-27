import 'package:flutter/material.dart';
import 'package:sprit/apis/auth_dio.dart';

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
  static Future<List<ArticleInfo>> getArticleList(
    BuildContext context,
    String userUuid,
    int page,
  ) async {
    List<ArticleInfo> articleInfo = [];
    final dio = await authDio(context);
    try {
      final response = await dio.get('/article/list', queryParameters: {
        'user_uuid': userUuid,
        'page': page,
      });
      if (response.statusCode == 200) {
        articleInfo = (response.data as List)
            .map((e) => ArticleInfo.fromJson(e))
            .toList();
      } else {
        debugPrint('게시글 조회 실패');
      }
    } catch (e) {
      debugPrint('게시글 조회 실패 $e');
    }
    return articleInfo;
  }

  static Future<int> getLikeCount(
    BuildContext context,
    String articleUuid,
  ) async {
    int likeCount = 0;
    final dio = await authDio(context);
    try {
      final response = await dio.get('/article/like-count', queryParameters: {
        'article_uuid': articleUuid,
      });
      if (response.statusCode == 200) {
        likeCount = int.parse(response.data);
      } else {
        debugPrint('좋아요 수 조회 실패');
      }
    } catch (e) {
      debugPrint('좋아요 수 조회 실패 $e');
    }
    return likeCount;
  }

  static Future<bool> checkLike(
    BuildContext context,
    String articleUuid,
    String userUuid,
  ) async {
    bool isLike = false;
    final dio = await authDio(context);
    try {
      final response = await dio.get('/article/is-liked', queryParameters: {
        'article_uuid': articleUuid,
        'user_uuid': userUuid,
      });
      if (response.statusCode == 200) {
        isLike = response.data.toString() == 'true';
      } else {
        debugPrint('좋아요 여부 조회 실패');
      }
    } catch (e) {
      debugPrint('좋아요 여부 조회 실패 $e');
    }
    return isLike;
  }

  static Future<void> likeArticle(
    BuildContext context,
    String articleUuid,
    String userUuid,
  ) async {
    final dio = await authDio(context);
    try {
      final response = await dio.post('/article/like', queryParameters: {
        'article_uuid': articleUuid,
        'user_uuid': userUuid,
      });
      if (response.statusCode != 201) {
        debugPrint('게시글 좋아요 실패');
      }
    } catch (e) {
      debugPrint('게시글 좋아요 실패 $e');
    }
  }

  static Future<void> unlikeArticle(
    BuildContext context,
    String articleUuid,
    String userUuid,
  ) async {
    final dio = await authDio(context);
    try {
      final response = await dio.post('/article/unlike', queryParameters: {
        'article_uuid': articleUuid,
        'user_uuid': userUuid,
      });
      if (response.statusCode != 201) {
        debugPrint('게시글 좋아요 취소 실패');
      }
    } catch (e) {
      debugPrint('게시글 좋아요 취소 실패 $e');
    }
  }
}
