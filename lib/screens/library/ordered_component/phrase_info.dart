import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/amplitude_service.dart';
import 'package:sprit/apis/services/phrase.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/common/value/amplitude_events.dart';
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
                    context.read<UserInfoState>().userInfo.userUuid,
                  );
                  //TODO: show all phrases button action
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
        SizedBox(
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
        ),
        // phraseMoreAvailable
        //     ? Column(
        //         children: [
        //           const SizedBox(
        //             height: 15,
        //           ),
        //           InkWell(
        //             onTap: () async {
        //               AmplitudeService().logEvent(
        //                 AmplitudeEvent.libraryPhraseShowMore,
        //                 context.read<UserInfoState>().userInfo.userUuid,
        //               );
        //               await getPhraseForLibrary(
        //                 context,
        //                 phraseCurrentPage + 1,
        //               ).then((value) {
        //                 setState(() {
        //                   phraseInfoList.addAll(value.phraseLibraryList);
        //                   phraseMoreAvailable = value.moreAvailable;
        //                   phraseCurrentPage++;
        //                 });
        //               });
        //             },
        //             splashColor: Colors.transparent,
        //             highlightColor: Colors.transparent,
        //             child: Row(
        //               mainAxisAlignment: MainAxisAlignment.center,
        //               children: [
        //                 const Text(
        //                   '더보기',
        //                   style: TextStyles.myLibraryShowMoreStyle,
        //                 ),
        //                 SvgPicture.asset(
        //                   'assets/images/show_more_grey.svg',
        //                   width: 21,
        //                 )
        //               ],
        //             ),
        //           ),
        //         ],
        //       )
        //     : phraseInfoList.length > 3
        //         ? Column(
        //             children: [
        //               const SizedBox(
        //                 height: 15,
        //               ),
        //               InkWell(
        //                 onTap: () async {
        //                   setState(() {
        //                     phraseInfoList = phraseInfoList.sublist(0, 3);
        //                     phraseMoreAvailable = true;
        //                     phraseCurrentPage = 1;
        //                   });
        //                 },
        //                 splashColor: Colors.transparent,
        //                 highlightColor: Colors.transparent,
        //                 child: Row(
        //                   mainAxisAlignment: MainAxisAlignment.center,
        //                   children: [
        //                     const Text(
        //                       '숨기기',
        //                       style: TextStyles.myLibraryShowMoreStyle,
        //                     ),
        //                     Transform.rotate(
        //                       angle: 180 * math.pi / 180,
        //                       child: SvgPicture.asset(
        //                         'assets/images/show_more_grey.svg',
        //                         width: 21,
        //                       ),
        //                     )
        //                   ],
        //                 ),
        //               ),
        //             ],
        //           )
        //         : Container(),
      ],
    );
  }
}
