import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/apis/services/quest.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/screens/quest/widgets/active_quest.dart';
import 'package:sprit/widgets/remove_glow.dart';

Future<List<QuestInfo>> getActiveQuests(BuildContext context) async {
  return await QuestService.getActiveQuests(context);
}

class SocialScreen extends StatefulWidget {
  const SocialScreen({super.key});

  @override
  State<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> {
  final ScrollController _scrollController = ScrollController();

  bool isLoading = false;
  List<QuestInfo> activeQuests = [];

  Future<void> _fetchData() async {
    final results = await Future.wait([
      getActiveQuests(context),
    ]);
    setState(() {
      activeQuests = results[0];
    });
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
    });
    await _fetchData();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    Widget scrollView = CustomScrollView(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: <Widget>[
        CupertinoSliverRefreshControl(
          onRefresh: _loadData,
        ),
        SliverToBoxAdapter(
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                width: Scaler.width(0.85, context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '소셜',
                      style: TextStyles.questScreenTitleStyle,
                    ),
                    InkWell(
                      onTap: () {},
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: SvgPicture.asset(
                        'assets/images/social_bell_icon.svg',
                        width: 22,
                      ),
                    ),
                  ],
                ),
              ),
              isLoading
                  ? Container()
                  : Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: Scaler.width(0.85, context),
                          child: const Row(
                            children: [
                              Text(
                                '퀘스트',
                                style: TextStyles.socialSubTitleStyle,
                              ),
                            ],
                          ),
                        ),
                        ActiveQuestsWidget(
                          activeQuests: activeQuests,
                          isLoading: isLoading,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          width: Scaler.width(0.85, context),
                          child: const Row(
                            children: [
                              Text(
                                '게시물',
                                style: TextStyles.socialSubTitleStyle,
                              ),
                            ],
                          ),
                        ),
                      ],
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
        onRefresh: _loadData,
        color: ColorSet.primary,
        child: scrollView,
      );
    }
    return SafeArea(
      maintainBottomViewPadding: true,
      child: Column(
        children: [
          Expanded(
            child: ScrollConfiguration(
              behavior: RemoveGlow(),
              child: scrollView,
            ),
          )
        ],
      ),
    );
  }
}
