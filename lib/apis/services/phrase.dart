import 'package:dio/dio.dart';
import 'package:sprit/core/network/api_client.dart';
import 'package:sprit/core/network/api_exception.dart';
import 'package:sprit/core/util/logger.dart';

class PhraseLibraryListCallback {
  final List<PhraseLibraryType> phraseLibraryList;
  final bool moreAvailable;

  PhraseLibraryListCallback({
    required this.phraseLibraryList,
    required this.moreAvailable,
  });
}

class PhraseLibraryListType {
  final List<dynamic> phraseLibraryList;
  final bool moreAvailable;

  PhraseLibraryListType({
    required this.phraseLibraryList,
    required this.moreAvailable,
  });

  PhraseLibraryListType.fromJson(Map<String, dynamic> json)
      : phraseLibraryList = json['library_phrase_list'],
        moreAvailable = json['more_available'];
  Map<String, dynamic> toJson() => {
        'library_phrase_list': phraseLibraryList,
        'more_available': moreAvailable,
      };
}

class PhraseLibraryType {
  final String phraseUuid;
  final String bookTitle;
  final String bookThumbnail;
  final String phrase;
  final int page;
  const PhraseLibraryType({
    required this.phraseUuid,
    required this.bookTitle,
    required this.bookThumbnail,
    required this.phrase,
    required this.page,
  });

  factory PhraseLibraryType.fromJson(Map<String, dynamic> json) {
    return PhraseLibraryType(
      phraseUuid: json['phrase_uuid'] as String,
      bookTitle: json['book_title'] as String,
      bookThumbnail: json['book_thumbnail'] as String,
      phrase: json['phrase'] as String,
      page: json['page'] as int,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'phrase_uuid': phraseUuid,
      'book_title': bookTitle,
      'book_thumbnail': bookThumbnail,
      'phrase': phrase,
      'page': page,
    };
  }
}

class PhraseInfo {
  final String phraseUuid;
  final String bookUuid;
  final String userUuid;
  final String phrase;
  final int page;
  final bool remind;
  final String createdAt;
  const PhraseInfo({
    required this.phraseUuid,
    required this.bookUuid,
    required this.userUuid,
    required this.phrase,
    required this.page,
    required this.remind,
    required this.createdAt,
  });
  factory PhraseInfo.fromJson(Map<String, dynamic> json) {
    return PhraseInfo(
      phraseUuid: json['phrase_uuid'] as String,
      bookUuid: json['book_uuid'] as String,
      userUuid: json['user_uuid'] as String,
      phrase: json['phrase'] as String,
      page: json['page'] as int,
      remind: json['remind'] as bool,
      createdAt: json['created_at'] as String,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'phrase_uuid': phraseUuid,
      'book_uuid': bookUuid,
      'user_uuid': userUuid,
      'phrase': phrase,
      'page': page,
      'remind': remind,
      'created_at': createdAt,
    };
  }
}

