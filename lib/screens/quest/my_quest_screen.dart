import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/apis/services/quest.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/screens/quest/widgets/small_quest_widget.dart';
import 'package:sprit/widgets/custom_app_bar.dart';
import 'package:sprit/widgets/remove_glow.dart';

class MyQuestScreen extends StatefulWidget {
  const MyQuestScreen({super.key});

  @override
  State<MyQuestScreen> createState() => _MyQuestScreenState();
}

class _MyQuestScreenState extends State<MyQuestScreen> {
  List<AppliedQuestResponse> myQuests = [];
  bool isLoading = false;

  Future<void> _fetchMyQuests() async {
    setState(() {
      isLoading = true;
    });
    await QuestService.getMyAllQuests(context).then((value) {
      setState(() {
        myQuests = value;
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchMyQuests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorSet.background,
      body: SafeArea(
        maintainBottomViewPadding: true,
        child: Column(
          children: [
            const CustomAppBar(
              label: '퀘스트',
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: RemoveGlow(),
                child: SingleChildScrollView(
                  child: isLoading
                      ? const Center(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 200,
                              ),
                              CupertinoActivityIndicator(
                                radius: 17,
                                animating: true,
                              ),
                            ],
                          ),
                        )
                      : myQuests.isNotEmpty
                          ? Container(
                              width: Scaler.width(0.85, context),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF000000)
                                          .withOpacity(0.05),
                                      blurRadius: 4,
                                      offset: const Offset(0, 0),
                                    ),
                                  ]),
                              padding: const EdgeInsets.symmetric(
                                vertical: 18,
                                horizontal: 18,
                              ),
                              child: ListView.builder(
                                itemCount: myQuests.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return SmallQuestWidget(
                                    questInfo: myQuests[index].questInfo,
                                    questApplyInfo:
                                        myQuests[index].questApplyInfo,
                                    isLargeMargin: index == myQuests.length - 1,
                                  );
                                },
                              ),
                            )
                          : Container(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
