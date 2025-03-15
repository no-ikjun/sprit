import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sprit/apis/auth_dio.dart';

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
  static Future<bool> uploadProfileImage(
    BuildContext context,
    XFile image,
  ) async {
    final dio = await authDio(context, contentType: 'multipart/form-data');
    try {
      final formData = FormData.fromMap(
        {'upload': await MultipartFile.fromFile(image.path)},
      );
      final response = await dio.post(
        '/profile',
        data: formData,
      );
      if (response.statusCode == 201) {
        debugPrint('프로필 이미지 업로드 성공');
        return true;
      } else {
        debugPrint('프로필 이미지 업로드 실패');
        return false;
      }
    } catch (e) {
      debugPrint('프로필 이미지 업로드 실패 $e');
      return false;
    }
  }

  static Future<ProfileInfo> getProfileInfo(
    BuildContext context,
    String userUuid,
  ) async {
    final dio = await authDio(context);
    try {
      final response = await dio.get('/profile', queryParameters: {
        'user_uuid': userUuid,
      });
      if (response.statusCode == 200) {
        debugPrint('프로필 정보 조회 성공');
        debugPrint(response.data.toString());
        return ProfileInfo.fromJson(response.data);
      } else {
        debugPrint('프로필 정보 조회 실패');
        return const ProfileInfo(
          userUuid: '',
          nickname: '',
          image: '',
          description: '',
          recommendList: [],
        );
      }
    } catch (e) {
      debugPrint('프로필 정보 조회 실패 $e');
      return const ProfileInfo(
        userUuid: '',
        nickname: '',
        image: '',
        description: '',
        recommendList: [],
      );
    }
  }

  static Future<void> updateProfileDesc(
    BuildContext context,
    String userUuid,
    String desc,
  ) async {
    final dio = await authDio(context);
    try {
      final response = await dio.patch(
        '/profile/desc',
        data: {
          'user_uuid': userUuid,
          'desc': desc,
        },
      );
      if (response.statusCode == 200) {
        debugPrint('프로필 소개 수정 성공');
      } else {
        debugPrint('프로필 소개 수정 실패');
      }
    } catch (e) {
      debugPrint('프로필 소개 수정 실패 $e');
    }
  }

  static Future<List<ProfileInfo>> getRecommendProfile(
    BuildContext context,
    String userUuid,
  ) async {
    final dio = await authDio(context);
    try {
      final response = await dio.get('/profile/recommend', queryParameters: {
        'user_uuid': userUuid,
      });
      if (response.statusCode == 200) {
        debugPrint('추천 프로필 조회 성공');
        return List<ProfileInfo>.from(
          response.data.map((x) => ProfileInfo.fromJson(x)),
        );
      } else {
        debugPrint('추천 프로필 조회 실패');
        return [];
      }
    } catch (e) {
      debugPrint('추천 프로필 조회 실패 $e');
      return [];
    }
  }

  static Future<List<ProfileInfo>> searchProfile(
    BuildContext context,
    String searchValue,
    String userUuid,
  ) async {
    final dio = await authDio(context);
    try {
      final response = await dio.get('/profile/search', queryParameters: {
        'keyword': searchValue,
        'user_uuid': userUuid,
      });
      if (response.statusCode == 200) {
        debugPrint('프로필 검색 성공');
        return List<ProfileInfo>.from(
          response.data.map((x) => ProfileInfo.fromJson(x)),
        );
      } else {
        debugPrint('프로필 검색 실패');
        return [];
      }
    } catch (e) {
      debugPrint('프로필 검색 실패 $e');
      return [];
    }
  }
}