class PhraseService {
  /// 새 문구 등록
  static Future<String> setNewPhrase(
    String bookUuid,
    String phrase,
    int page,
    bool remind,
    bool share,
  ) async {
    try {
      final dio = ApiClient.instance.dio;
      final response = await dio.post(
        '/phrase',
        data: {
          'book_uuid': bookUuid,
          'phrase': phrase,
          'page': page,
          'remind': remind,
          'share': share,
        },
      );
      
      if (response.statusCode == 201) {
        return response.data as String;
      } else {
        throw ServerException.fromResponse(response);
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e, stackTrace) {
      AppLogger.error('문구 등록 실패', e, stackTrace);
      rethrow;
    }
  }

  /// 문구만 수정
  static Future<void> updateOnlyPhrase(
    String phraseUuid,
    String phrase,
  ) async {
    try {
      final dio = ApiClient.instance.dio;
      final response = await dio.patch(
        '/phrase',
        queryParameters: {
          'phrase_uuid': phraseUuid,
          'phrase': phrase,
        },
      );
      
      if (response.statusCode != 200) {
        throw ServerException.fromResponse(response);
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e, stackTrace) {
      AppLogger.error('문구 수정 실패', e, stackTrace);
      rethrow;
    }
  }

  /// 모든 문구 조회
  static Future<List<PhraseInfo>> getAllPhrase() async {
    try {
      final dio = ApiClient.instance.dio;
      final response = await dio.get('/phrase/all');
      
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((phrase) => PhraseInfo.fromJson(phrase))
            .toList();
      } else {
        throw ServerException.fromResponse(response);
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e, stackTrace) {
      AppLogger.error('문구 불러오기 실패', e, stackTrace);
      rethrow;
    }
  }

  /// 문구 UUID로 조회
  static Future<PhraseInfo> findOnePhrase(String phraseUuid) async {
    try {
      final dio = ApiClient.instance.dio;
      final response = await dio.get(
        '/phrase/find',
        queryParameters: {
          'phrase_uuid': phraseUuid,
        },
      );
      
      if (response.statusCode == 200) {
        return PhraseInfo.fromJson(response.data);
      } else {
        throw ServerException.fromResponse(response);
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e, stackTrace) {
      AppLogger.error('문구 불러오기 실패', e, stackTrace);
      rethrow;
    }
  }

  /// 문구 리마인드 설정 수정
  static Future<void> updatePhraseRemind(
    String phraseUuid,
    bool remind,
  ) async {
    try {
      final dio = ApiClient.instance.dio;
      final response = await dio.patch(
        '/phrase/remind',
        queryParameters: {
          'phrase_uuid': phraseUuid,
          'remind': remind,
        },
      );
      
      if (response.statusCode != 200) {
        throw ServerException.fromResponse(response);
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e, stackTrace) {
      AppLogger.error('문구 수정 실패', e, stackTrace);
      rethrow;
    }
  }

  /// 문구 삭제
  static Future<void> deletePhrase(String phraseUuid) async {
    try {
      final dio = ApiClient.instance.dio;
      final response = await dio.delete(
        '/phrase',
        queryParameters: {
          'phrase_uuid': phraseUuid,
        },
      );
      
      if (response.statusCode != 200) {
        throw ServerException.fromResponse(response);
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e, stackTrace) {
      AppLogger.error('문구 삭제 실패', e, stackTrace);
      rethrow;
    }
  }

  /// 서재 화면용 문구 목록 조회
  static Future<PhraseLibraryListCallback> getPhraseForLibraryScreen() async {
    try {
      final dio = ApiClient.instance.dio;
      final response = await dio.get('/phrase/library/screen');
      
      if (response.statusCode == 200) {
        final List<PhraseLibraryType> phraseLibraryList = [];
        for (final phraseLibrary in response.data['library_phrase_list']) {
          phraseLibraryList.add(PhraseLibraryType.fromJson(phraseLibrary));
        }
        final moreAvailable = response.data['more_available'] as bool;
        return PhraseLibraryListCallback(
          phraseLibraryList: phraseLibraryList,
          moreAvailable: moreAvailable,
        );
      } else {
        throw ServerException.fromResponse(response);
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e, stackTrace) {
      AppLogger.error('내 서재 문구 불러오기 실패', e, stackTrace);
      rethrow;
    }
  }

  /// 문구 화면용 문구 목록 조회
  static Future<PhraseLibraryListCallback> getPhraseForPhraseScreen(int page) async {
    try {
      final dio = ApiClient.instance.dio;
      final response = await dio.get('/phrase/library/all', queryParameters: {
        'page': page,
      });
      
      if (response.statusCode == 200) {
        final List<PhraseLibraryType> phraseLibraryList = [];
        for (final phraseLibrary in response.data['library_phrase_list']) {
          phraseLibraryList.add(PhraseLibraryType.fromJson(phraseLibrary));
        }
        final moreAvailable = response.data['more_available'] as bool;
        return PhraseLibraryListCallback(
          phraseLibraryList: phraseLibraryList,
          moreAvailable: moreAvailable,
        );
      } else {
        throw ServerException.fromResponse(response);
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e, stackTrace) {
      AppLogger.error('내 서재 문구 불러오기 실패', e, stackTrace);
      rethrow;
    }
  }
}