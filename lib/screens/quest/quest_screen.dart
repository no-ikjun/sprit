import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/apis/services/quest.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/common/util/functions.dart';
import 'package:sprit/popups/quest/new_quest.dart';
import 'package:sprit/screens/quest/widgets/active_quest.dart';
import 'package:sprit/screens/quest/widgets/ended_quest.dart';
import 'package:sprit/screens/quest/widgets/my_quest.dart';
import 'package:sprit/widgets/remove_glow.dart';

Future<List<QuestInfo>> getActiveQuests() async {
  return await QuestService.getActiveQuests();
}

Future<List<AppliedQuestResponse>> getMyActiveQuests() async {
  return await QuestService.getMyActiveQuests();
}

Future<List<QuestInfo>> getEndedQuest() async {
  return await QuestService.getEndedQuest();
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
    final results = await Future.wait([
      getActiveQuests(),
      getMyActiveQuests(),
      getEndedQuest(),
    ]);
    setState(() {
      activeQuests = results[0] as List<QuestInfo>;
      myActiveQuests = results[1] as List<AppliedQuestResponse>;
      endedQuests = results[2] as List<QuestInfo>;
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
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                width: Scaler.width(0.85, context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '스프릿 퀘스트',
                      style: TextStyles.questScreenTitleStyle,
                    ),
                    InkWell(
                      onTap: () {
                        showModal(context, const NewQuestModal(), false);
                      },
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: SvgPicture.asset(
                        'assets/images/plus_icon.svg',
                        width: 30,
                      ),
                    ),
                  ],
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
