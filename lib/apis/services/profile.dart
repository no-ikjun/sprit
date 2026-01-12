import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sprit/core/network/api_client.dart';
import 'package:sprit/core/network/api_exception.dart';
import 'package:sprit/core/util/logger.dart';

class ProfileInfo {
  final String userUuid;
  final String nickname;
  final String image;
  final String description;
  final List<String> recommendList;
  const ProfileInfo({
    required this.userUuid,
    required this.nickname,
    required this.image,
    required this.description,
    required this.recommendList,
  });

  factory ProfileInfo.fromJson(Map<String, dynamic> json) {
    return ProfileInfo(
      userUuid: json['user_uuid'],
      nickname: json['nickname'],
      image: json['image'],
      description: json['description'],
      recommendList: List<String>.from(json['recommend_list']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_uuid': userUuid,
      'nickname': nickname,
      'image': image,
      'description': description,
      'recommend_list': recommendList,
    };
  }
}

class ProfileService {
  /// 프로필 이미지 업로드
  static Future<bool> uploadProfileImage(XFile image) async {
    try {
      final dio = ApiClient.instance.getMultipartDio();
      final formData = FormData.fromMap(
        {'upload': await MultipartFile.fromFile(image.path)},
      );
      final response = await dio.post(
        '/profile',
        data: formData,
      );
      
      if (response.statusCode == 201) {
        AppLogger.info('프로필 이미지 업로드 성공');
        return true;
      } else {
        throw ServerException.fromResponse(response);
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e, stackTrace) {
      AppLogger.error('프로필 이미지 업로드 실패', e, stackTrace);
      rethrow;
    }
  }

  /// 프로필 정보 조회
  static Future<ProfileInfo> getProfileInfo(String userUuid) async {
    try {
      final dio = ApiClient.instance.dio;
      final response = await dio.get('/profile', queryParameters: {
        'user_uuid': userUuid,
      });
      
      if (response.statusCode == 200) {
        AppLogger.info('프로필 정보 조회 성공');
        return ProfileInfo.fromJson(response.data);
      } else {
        throw ServerException.fromResponse(response);
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e, stackTrace) {
      AppLogger.error('프로필 정보 조회 실패', e, stackTrace);
      rethrow;
    }
  }

  /// 프로필 소개 수정
  static Future<void> updateProfileDesc(
    String userUuid,
    String desc,
  ) async {
    try {
      final dio = ApiClient.instance.dio;
      final response = await dio.patch(
        '/profile/desc',
        data: {
          'user_uuid': userUuid,
          'desc': desc,
        },
      );
      
      if (response.statusCode != 200) {
        throw ServerException.fromResponse(response);
      }
      AppLogger.info('프로필 소개 수정 성공');
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e, stackTrace) {
      AppLogger.error('프로필 소개 수정 실패', e, stackTrace);
      rethrow;
    }
  }

  /// 추천 프로필 조회
  static Future<List<ProfileInfo>> getRecommendProfile(String userUuid) async {
    try {
      final dio = ApiClient.instance.dio;
      final response = await dio.get('/profile/recommend', queryParameters: {
        'user_uuid': userUuid,
      });
      
      if (response.statusCode == 200) {
        AppLogger.info('추천 프로필 조회 성공');
        return List<ProfileInfo>.from(
          response.data.map((x) => ProfileInfo.fromJson(x)),
        );
      } else {
        throw ServerException.fromResponse(response);
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e, stackTrace) {
      AppLogger.error('추천 프로필 조회 실패', e, stackTrace);
      rethrow;
    }
  }

  /// 프로필 검색
  static Future<List<ProfileInfo>> searchProfile(
    String searchValue,
    String userUuid,
  ) async {
    try {
      final dio = ApiClient.instance.dio;
      final response = await dio.get('/profile/search', queryParameters: {
        'keyword': searchValue,
        'user_uuid': userUuid,
      });
      
      if (response.statusCode == 200) {
        AppLogger.info('프로필 검색 성공');
        return List<ProfileInfo>.from(
          response.data.map((x) => ProfileInfo.fromJson(x)),
        );
      } else {
        throw ServerException.fromResponse(response);
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e, stackTrace) {
      AppLogger.error('프로필 검색 실패', e, stackTrace);
      rethrow;
    }
  }
}