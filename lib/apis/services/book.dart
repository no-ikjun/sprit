import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:sprit/core/network/api_client.dart';
import 'package:sprit/core/network/api_exception.dart';
import 'package:sprit/core/util/logger.dart';

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
  final double star;
  final int starCount;

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
    this.star = 0,
    this.starCount = 0,
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
        score = json['score'],
        star = json['star'] == null ? 0.0 : json['star'].toDouble(),
        starCount = json['star_count'] ?? 0;
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
        'star': star,
        'star_count': starCount,
      };
}

class BookInfoService {
  /// ISBN으로 도서 정보 조회
  static Future<BookInfo> getBookInfoByISBN(String isbn) async {
    try {
      final dio = ApiClient.instance.dio;
      final response = await dio.get(
        '/book/find/isbn',
        queryParameters: {
          'isbn': isbn,
        },
      );

      if (response.statusCode == 200) {
        return BookInfo.fromJson(response.data);
      } else {
        throw ServerException.fromResponse(response);
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e, stackTrace) {
      AppLogger.error('도서 정보 조회 실패', e, stackTrace);
      rethrow;
    }
  }

  /// UUID로 도서 정보 조회
  static Future<BookInfo> getBookInfoByUuid(String uuid) async {
    try {
      final dio = ApiClient.instance.dio;
      final response = await dio.get(
        '/book/find/uuid',
        queryParameters: {
          'book_uuid': uuid,
        },
      );

      if (response.statusCode == 200) {
        return BookInfo.fromJson(response.data);
      } else {
        throw ServerException.fromResponse(response);
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e, stackTrace) {
      AppLogger.error('도서 정보 조회 실패', e, stackTrace);
      rethrow;
    }
  }

  /// 도서 등록
  static Future<void> registerBook(String isbn) async {
    try {
      final dio = ApiClient.instance.dio;
      final response = await dio.post(
        '/book/register',
        queryParameters: {
          'isbn': isbn,
        },
      );

      if (response.statusCode != 201) {
        throw ServerException.fromResponse(response);
      }
      AppLogger.info('도서 등록 성공');
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e, stackTrace) {
      AppLogger.error('도서 등록 실패', e, stackTrace);
      rethrow;
    }
  }

  /// 인기 도서 조회
  static Future<Map<String, dynamic>> getPopularBook(int page) async {
    try {
      final dio = ApiClient.instance.dio;
      final response = await dio.get(
        '/book/popular',
        queryParameters: {
          'page': page,
        },
      );

      if (response.statusCode == 200) {
        final result = PopularbookResponse.fromJson(response.data);
        final List<BookInfo> bookInfoList = [];
        for (var book in result.books) {
          bookInfoList.add(BookInfo.fromJson(book));
        }
        return {
          'books': bookInfoList,
          'more_available': result.moreAvailable,
        };
      } else {
        throw ServerException.fromResponse(response);
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e, stackTrace) {
      AppLogger.error('도서 검색 실패', e, stackTrace);
      rethrow;
    }
  }
}
