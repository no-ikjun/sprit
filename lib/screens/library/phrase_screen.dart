import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/apis/services/phrase.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/screens/library/widgets/library_phrase_widget.dart';
import 'package:sprit/widgets/custom_app_bar.dart';

Future<PhraseLibraryListCallback> getPhraseLibraryList(
  BuildContext context,
  int page,
) async {
  try {
    return await PhraseService.getPhraseForPhraseScreen(page);
  } catch (e) {
    return PhraseLibraryListCallback(
      phraseLibraryList: [],
      moreAvailable: false,
    );
  }
}

class LibraryPhraseScreen extends StatefulWidget {
  const LibraryPhraseScreen({super.key});

  @override
  State<LibraryPhraseScreen> createState() => _LibraryPhraseScreenState();
}

class _LibraryPhraseScreenState extends State<LibraryPhraseScreen> {
  List<PhraseLibraryType> phraseLibraryList = [];
  bool phraseLibraryMoreAvailable = false;
  int phraseLibraryCurrentPage = 1;
  final ScrollController _scrollController = ScrollController();

  bool isLoading = false;
  bool isMoreLoading = false;

  void _initialize() async {
    setState(() {
      isLoading = true;
    });
    await getPhraseLibraryList(context, phraseLibraryCurrentPage).then((value) {
      setState(() {
        phraseLibraryList = value.phraseLibraryList;
        phraseLibraryMoreAvailable = value.moreAvailable;
        isLoading = false;
      });
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent &&
        phraseLibraryMoreAvailable) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    setState(() {
      isMoreLoading = true;
    });
    phraseLibraryCurrentPage++;
    await getPhraseLibraryList(context, phraseLibraryCurrentPage).then((value) {
      setState(() {
        phraseLibraryList.addAll(value.phraseLibraryList);
        phraseLibraryMoreAvailable = value.moreAvailable;
        isMoreLoading = false;
      });
    });
  }

  @override
  void initState() {
    _initialize();
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorSet.background,
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(
              label: '저장된 문구 (스크랩)',
            ),
            isLoading
                ? const Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      CupertinoActivityIndicator(
                        radius: 16,
                        animating: true,
                      ),
                    ],
                  )
                : Expanded(
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: SizedBox(
                        width: Scaler.width(0.85, context),
                        child: Column(
                          children: [
                            ListView.builder(
                              itemCount: phraseLibraryList.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    LibraryPhraseWidget(
                                      phraseUuid:
                                          phraseLibraryList[index].phraseUuid,
                                      phrase: phraseLibraryList[index].phrase,
                                      bookTitle:
                                          phraseLibraryList[index].bookTitle,
                                      bookThumbnail: phraseLibraryList[index]
                                          .bookThumbnail,
                                      page: phraseLibraryList[index].page,
                                      callback: () async {
                                        setState(() {
                                          phraseLibraryList = [];
                                        });
                                        await getPhraseLibraryList(
                                          context,
                                          phraseLibraryCurrentPage,
                                        ).then((value) {
                                          setState(() {
                                            phraseLibraryList =
                                                value.phraseLibraryList;
                                            phraseLibraryMoreAvailable =
                                                value.moreAvailable;
                                          });
                                        });
                                      },
                                    ),
                                    index != phraseLibraryList.length - 1
                                        ? const SizedBox(
                                            height: 8,
                                          )
                                        : Container(),
                                  ],
                                );
                              },
                            ),
                            isMoreLoading
                                ? const Column(
                                    children: [
                                      SizedBox(
                                        height: 12,
                                      ),
                                      CupertinoActivityIndicator(
                                        radius: 10,
                                        animating: true,
                                      ),
                                      SizedBox(
                                        height: 12,
                                      ),
                                    ],
                                  )
                                : const SizedBox(
                                    height: 36,
                                  )
                          ],
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
