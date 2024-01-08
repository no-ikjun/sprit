import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/apis/services/banner.dart';
import 'package:sprit/apis/services/user_info.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/providers/user_info.dart';
import 'package:sprit/widgets/book_thumbnail.dart';
import 'package:sprit/widgets/custom_app_bar.dart';

List<String> bookList = [
  "https://search1.kakaocdn.net/thumb/R120x174.q85/?fname=http%3A%2F%2Ft1.daumcdn.net%2Flbook%2Fimage%2F6052975%3Ftimestamp%3D20231124154518",
  "https://search1.kakaocdn.net/thumb/R120x174.q85/?fname=http%3A%2F%2Ft1.daumcdn.net%2Flbook%2Fimage%2F5558360%3Ftimestamp%3D20231114150030",
  "https://search1.kakaocdn.net/thumb/R120x174.q85/?fname=http%3A%2F%2Ft1.daumcdn.net%2Flbook%2Fimage%2F5853564%3Ftimestamp%3D20231025145616",
  "https://search1.kakaocdn.net/thumb/R120x174.q85/?fname=http%3A%2F%2Ft1.daumcdn.net%2Flbook%2Fimage%2F6318015%3Ftimestamp%3D20231124172005",
];

void updateUserInfo(BuildContext context) async {
  final userInfo = await UserInfoService.getUserInfo(context);
  context.read<UserInfoState>().updateUserInfo(userInfo!);
}

Future<List<BannerInfo>> getBannerInfo(BuildContext context) async {
  return await BannerInfoService.getBannerInfo(context);
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int bannerCurrent = 0;
  List<BannerInfo> bannerInfo = [];

  Future<void> _onRefresh() async {
    updateUserInfo(context);
    final newBannerInfo = await getBannerInfo(context);
    setState(() {
      bannerInfo = newBannerInfo;
    });
  }

  @override
  void initState() {
    super.initState();
    updateUserInfo(context);
    getBannerInfo(context).then((value) {
      setState(() {
        bannerInfo = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      maintainBottomViewPadding: true,
      child: Column(
        children: [
          const CustomAppBar(
            isHomeScreen: true,
          ),
          Expanded(
            child: CustomScrollView(
              controller: ScrollController(),
              slivers: <Widget>[
                CupertinoSliverRefreshControl(
                  onRefresh: _onRefresh,
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: Scaler.width(0.85, context),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Row(
                                children: [
                                  Container(
                                    constraints: BoxConstraints(
                                        maxWidth: Scaler.width(0.3, context)),
                                    child: Text(
                                      context
                                          .watch<UserInfoState>()
                                          .userInfo
                                          .userNickname,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyles.homeNameStyle,
                                    ),
                                  ),
                                  const Text(
                                    '님이 읽고있는 책이에요 📚',
                                    style: TextStyles.homeNameStyle,
                                  ),
                                ],
                              ),
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
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, '/search');
                              },
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              child: Container(
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
                                      color: const Color(0x0D000000)
                                          .withOpacity(0.05),
                                      offset: const Offset(0, 0),
                                      blurRadius: 3,
                                      spreadRadius: 0,
                                    ),
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    const Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '책 검색하기',
                                          style:
                                              TextStyles.homeButtonTitleStyle,
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Text(
                                          '읽고있는 책 제목을\n검색해보세요!',
                                          style:
                                              TextStyles.homeButtonLabelStyle,
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Image.asset(
                                              'assets/images/3d_magnifier.png',
                                              width:
                                                  Scaler.width(0.12, context),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
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
                                    color: const Color(0x0D000000)
                                        .withOpacity(0.05),
                                    offset: const Offset(0, 0),
                                    blurRadius: 3,
                                    spreadRadius: 0,
                                  ),
                                ),
                              ),
                              child: Stack(
                                children: [
                                  const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
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
                        height: 12,
                      ),
                      SizedBox(
                        width: Scaler.width(1, context),
                        child: bannerInfo.isNotEmpty
                            ? CarouselSlider.builder(
                                itemCount: bannerInfo.length,
                                options: CarouselOptions(
                                  viewportFraction: 0.87,
                                  aspectRatio: Scaler.width(0.85, context) / 55,
                                  autoPlay: true,
                                  autoPlayInterval: const Duration(seconds: 10),
                                  enlargeCenterPage: false,
                                  enableInfiniteScroll: false,
                                  onPageChanged: (index, reason) => {
                                    setState(() {
                                      bannerCurrent = index;
                                    })
                                  },
                                ),
                                itemBuilder: (context, index, realIndex) =>
                                    Container(
                                  width: Scaler.width(0.85, context),
                                  clipBehavior: Clip.hardEdge,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 0,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Color(int.parse(
                                        bannerInfo[index]
                                            .backgroundColor
                                            .toString(),
                                        radix: 16)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            bannerInfo[index].title,
                                            style: TextStyles.bannerTitleStyle,
                                          ),
                                          const SizedBox(
                                            height: 2,
                                          ),
                                          Text(
                                            bannerInfo[index].content,
                                            style:
                                                TextStyles.bannerContentStyle,
                                          ),
                                          const SizedBox(
                                            height: 3,
                                          ),
                                        ],
                                      ),
                                      (bannerInfo[index].iconUrl != '')
                                          ? Image.network(
                                              bannerInfo[index].iconUrl,
                                              width: 55,
                                              height: 55,
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ),
                              )
                            : Container(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          bannerInfo.length,
                          (index) => GestureDetector(
                            onTap: () {},
                            child: Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 3,
                              ),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: bannerCurrent == index
                                    ? ColorSet.grey
                                    : ColorSet.lightGrey,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 1000,
                      ),
                      TextButton(
                        onPressed: () {
                          const storage = FlutterSecureStorage();
                          storage.deleteAll();
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/login',
                            (route) => false,
                          );
                        },
                        child: const Text('로그아웃'),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}