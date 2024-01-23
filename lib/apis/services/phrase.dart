import 'package:flutter/material.dart';
import 'package:sprit/apis/auth_dio.dart';

class PhraseInfo {
  final String phraseUuid;
  final String bookUuid;
  final String userUuid;
  final String phrase;
  final bool remind;
  final String createdAt;
  const PhraseInfo({
    required this.phraseUuid,
    required this.bookUuid,
    required this.userUuid,
    required this.phrase,
    required this.remind,
    required this.createdAt,
  });
  factory PhraseInfo.fromJson(Map<String, dynamic> json) {
    return PhraseInfo(
      phraseUuid: json['phrase_uuid'] as String,
      bookUuid: json['book_uuid'] as String,
      userUuid: json['user_uuid'] as String,
      phrase: json['phrase'] as String,
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
    bool remind,
  ) async {
    final dio = await authDio(context);
    try {
      final response = await dio.post(
        '/phrase',
        data: {
          'book_uuid': bookUuid,
          'phrase': phrase,
          'remind': remind,
        },
      );
      if (response.statusCode == 201) {
        return response.data['phrase_uuid'] as String;
      } else {
        debugPrint('문구 등록 실패');
        return '';
      }
    } catch (e) {
      debugPrint('문구 등록 실패 $e');
      return '';
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
        remind: false,
        createdAt: '',
      );
    }
  }

  static Future<bool> updatePhrase(
    BuildContext context,
    String phraseUuid,
    bool remind,
  ) async {
    final dio = await authDio(context);
    try {
      final response = await dio.put(
        '/phrase/remind',
        data: {
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
}
