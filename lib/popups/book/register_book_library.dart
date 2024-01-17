import 'package:flutter/cupertino.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/widgets/custom_button.dart';

class RegisterBookLibraryConfirm extends StatelessWidget {
  final bool result;
  final String state;
  const RegisterBookLibraryConfirm({
    super.key,
    required this.result,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 22,
        ),
        Text(
          result ? '목록에 추가됨' : '목록에 추가할 수 없음',
          style: TextStyles.notificationConfirmModalTitleStyle,
        ),
        const SizedBox(
          height: 14,
        ),
        Text(
          result
              ? (state == 'AFTER')
                  ? '읽었던 도서 목록에 추가되었어요'
                  : '나중에 읽을 목록에 추가되었어요'
              : "이미 목록에 저장되어있는 도서에요\n상태 변경은 '내 서재' 탭에서 할 수 있어요",
          style: TextStyles.notificationConfirmModalDescriptionStyle,
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 22,
        ),
        CustomButton(
          onPressed: () {
            Navigator.pop(context);
          },
          width: Scaler.width(0.85, context),
          height: 45,
          child: const Text(
            '확인',
            style: TextStyles.loginButtonStyle,
          ),
        )
      ],
    );
  }
}
