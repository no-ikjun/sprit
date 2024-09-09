import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sprit/apis/auth_dio.dart';

class ProfileService {
  static Future<void> uploadProfileImage(
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
        debugPrint(response.data.toString());
      } else {
        debugPrint('프로필 이미지 업로드 실패');
      }
    } catch (e) {
      debugPrint('프로필 이미지 업로드 실패 $e');
    }
  }
}
