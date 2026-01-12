import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:scaler/scaler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sprit/apis/services/notification.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/core/util/logger.dart';
import 'package:sprit/providers/fcm_token.dart';
import 'package:sprit/providers/library_section_order.dart';
import 'package:sprit/providers/user_info.dart';
import 'package:sprit/widgets/custom_button.dart';

class LogoutConfirm extends StatelessWidget {
  const LogoutConfirm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 22,
        ),
        const Text(
          '로그아웃',
          style: TextStyles.notificationConfirmModalTitleStyle,
        ),
        const SizedBox(
          height: 14,
        ),
        const Text(
          '정말로 로그아웃 하시겠습니까?',
          style: TextStyles.notificationConfirmModalDescriptionStyle,
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: Scaler.width(0.85, context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomButton(
                width: Scaler.width(0.8, context) * 0.5 - 5,
                height: 50,
                color: ColorSet.lightGrey,
                borderColor: ColorSet.lightGrey,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  '취소',
                  style: TextStyles.buttonLabelStyle,
                ),
              ),
              CustomButton(
                width: Scaler.width(0.8, context) * 0.5 - 5,
                height: 50,
                onPressed: () async {
                  try {
                    AppLogger.info('logout');
                    // FCM 토큰 삭제 (토큰 삭제 전에 먼저 수행)
                    try {
                      await NotificationService.deleteFcmToken(
                        context.read<FcmTokenState>().fcmToken,
                      );
                    } catch (e) {
                      // FCM 토큰 삭제 실패해도 무시하고 진행
                      AppLogger.warning('FCM 토큰 삭제 실패 (무시): $e');
                    }
                    //access token 삭제
                    const storage = FlutterSecureStorage();
                    await storage.deleteAll();
                    //provider 초기화
                    context.read<UserInfoState>().removeUserInfo();
                    context
                        .read<LibrarySectionOrderState>()
                        .removeSectionOrder();
                    //shared preference 초기화
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.clear();
                    //로그인 화면으로 이동
                    if (context.mounted) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/login',
                        (route) => false,
                      );
                    }
                  } catch (e) {
                    AppLogger.error('로그아웃 실패', e, StackTrace.current);
                    // 에러가 발생해도 로그인 화면으로 이동
                    if (context.mounted) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/login',
                        (route) => false,
                      );
                    }
                  }
                },
                child: const Text('로그아웃', style: TextStyles.buttonLabelStyle),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
