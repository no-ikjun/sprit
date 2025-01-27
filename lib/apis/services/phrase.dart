import 'package:flutter/material.dart';
import 'package:sprit/apis/auth_dio.dart';

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
  static Future<String> setNewPhrase(
    BuildContext context,
    String bookUuid,
    String phrase,
    int page,
    bool remind,
    bool share,
  ) async {
    final dio = await authDio(context);
    try {
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
        debugPrint('문구 등록 실패');
        return '';
      }
    } catch (e) {
      debugPrint('문구 등록 실패 $e');
      return '';
    }
  }

  static Future<void> updateOnlyPhrase(
    BuildContext context,
    String phraseUuid,
    String phrase,
  ) async {
    final dio = await authDio(context);
    try {
      final response = await dio.patch(
        '/phrase',
        queryParameters: {
          'phrase_uuid': phraseUuid,
          'phrase': phrase,
        },
      );
      if (response.statusCode == 200) {
        return;
      } else {
        debugPrint('문구 수정 실패');
        return;
      }
    } catch (e) {
      debugPrint('문구 수정 실패 $e');
      return;
    }
  }

  static Future<List<PhraseInfo>> getAllPhrase(
    BuildContext context,
  ) async {
    final dio = await authDio(context);
    try {
      final response = await dio.get('/phrase/all');
      if (response.statusCode == 200) {
        final List<PhraseInfo> phraseList = [];
        for (final phrase in response.data) {
          phraseList.add(PhraseInfo.fromJson(phrase));
        }
        return phraseList;
      } else {
        debugPrint('문구 불러오기 실패');
        return [];
      }
    } catch (e) {
      debugPrint('문구 불러오기 실패 $e');
      return [];
    }
  }

  static Future<PhraseInfo> findOnePhrase(
    BuildContext context,
    String phraseUuid,
  ) async {
    final dio = await authDio(context);
    try {
      final response = await dio.get(
        '/phrase/find',
        queryParameters: {
          'phrase_uuid': phraseUuid,
        },
      );
      if (response.statusCode == 200) {
        return PhraseInfo.fromJson(response.data);
      } else {
        debugPrint('문구 불러오기 실패');
        return const PhraseInfo(
          phraseUuid: '',
          bookUuid: '',
          userUuid: '',
          phrase: '',
          page: 0,
          remind: false,
          createdAt: '',
        );
      }
    } catch (e) {
      debugPrint('문구 불러오기 실패 $e');
      return const PhraseInfo(
        phraseUuid: '',
        bookUuid: '',
        userUuid: '',
        phrase: '',
        page: 0,
        remind: false,
        createdAt: '',
      );
    }
  }

  static Future<bool> updatePhraseRemind(
    BuildContext context,
    String phraseUuid,
    bool remind,
  ) async {
    final dio = await authDio(context);
    try {
      final response = await dio.patch(
        '/phrase/remind',
        queryParameters: {
          'phrase_uuid': phraseUuid,
          'remind': remind,
        },
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        debugPrint('문구 수정 실패');
        return false;
      }
    } catch (e) {
      debugPrint('문구 수정 실패 $e');
      return false;
    }
  }

  static Future<bool> deletePhrase(
    BuildContext context,
    String phraseUuid,
  ) async {
    final dio = await authDio(context);
    try {
      final response = await dio.delete(
        '/phrase',
        queryParameters: {
          'phrase_uuid': phraseUuid,
        },
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        debugPrint('문구 삭제 실패');
        return false;
      }
    } catch (e) {
      debugPrint('문구 삭제 실패 $e');
      return false;
    }
  }

  static Future<PhraseLibraryListCallback> getPhraseForLibraryScreen(
    BuildContext context,
  ) async {
    List<PhraseLibraryType> phraseLibraryList = [];
    final dio = await authDio(context);
    bool moreAvailable = false;
    try {
      final response = await dio.get('/phrase/library/screen');
      if (response.statusCode == 200) {
        for (final phraseLibrary in response.data['library_phrase_list']) {
          phraseLibraryList.add(PhraseLibraryType.fromJson(phraseLibrary));
        }
        moreAvailable = response.data['more_available'] as bool;
      } else {
        debugPrint('내 서재 문구 불러오기 실패');
      }
    } catch (e) {
      debugPrint('내 서재 문구 불러오기 실패 $e');
    }
    return PhraseLibraryListCallback(
      phraseLibraryList: phraseLibraryList,
      moreAvailable: moreAvailable,
    );
  }

  static Future<PhraseLibraryListCallback> getPhraseForPhraseScreen(
    BuildContext context,
    int page,
  ) async {
    List<PhraseLibraryType> phraseLibraryList = [];
    final dio = await authDio(context);
    bool moreAvailable = false;
    try {
      final response = await dio.get('/phrase/library/all', queryParameters: {
        'page': page,
      });
      if (response.statusCode == 200) {
        for (final phraseLibrary in response.data['library_phrase_list']) {
          phraseLibraryList.add(PhraseLibraryType.fromJson(phraseLibrary));
        }
        moreAvailable = response.data['more_available'] as bool;
      } else {
        debugPrint('내 서재 문구 불러오기 실패');
      }
    } catch (e) {
      debugPrint('내 서재 문구 불러오기 실패 $e');
    }
    return PhraseLibraryListCallback(
      phraseLibraryList: phraseLibraryList,
      moreAvailable: moreAvailable,
    );
  }
}
