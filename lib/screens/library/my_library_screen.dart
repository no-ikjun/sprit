import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/apis/services/follow.dart';
import 'package:sprit/apis/services/profile.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/common/util/functions.dart';
import 'package:sprit/common/value/router.dart';
import 'package:sprit/popups/library/edit_desc.dart';
import 'package:sprit/popups/library/section_order.dart';
import 'package:sprit/providers/library_section_order.dart';
import 'package:sprit/providers/user_info.dart';
import 'package:sprit/screens/library/ordered_component/book_mark.dart';
import 'package:sprit/screens/library/ordered_component/book_report.dart';
import 'package:sprit/screens/library/ordered_component/my_book_info.dart';
import 'package:sprit/screens/library/ordered_component/phrase_info.dart';
import 'package:sprit/widgets/remove_glow.dart';

class MyLibraryScreen extends StatefulWidget {
  const MyLibraryScreen({super.key});

  @override
  State<MyLibraryScreen> createState() => _MyLibraryScreenState();
}

class _MyLibraryScreenState extends State<MyLibraryScreen> {
  final ImagePicker picker = ImagePicker();
  XFile? image0;

  Future<void> getImage() async {
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 30,
    );
    if (image != null) {
      setState(() {
        image0 = image;
      });
      await ProfileService.uploadProfileImage(context, image);
    } else {
      debugPrint('이미지 선택 취소');
    }
  }

  bool isLoading = false;

  ProfileInfo? profileInfo;
  int? followerCount;
  int? followingCount;

  Future<void> _loadData(bool isFirst) async {
    if (isFirst) {
      setState(() {
        isLoading = true;
      });
    }
    String userUuid = context.read<UserInfoState>().userInfo.userUuid;

    final profile = await ProfileService.getProfileInfo(context, userUuid);
    final followers = await FollowService.getFollowerList(context, userUuid);
    final following = await FollowService.getFollowingList(context, userUuid);

    setState(() {
      profileInfo = profile;
      followerCount = followers.length;
      followingCount = following.length;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadData(true);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CupertinoActivityIndicator(
          radius: 18,
          animating: true,
        ),
      );
    }
    Widget scrollView = CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: <Widget>[
        CupertinoSliverRefreshControl(
          onRefresh: () => _loadData(false),
        ),
        SliverToBoxAdapter(
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: Scaler.width(0.85, context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '내 서재',
                          style: TextStyles.myLibraryTitleStyle,
                        ),
                        InkWell(
                          onTap: () {
                            showModal(
                                context, const LibrarySectionOrder(), false);
                          },
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          child: SvgPicture.asset(
                            'assets/images/setting_gear.svg',
                            width: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: Scaler.width(0.85, context),
                child: Row(
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: image0 != null
                              ? Image.file(
                                  File(image0!.path),
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  "https://d3ob3cint7tr3s.cloudfront.net/${profileInfo?.image}",
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      SvgPicture.asset(
                                    'assets/images/default_profile.svg',
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        InkWell(
                          onTap: () {
                            getImage();
                          },
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/images/camera_icon.svg',
                              width: 28,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    SizedBox(
                      width: Scaler.width(0.85, context) - 120,
                      height: 95,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                RouteName.profile,
                              );
                            },
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: Text(
                              '${profileInfo?.nickname}',
                              style: TextStyles.myLibraryNicknameStyle,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              showModal(
                                context,
                                EditDesc(
                                  desc: profileInfo?.description ?? '',
                                  callback: () async {
                                    await _loadData(false);
                                  },
                                ),
                                false,
                              );
                            },
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: Text(
                              '${profileInfo?.description}',
                              style: TextStyles.myLibraryDescriptionStyle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    RouteName.followScreen,
                                    arguments: 'follower',
                                  );
                                },
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                child: Row(
                                  children: [
                                    const Text(
                                      "팔로워 ",
                                      style: TextStyles.myLibraryFollowerStyle,
                                    ),
                                    Text(
                                      "$followerCount명",
                                      style: TextStyles.myLibraryFollowerStyle
                                          .copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Text(
                                " · ",
                                style: TextStyles.myLibraryFollowerStyle,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    RouteName.followScreen,
                                    arguments: 'following',
                                  );
                                },
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                child: Row(
                                  children: [
                                    const Text(
                                      "팔로잉 ",
                                      style: TextStyles.myLibraryFollowerStyle,
                                    ),
                                    Text(
                                      "$followingCount명",
                                      style: TextStyles.myLibraryFollowerStyle
                                          .copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
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
                height: 20,
              ),
              Column(
                children: context
                    .watch<LibrarySectionOrderState>()
                    .getSectionOrder
                    .map((section) {
                      switch (section) {
                        case LibrarySection.bookMark:
                          return const BookMarkComponent();
                        case LibrarySection.bookInfo:
                          return const MyBookInfoComponent();
                        case LibrarySection.phrase:
                          return const MyPhraseComponent();
                        case LibrarySection.report:
                          return const MyBookReportComponent();
                        default:
                          return Container();
                      }
                    })
                    .expand((widget) => [widget, const SizedBox(height: 35)])
                    .toList(),
              ),
            ],
          ),
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Container(),
        ),
      ],
    );

    if (Platform.isAndroid) {
      scrollView = RefreshIndicator(
        onRefresh: () => _loadData(false),
        child: scrollView,
      );
    }

    return SafeArea(
      maintainBottomViewPadding: true,
      child: ScrollConfiguration(
        behavior: RemoveGlow(),
        child: scrollView,
      ),
    );
  }
}
