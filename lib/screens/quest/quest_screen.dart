import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/apis/services/quest.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/screens/quest/widgets/active_quest.dart';
import 'package:sprit/screens/quest/widgets/my_quest.dart';
import 'package:sprit/widgets/custom_app_bar.dart';

Future<List<QuestInfo>> getActiveQuests(BuildContext context) async {
  return await QuestService.getActiveQuests(context);
}

Future<List<AppliedQuestResponse>> getMyActiveQuests(
    BuildContext context) async {
  return await QuestService.getMyActiveQuests(context);
}

class QuestScreen extends StatefulWidget {
  const QuestScreen({Key? key}) : super(key: key);

  @override
  State<QuestScreen> createState() => _QuestScreenState();
}

class _QuestScreenState extends State<QuestScreen> {
  bool isLoading = false;
  List<QuestInfo> activeQuests = [];
  List<AppliedQuestResponse> myActiveQuests = [];

  Future<void> _fetchQuests() async {
    setState(() {
      isLoading = true;
    });
    getActiveQuests(context).then((value) {
      setState(() {
        activeQuests = value;
      });
    });
    getMyActiveQuests(context).then((value) {
      setState(() {
        myActiveQuests = value;
      });
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchQuests();
  }

  @override
  Widget build(BuildContext context) {
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
          SizedBox(
            width: Scaler.width(0.85, context),
            child: const Text(
              '스프릿 퀘스트',
              style: TextStyles.questScreenTitleStyle,
            ),
          ),
          const SizedBox(
            height: 11,
          ),
          ActiveQuestsWidget(
            activeQuests: activeQuests,
            isLoading: isLoading,
          ),
          const SizedBox(
            height: 11,
          ),
          MyQuestsWidget(myQuests: myActiveQuests),
        ],
      ),
    );
  }
}
