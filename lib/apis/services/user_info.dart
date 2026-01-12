import 'package:dio/dio.dart';
import 'package:sprit/core/network/api_client.dart';
import 'package:sprit/core/network/api_exception.dart';
import 'package:sprit/core/util/logger.dart';

class UserInfoAll {
  final String userUuid;
  final String userNickame;
  final String userId;
  final String registerType;
  final String registeredAt;
  const UserInfoAll({
    required this.userUuid,
    required this.userNickame,
    required this.userId,
    required this.registerType,
    required this.registeredAt,
  });

  UserInfoAll.fromJson(Map<String, dynamic> json)
      : userUuid = json['user_uuid'],
        userNickame = json['user_nickname'],
        userId = json['user_id'],
        registerType = json['register_type'],
        registeredAt = json['registered_at'];

  Map<String, dynamic> toJson() => {
        'user_uuid': userUuid,
        'user_nickname': userNickame,
        'user_id': userId,
        'register_type': registerType,
        'registered_at': registeredAt,
      };
}

class UserInfo {
  final String userUuid;
  final String userNickname;
  final String registerType;
  const UserInfo({
    required this.userUuid,
    required this.userNickname,
    required this.registerType,
  });

  UserInfo.fromJson(Map<String, dynamic> json)
      : userUuid = json['user_uuid'],
        userNickname = json['user_nickname'],
        registerType = json['register_type'];

  Map<String, dynamic> toJson() => {
        'user_uuid': userUuid,
        'user_nickname': userNickname,
        'register_type': registerType,
      };
}

class UserInfoService {
  /// 유저 정보 조회
  static Future<UserInfo?> getUserInfo() async {
    try {
      final dio = ApiClient.instance.dio;
      final response = await dio.get('/user/info');

      if (response.statusCode == 200) {
        return UserInfo.fromJson(response.data);
      } else {
        throw ServerException.fromResponse(response);
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e, stackTrace) {
      AppLogger.error('유저 정보 조회 실패', e, stackTrace);
      throw UnknownException.fromError(e);
    }
  }

  /// 유저 전체 정보 조회
  static Future<UserInfoAll> getUserInfoAll() async {
    try {
      final dio = ApiClient.instance.dio;
      final response = await dio.get('/user/find');

      if (response.statusCode == 200) {
        return UserInfoAll.fromJson(response.data);
      } else {
        throw ServerException.fromResponse(response);
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e, stackTrace) {
      AppLogger.error('유저 정보 조회 실패', e, stackTrace);
      rethrow;
    }
  }

  /// 닉네임 변경
  static Future<void> changeNickname(String nickname) async {
    try {
      final dio = ApiClient.instance.dio;
      final response = await dio.patch(
        '/user/nickname',
        queryParameters: {
          'nickname': nickname,
        },
      );

      if (response.statusCode != 200) {
        throw ServerException.fromResponse(response);
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e, stackTrace) {
      AppLogger.error('닉네임 변경 실패', e, stackTrace);
      rethrow;
    }
  }

  /// 비밀번호 변경
  static Future<void> changePassword(String password) async {
    try {
      final dio = ApiClient.instance.dio;
      final response = await dio.patch(
        '/user/password',
        queryParameters: {
          'password': password,
        },
      );

      if (response.statusCode != 200) {
        throw ServerException.fromResponse(response);
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e, stackTrace) {
      AppLogger.error('비밀번호 변경 실패', e, stackTrace);
      rethrow;
    }
  }
}
