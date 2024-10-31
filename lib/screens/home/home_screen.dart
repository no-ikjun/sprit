import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:scaler/scaler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sprit/amplitude_service.dart';
import 'package:sprit/apis/services/banner.dart';
import 'package:sprit/apis/services/book.dart';
import 'package:sprit/apis/services/book_library.dart';
import 'package:sprit/apis/services/notice.dart';
import 'package:sprit/apis/services/user_info.dart';
import 'package:sprit/apis/services/version.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/common/util/functions.dart';
import 'package:sprit/common/value/amplitude_events.dart';
import 'package:sprit/popups/book/home_book_select.dart';
import 'package:sprit/popups/home/version_check.dart';
import 'package:sprit/providers/new_notice.dart';
import 'package:sprit/providers/user_info.dart';
import 'package:sprit/screens/analytics/widgets/grass_widget.dart';
import 'package:sprit/screens/home/widgets/popular_book.dart';
import 'package:sprit/screens/search/search_screen.dart';
import 'package:sprit/widgets/book_thumbnail.dart';
import 'package:sprit/widgets/custom_app_bar.dart';
import 'package:sprit/widgets/loader.dart';
import 'package:sprit/widgets/native_ad.dart';
import 'package:sprit/widgets/scalable_inkwell.dart';
import 'package:url_launcher/url_launcher.dart';

//현재 독서 중인 책 정보 불러오기
Future<List<BookInfo>> getReadingBookInfo(BuildContext context) async {
  return await BookLibraryService.getBookLibrary(context, 'READING');
}

//읽고있는 책 정보 삭제
Future<bool> deleteBook(BuildContext context, String bookUuid) async {
  return await BookLibraryService.deleteBookLibrary(context, bookUuid);
}

//유저 정보 context 업데이트
void updateUserInfo(BuildContext context) async {
  final userInfo = await UserInfoService.getUserInfo(context);
  context.read<UserInfoState>().updateUserInfo(userInfo!);
}

//배너 정보 불러오기
Future<List<BannerInfo>> getBannerInfo(BuildContext context) async {
  return await BannerInfoService.getBannerInfo(context);
}

//요즘 인기있는 책 정보 불러오기
Future<Map<String, dynamic>> getPopularBook(
  BuildContext context,
  int page,
) async {
  return await BookInfoService.getPopularBook(context, page);
}

//가장 최근에 올라온 공지사항 uuid 불러오기
Future<String> getLatestNoticeUuid(BuildContext context) async {
  return await NoticeService.getlatestNoticeUuid(context);
}

