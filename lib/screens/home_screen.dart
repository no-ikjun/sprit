import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/widgets/book_thumbnail.dart';
import 'package:sprit/widgets/custom_app_bar.dart';

List<String> bookList = [
  "https://search1.kakaocdn.net/thumb/R120x174.q85/?fname=http%3A%2F%2Ft1.daumcdn.net%2Flbook%2Fimage%2F6052975%3Ftimestamp%3D20231124154518",
  "https://search1.kakaocdn.net/thumb/R120x174.q85/?fname=http%3A%2F%2Ft1.daumcdn.net%2Flbook%2Fimage%2F5558360%3Ftimestamp%3D20231114150030",
  "https://search1.kakaocdn.net/thumb/R120x174.q85/?fname=http%3A%2F%2Ft1.daumcdn.net%2Flbook%2Fimage%2F5853564%3Ftimestamp%3D20231025145616",
  "https://search1.kakaocdn.net/thumb/R120x174.q85/?fname=http%3A%2F%2Ft1.daumcdn.net%2Flbook%2Fimage%2F6318015%3Ftimestamp%3D20231124172005",
];

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: ColorSet.background,
        body: SafeArea(
          maintainBottomViewPadding: true,
          child: Column(
            children: [
              const CustomAppBar(
                isHomeScreen: true,
              ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: Scaler.width(0.85, context),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'IkJun님이 읽고있는 책이에요 📚',
                            style: TextStyles.homeNameStyle,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 160,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: bookList.length,
                          itemBuilder: (context, index) {
                            return Row(
                              children: [
                                (index == 0)
                                    ? SizedBox(
                                        width: Scaler.width(0.075, context),
                                      )
                                    : const SizedBox(
                                        width: 0,
                                      ),
                                BookThumbnail(imgUrl: bookList[index]),
                                (index == bookList.length - 1)
                                    ? SizedBox(
                                        width: Scaler.width(0.075, context),
                                      )
                                    : const SizedBox(
                                        width: 10,
                                      ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: Scaler.width(0.85, context),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: Scaler.width(0.41, context),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: List.generate(
                                1,
                                (index) => BoxShadow(
                                  color:
                                      const Color(0x0D000000).withOpacity(0.05),
                                  offset: const Offset(0, 0),
                                  blurRadius: 3,
                                  spreadRadius: 0,
                                ),
                              ),
                            ),
                            child: Stack(
                              children: [
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '책 검색하기',
                                      style: TextStyles.homeButtonTitleStyle,
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                      '읽고있는 책 제목을\n검색해보세요!',
                                      style: TextStyles.homeButtonLabelStyle,
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Image.asset(
                                          'assets/images/3d_magnifier.png',
                                          width: Scaler.width(0.12, context),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: Scaler.width(0.41, context),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: List.generate(
                                1,
                                (index) => BoxShadow(
                                  color:
                                      const Color(0x0D000000).withOpacity(0.05),
                                  offset: const Offset(0, 0),
                                  blurRadius: 3,
                                  spreadRadius: 0,
                                ),
                              ),
                            ),
                            child: Stack(
                              children: [
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '독서 알림설정',
                                      style: TextStyles.homeButtonTitleStyle,
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                      '꾸준한 독서를 위해\n알림을 받으세요!',
                                      style: TextStyles.homeButtonLabelStyle,
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Image.asset(
                                          'assets/images/3d_bell.png',
                                          width: Scaler.width(0.12, context),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextButton(
                      onPressed: () {
                        const storage = FlutterSecureStorage();
                        storage.deleteAll();
                        Navigator.pushNamed(context, '/login');
                      },
                      child: const Text('로그아웃'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
