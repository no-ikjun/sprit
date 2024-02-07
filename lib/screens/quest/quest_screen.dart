import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/apis/services/quest.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/screens/quest/widgets/active_quest.dart';
import 'package:sprit/screens/quest/widgets/ended_quest.dart';
import 'package:sprit/screens/quest/widgets/my_quest.dart';
import 'package:sprit/widgets/custom_app_bar.dart';
import 'package:sprit/widgets/remove_glow.dart';

Future<List<QuestInfo>> getActiveQuests(BuildContext context) async {
  return await QuestService.getActiveQuests(context);
}

Future<List<AppliedQuestResponse>> getMyActiveQuests(
    BuildContext context) async {
  return await QuestService.getMyActiveQuests(context);
}

Future<List<QuestInfo>> getEndedQuest(BuildContext context) async {
  return await QuestService.getEndedQuest(context);
}

class QuestScreen extends StatefulWidget {
  const QuestScreen({super.key});

  @override
  State<QuestScreen> createState() => _QuestScreenState();
}

class _QuestScreenState extends State<QuestScreen> {
  final ScrollController _scrollController = ScrollController();

  bool isLoading = false;
  List<QuestInfo> activeQuests = [];
  List<AppliedQuestResponse> myActiveQuests = [];
  List<QuestInfo> endedQuests = [];

  Future<void> _fetchQuests() async {
    await getActiveQuests(context).then((value) {
      setState(() {
        activeQuests = value;
      });
      getMyActiveQuests(context).then((value) {
        setState(() {
          myActiveQuests = value;
        });
        getEndedQuest(context).then((value) {
          setState(() {
            endedQuests = value;
          });
        });
      });
    });
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
    });
    await _fetchQuests();
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
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
              SizedBox(
                width: Scaler.width(0.85, context),
                child: const Text(
                  '스프릿 퀘스트',
                  style: TextStyles.questScreenTitleStyle,
                ),
              ),
              isLoading
                  ? Container()
                  : Column(
                      children: [
                        ActiveQuestsWidget(
                          activeQuests: activeQuests,
                          isLoading: isLoading,
                        ),
                        MyQuestsWidget(
                          myQuests: myActiveQuests,
                          isLoading: isLoading,
                        ),
                        const SizedBox(
                          height: 11,
                        ),
                        EndedQuestsWidget(
                          endedQuests: endedQuests,
                          isLoading: isLoading,
                        ),
                        const SizedBox(
                          height: 20,
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
        onRefresh: _fetchQuests,
        color: ColorSet.primary,
        child: scrollView,
      );
    }
    return SafeArea(
      maintainBottomViewPadding: true,
      child: Column(
        children: [
          CustomAppBar(
            isHomeScreen: true,
            logoShown: false,
            onlyLabel: false,
            rightIcons: [
              IconButton(
                iconSize: 30,
                splashColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                padding: EdgeInsets.only(right: Scaler.width(0.075, context)),
                icon: SvgPicture.asset(
                  'assets/images/plus_icon.svg',
                  width: 30,
                ),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
              ),
            ],
          ),
          Expanded(
            child: ScrollConfiguration(
              behavior: RemoveGlow(),
              child: scrollView,
            ),
          ),
        ],
      ),
    );
  }
}
