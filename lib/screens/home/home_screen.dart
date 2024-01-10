import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/apis/services/banner.dart';
import 'package:sprit/apis/services/book.dart';
import 'package:sprit/apis/services/user_info.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/providers/user_info.dart';
import 'package:sprit/screens/home/widgets/popular_book.dart';
import 'package:sprit/screens/search/search_screen.dart';
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

Future<Map<String, dynamic>> getPopularBook(
  BuildContext context,
  int page,
) async {
  return await BookInfoService.getPopularBook(context, page);
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int bannerCurrent = 0;
  List<BannerInfo> bannerInfo = [];

  List<BookInfo> popularBookInfo = [];
  bool moreAvailable = false;
  int currentPage = 1;
  bool moreLoading = false;

  final ScrollController _scrollController = ScrollController();

  Future<void> _onRefresh() async {
    updateUserInfo(context);
    final newBannerInfo = await getBannerInfo(context);
    final newPopularBookInfo = await getPopularBook(context, 1);
    setState(() {
      bannerInfo = newBannerInfo;
      popularBookInfo = newPopularBookInfo['books'];
      moreAvailable = newPopularBookInfo['more_available'];
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    updateUserInfo(context);
    getBannerInfo(context).then((value) {
      setState(() {
        bannerInfo = value;
      });
    });
    getPopularBook(context, 1).then((value) {
      setState(() {
        popularBookInfo = value['books'];
        moreAvailable = value['more_available'];
      });
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreData();
    }
  }

  Future<void> _loadMoreData() async {
    if (moreAvailable) {
      setState(() {
        moreLoading = true;
      });
      final newPopularBookInfo = await getPopularBook(context, currentPage + 1);
      setState(() {
        popularBookInfo.addAll(newPopularBookInfo['books']);
        moreAvailable = newPopularBookInfo['more_available'];
        currentPage++;
        moreLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
              controller: _scrollController,
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
                        height: 12,
                      ),
                      SizedBox(
                        width: Scaler.width(0.85, context),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '요즘 인기있는 책이에요 📖',
                              style: TextStyles.homeNameStyle,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      popularBookInfo.isNotEmpty
                          ? Container(
                              width: Scaler.width(0.85, context),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 18,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  ListView.builder(
                                    itemCount: popularBookInfo.length,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) =>
                                        PopularBookWidget(
                                      bookInfo: popularBookInfo[index],
                                      onTap: () {
                                        showBookInfo(
                                          context,
                                          popularBookInfo[index]
                                              .isbn
                                              .trim()
                                              .split(' ')[0],
                                          popularBookInfo[index].isbn,
                                        );
                                      },
                                    ),
                                  ),
                                  moreLoading
                                      ? const SizedBox(
                                          height: 30,
                                          child: Center(
                                            child: CupertinoActivityIndicator(
                                              radius: 10,
                                              animating: true,
                                            ),
                                          ),
                                        )
                                      : Container(),
                                ],
                              ),
                            )
                          : Container(),
                      const SizedBox(
                        height: 25,
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
