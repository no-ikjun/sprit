import 'package:dio/dio.dart';
import 'package:sprit/core/network/api_client.dart';
import 'package:sprit/core/network/api_exception.dart';
import 'package:sprit/core/util/logger.dart';

class BookSearchResponse {
  final List<dynamic> books;
  final bool isEnd;

  const BookSearchResponse({
    required this.books,
    required this.isEnd,
  });

  BookSearchResponse.fromJson(Map<String, dynamic> json)
      : books = json['books'],
        isEnd = json['is_end'];
  Map<String, dynamic> toJson() => {
        'books': books,
        'isEnd': isEnd,
      };
}

class BookSearchInfo {
  final List<String> authors;
  final String contents;
  final String datetime;
  final String isbn;
  final String price;
  final String publisher;
  final String salePrice;
  final String status;
  final String thumbnail;
  final String title;
  final List<String> translators;
  final String url;

  const BookSearchInfo({
    required this.authors,
    required this.contents,
    required this.datetime,
    required this.isbn,
    required this.price,
    required this.publisher,
    required this.salePrice,
    required this.status,
    required this.thumbnail,
    required this.title,
    required this.translators,
    required this.url,
  });

  BookSearchInfo.fromJson(Map<String, dynamic> json)
      : authors = List<String>.from(json['authors']),
        contents = json['contents'],
        datetime = json['datetime'],
        isbn = json['isbn'],
        price = json['price'].toString(),
        publisher = json['publisher'],
        salePrice = json['sale_price'].toString(),
        status = json['status'],
        thumbnail = json['thumbnail'],
        title = json['title'],
        translators = List<String>.from(json['translators']),
        url = json['url'];
  Map<String, dynamic> toJson() => {
        'authors': authors,
        'contents': contents,
        'datetime': datetime.toString(),
        'isbn': isbn.toString(),
        'price': price.toString(),
        'publisher': publisher,
        'sale_price': salePrice.toString(),
        'status': status.toString(),
        'thumbnail': thumbnail,
        'title': title,
        'translators': translators,
        'url': url,
      };
}

class BookSearchService {
  /// 도서 검색
  static Future<Map<String, dynamic>> searchBook(
    String query,
    int page,
  ) async {
    try {
      final dio = ApiClient.instance.dio;
      final response = await dio.get(
        '/book/search',
        queryParameters: {
          'query': query,
          'page': page.toString(),
        },
      );

      if (response.statusCode == 200) {
        final result = BookSearchResponse.fromJson(response.data);
        final List<BookSearchInfo> bookSearchInfoList = [];
        for (var book in result.books) {
          bookSearchInfoList.add(BookSearchInfo.fromJson(book));
        }
        return {
          'search_list': bookSearchInfoList,
          'is_end': result.isEnd,
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
