import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/amplitude_service.dart';
import 'package:sprit/apis/services/phrase.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/common/value/amplitude_events.dart';
import 'package:sprit/common/value/router.dart';
import 'package:sprit/providers/user_info.dart';
import 'package:sprit/screens/library/widgets/library_phrase_widget.dart';

Future<PhraseLibraryListCallback> getPhraseForLibraryScreen(
  BuildContext context,
) async {
  return await PhraseService.getPhraseForLibraryScreen(context);
}

class MyPhraseComponent extends StatefulWidget {
  const MyPhraseComponent({super.key});

  @override
  State<MyPhraseComponent> createState() => _MyPhraseComponentState();
}

class _MyPhraseComponentState extends State<MyPhraseComponent> {
  List<PhraseLibraryType> phraseInfoList = [];

  void _initialize() async {
    await getPhraseForLibraryScreen(context).then((value) {
      setState(() {
        phraseInfoList = value.phraseLibraryList;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: Scaler.width(0.85, context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '저장된 문구 (스크랩)',
                style: TextStyles.myLibrarySubTitleStyle,
              ),
              InkWell(
                onTap: () {
                  AmplitudeService().logEvent(
                    AmplitudeEvent.libraryPhraseShowMore,
                    properties: {
                      'userUuid':
                          context.read<UserInfoState>().userInfo.userUuid,
                    },
                  );
                  Navigator.pushNamed(
                    context,
                    RouteName.libraryPhraseScreen,
                  );
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '모두보기',
                      style: TextStyles.myLibraryShowMoreStyle,
                    ),
                    Transform.rotate(
                      angle: 270 * math.pi / 180,
                      child: SvgPicture.asset(
                        'assets/images/show_more_grey.svg',
                        width: 21,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        phraseInfoList.isNotEmpty
            ? SizedBox(
                width: Scaler.width(0.85, context),
                child: ListView.builder(
                  itemCount: phraseInfoList.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        LibraryPhraseWidget(
                          phraseUuid: phraseInfoList[index].phraseUuid,
                          phrase: phraseInfoList[index].phrase,
                          bookTitle: phraseInfoList[index].bookTitle,
                          bookThumbnail: phraseInfoList[index].bookThumbnail,
                          page: phraseInfoList[index].page,
                          callback: () async {
                            setState(() {
                              phraseInfoList = [];
                            });
                            await getPhraseForLibraryScreen(
                              context,
                            ).then((value) {
                              setState(() {
                                phraseInfoList = value.phraseLibraryList;
                              });
                            });
                          },
                        ),
                        index != phraseInfoList.length - 1
                            ? const SizedBox(
                                height: 8,
                              )
                            : Container(),
                      ],
                    );
                  },
                ),
              )
            : Container(
                width: Scaler.width(0.85, context),
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 20,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: ColorSet.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: SizedBox(
                  width: Scaler.width(0.85, context),
                  height: 35,
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '스크랩된 문구가 없어요 💬',
                          style: TextStyles.questButtonStyle,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ],
    );
  }
}
