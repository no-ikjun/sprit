import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/apis/services/phrase.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/screens/library/widgets/library_phrase_widget.dart';

Future<PhraseLibraryListCallback> getPhraseForLibrary(
  BuildContext context,
  int page,
) async {
  return await PhraseService.getPhraseForLibrary(context, page);
}

class MyPhraseComponent extends StatefulWidget {
  const MyPhraseComponent({super.key});

  @override
  State<MyPhraseComponent> createState() => _MyPhraseComponentState();
}

class _MyPhraseComponentState extends State<MyPhraseComponent> {
  List<PhraseLibraryType> phraseInfoList = [];
  bool phraseMoreAvailable = false;
  int phraseCurrentPage = 1;

  void _initialize() async {
    await getPhraseForLibrary(context, phraseCurrentPage).then((value) {
      setState(() {
        phraseInfoList = value.phraseLibraryList;
        phraseMoreAvailable = value.moreAvailable;
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
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                '저장된 문구 (스크랩)',
                style: TextStyles.myLibrarySubTitleStyle,
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
        phraseMoreAvailable
            ? Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  InkWell(
                    onTap: () async {
                      await getPhraseForLibrary(
                        context,
                        phraseCurrentPage + 1,
                      ).then((value) {
                        setState(() {
                          phraseInfoList.addAll(value.phraseLibraryList);
                          phraseMoreAvailable = value.moreAvailable;
                          phraseCurrentPage++;
                        });
                      });
                    },
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          '더보기',
                          style: TextStyles.myLibraryShowMoreStyle,
                        ),
                        SvgPicture.asset(
                          'assets/images/arrow_right.svg',
                          width: 12,
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : Container(),
      ],
    );
  }
}