//최신 앱 버전 정보 불러오기
Future<void> getLatestVersion(BuildContext context) async {
  final PackageInfo packageInfo = await PackageInfo.fromPlatform();
  final VersionInfo versionInfo =
      await VersionService.getLatestVersion(context);
  if (packageInfo.version == versionInfo.versionNumber &&
      packageInfo.buildNumber.toString() == versionInfo.buildNumber) {
    return;
  } else {
    if (versionInfo.updateRequired) {
      showModal(
        context,
        VersionCheck(
          functions: versionInfo.description.split('&&'),
        ),
        false,
      );
    }
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = false;

  List<BookInfo> bookInfo = [];

  int bannerCurrent = 0;
  List<BannerInfo> bannerInfo = [];

  List<BookInfo> popularBookInfo = [];
  bool moreAvailable = false;
  int currentPage = 1;
  bool moreLoading = false;
  bool isLoadingPopularBook = false;

  final ScrollController _scrollController = ScrollController();

  Future<void> _onRefresh() async {
    final results = await Future.wait([
      getReadingBookInfo(context),
      UserInfoService.getUserInfo(context),
      getBannerInfo(context),
      getPopularBook(context, 1),
      getLatestNoticeUuid(context),
      getLatestVersion(context),
    ]);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      bookInfo = results[0] as List<BookInfo>;
      context.read<UserInfoState>().updateUserInfo(results[1] as UserInfo);
      bannerInfo = results[2] as List<BannerInfo>;
      final popularBooksResult = results[3] as Map<String, dynamic>;
      popularBookInfo = popularBooksResult['books'] as List<BookInfo>;
      moreAvailable = popularBooksResult['more_available'] as bool;
      currentPage = 1;
      if ((prefs.getString('noticeUuid') ?? '') != results[4] as String) {
        context.read<NewNoticeState>().updateNewNotice(true);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _onRefresh();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent) {
      _loadMoreData();
    }
  }

  Future<void> _loadMoreData() async {
    if (moreAvailable && !isLoadingPopularBook) {
      setState(() {
        moreLoading = true;
        isLoadingPopularBook = true;
      });
      await getPopularBook(context, currentPage + 1).then((value) {
        setState(() {
          popularBookInfo.addAll(value['books']);
          moreAvailable = value['more_available'];
          currentPage++;
          moreLoading = false;
          isLoadingPopularBook = false;
        });
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
    Widget scrollView = CustomScrollView(
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
                          Text(
                            bookInfo.isNotEmpty
                                ? '님이 읽고있는 책이에요 📚'
                                : '님, 독서를 시작하세요 📚',
                            style: TextStyles.homeNameStyle,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 160,
                    child: bookInfo.isEmpty
                        ? SizedBox(
                            child: Row(
                              children: [
                                SizedBox(
                                  width: Scaler.width(0.075, context),
                                ),
                                InkWell(
                                  onTap: () {
                                    AmplitudeService().logEvent(
                                      AmplitudeEvent.homeBookAddButton,
                                      context
                                          .read<UserInfoState>()
                                          .userInfo
                                          .userUuid,
                                    );
                                    Navigator.pushNamed(context, '/search');
                                  },
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  child: Container(
                                    width: 90,
                                    height: 130,
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                      color: ColorSet.white,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Image.asset(
                                      'assets/images/home_plus.png',
                                      width: 90,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : SizedBox(
                            width: Scaler.width(1, context),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: bookInfo.length,
                                itemBuilder: (context, index) {
                                  return Row(
                                    children: [
                                      (index == 0)
                                          ? SizedBox(
                                              width:
                                                  Scaler.width(0.075, context),
                                            )
                                          : const SizedBox(
                                              width: 0,
                                            ),
                                      InkWell(
                                        onTap: () {
                                          AmplitudeService().logEvent(
                                              AmplitudeEvent.homeReadingBook,
                                              context
                                                  .read<UserInfoState>()
                                                  .userInfo
                                                  .userUuid,
                                              eventProperties: {
                                                "book_uuid":
                                                    bookInfo[index].bookUuid
                                              });
                                          showModal(
                                            context,
                                            HomeBookSelect(
                                              bookTitle: bookInfo[index].title,
                                              bookUuid:
                                                  bookInfo[index].bookUuid,
                                              onDelete: () async {
                                                await deleteBook(
                                                  context,
                                                  bookInfo[index].bookUuid,
                                                );
                                                _onRefresh();
                                              },
                                            ),
                                            false,
                                          );
                                        },
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        child: BookThumbnail(
                                            imgUrl: bookInfo[index].thumbnail),
                                      ),
                                      (index == bookInfo.length - 1)
                                          ? Row(
                                              children: [
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    AmplitudeService().logEvent(
                                                      AmplitudeEvent
                                                          .homeBookAddButton,
                                                      context
                                                          .read<UserInfoState>()
                                                          .userInfo
                                                          .userUuid,
                                                    );
                                                    Navigator.pushNamed(
                                                        context, '/search');
                                                  },
                                                  splashColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  child: Container(
                                                    width: 90,
                                                    height: 130,
                                                    clipBehavior: Clip.hardEdge,
                                                    decoration: BoxDecoration(
                                                      color: ColorSet.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    child: Image.asset(
                                                      'assets/images/home_plus.png',
                                                      width: 90,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: Scaler.width(
                                                      0.075, context),
                                                ),
                                              ],
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
                  ),
                ],
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
                        AmplitudeService().logEvent(
                          AmplitudeEvent.homeSearchButton,
                          context.read<UserInfoState>().userInfo.userUuid,
                        );
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
                              color: const Color(0x0D000000).withOpacity(0.05),
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
                    ),
                    InkWell(
                      onTap: () {
                        AmplitudeService().logEvent(
                          AmplitudeEvent.homeNotificationButton,
                          context.read<UserInfoState>().userInfo.userUuid,
                        );
                        Navigator.pushNamed(context, '/notification');
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
                              color: const Color(0x0D000000).withOpacity(0.05),
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
                            ScalableInkWell(
                          onTap: () {
                            AmplitudeService().logEvent(
                                AmplitudeEvent.homeBannerClick,
                                context.read<UserInfoState>().userInfo.userUuid,
                                eventProperties: {
                                  "banner_url": bannerInfo[index].clickUrl
                                });
                            Uri url = Uri.parse(bannerInfo[index].clickUrl);
                            launchUrl(url);
                          },
                          child: Container(
                            width: Scaler.width(0.85, context),
                            clipBehavior: Clip.hardEdge,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 0,
                              vertical: 0,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.transparent,
                            ),
                            child: Image.network(
                              bannerInfo[index].bannerUrl,
                              width: Scaler.width(0.85, context),
                            ),
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
                        vertical: 8,
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
              const GrassWidget(),
              const SizedBox(
                height: 15,
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
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF000000).withOpacity(0.05),
                              offset: const Offset(0, 0),
                              blurRadius: 3,
                              spreadRadius: 0,
                            ),
                          ]),
                      child: Column(
                        children: [
                          ListView.builder(
                              itemCount: popularBookInfo.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    index % 9 == 0 && index != 0
                                        ? const Column(
                                            children: [
                                              NativeAdTemplate(),
                                              SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          )
                                        : Container(),
                                    PopularBookWidget(
                                      bookInfo: popularBookInfo[index],
                                      onTap: () async {
                                        setState(() {
                                          AmplitudeService().logEvent(
                                              AmplitudeEvent
                                                  .homePopularBookClick,
                                              context
                                                  .read<UserInfoState>()
                                                  .userInfo
                                                  .userUuid,
                                              eventProperties: {
                                                "book_uuid":
                                                    popularBookInfo[index]
                                                        .bookUuid
                                              });
                                          _isLoading = true;
                                        });
                                        await showBookInfo(
                                          context,
                                          popularBookInfo[index]
                                              .isbn
                                              .trim()
                                              .split(' ')[0],
                                          popularBookInfo[index].isbn,
                                        ).then((value) {
                                          setState(() {
                                            _isLoading = false;
                                          });
                                        });
                                      },
                                    ),
                                  ],
                                );
                              }),
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
    );

    if (Platform.isAndroid) {
      scrollView = RefreshIndicator(
        onRefresh: _onRefresh,
        color: ColorSet.primary,
        child: scrollView,
      );
    }

    return SafeArea(
      maintainBottomViewPadding: true,
      child: Stack(
        children: [
          Column(
            children: [
              CustomAppBar(
                isHomeScreen: true,
                rightIcons: [
                  IconButton(
                    iconSize: 30,
                    splashColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    padding:
                        EdgeInsets.only(right: Scaler.width(0.075, context)),
                    icon: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        context.watch<NewNoticeState>().newNotice
                            ? Container(
                                width: 5,
                                height: 5,
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(2.5)),
                                  color: ColorSet.primary,
                                ),
                              )
                            : const SizedBox(
                                width: 5,
                                height: 5,
                              ),
                        SvgPicture.asset(
                          'assets/images/hamburger_icon.svg',
                          width: 30,
                        ),
                      ],
                    ),
                    onPressed: () {
                      AmplitudeService().logEvent(
                        AmplitudeEvent.homeHamburgerClick,
                        context.read<UserInfoState>().userInfo.userUuid,
                      );
                      Scaffold.of(context).openEndDrawer();
                    },
                  ),
                ],
              ),
              Expanded(
                child: ScrollConfiguration(
                  behavior: const ScrollBehavior(),
                  child: scrollView,
                ),
              ),
            ],
          ),
          _isLoading ? const Loader() : Container(),
        ],
      ),
    );
  }
}
