import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:scaler/scaler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sprit/amplitude_service.dart';
import 'package:sprit/apis/services/notification.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/common/value/amplitude_events.dart';
import 'package:sprit/providers/fcm_token.dart';
import 'package:sprit/providers/library_section_order.dart';
import 'package:sprit/providers/user_info.dart';
import 'package:sprit/widgets/custom_button.dart';

class DeleteUser extends StatelessWidget {
  const DeleteUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 22,
        ),
        const Text(
          '회원탈퇴',
          style: TextStyles.notificationConfirmModalTitleStyle,
        ),
        const SizedBox(
          height: 14,
        ),
        const Text(
          '정말로 탈퇴하시겠습니까?',
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
                color: ColorSet.red.withOpacity(0.7),
                borderColor: ColorSet.red.withOpacity(0.2),
                onPressed: () async {
                  AmplitudeService().logEvent(
                    AmplitudeEvent.profileDeleteConfirm,
                    properties: {
                      'userUuid':
                          context.read<UserInfoState>().userInfo.userUuid,
                    },
                  );
                  //access token 삭제
                  const storage = FlutterSecureStorage();
                  storage.deleteAll();
                  //provider 초기화
                  context.read<UserInfoState>().removeUserInfo();
                  context.read<LibrarySectionOrderState>().removeSectionOrder();
                  //shared preference 초기화
                  final prefs = await SharedPreferences.getInstance();
                  prefs.clear();
                  //fcm token 삭제
                  await NotificationService.deleteFcmToken(
                    context,
                    context.read<FcmTokenState>().fcmToken,
                  );
                  //로그인 화면으로 이동
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false,
                  );
                },
                child: const Text(
                  '탈퇴',
                  style: TextStyles.buttonLabelStyle,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
