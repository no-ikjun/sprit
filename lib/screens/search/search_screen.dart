import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/apis/services/book.dart';
import 'package:sprit/apis/services/book_search.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/common/value/router.dart';
import 'package:sprit/screens/search/widgets/search_result.dart';
import 'package:sprit/widgets/custom_app_bar.dart';
import 'package:sprit/widgets/loader.dart';
import 'package:sprit/widgets/remove_glow.dart';

Future<Map<String, dynamic>> searchBook(
  BuildContext context,
  String query,
  int page,
) async {
  return await BookSearchService.searchBook(context, query, page);
}

Future<BookInfo> getBookInfoByISBN(
  BuildContext context,
  String isbn,
) async {
  return await BookInfoService.getBookInfoByISBN(context, isbn);
}

Future<void> registerBook(
  BuildContext context,
  String isbn,
) async {
  return await BookInfoService.registerBook(context, isbn);
}

Future<void> showBookInfo(
  BuildContext context,
  String isbn,
  String isbnAll,
) async {
  BookInfo bookInfo = await getBookInfoByISBN(context, isbnAll);
  if (bookInfo.bookUuid == '') {
    await registerBook(context, isbn);
    bookInfo = await getBookInfoByISBN(context, isbnAll);
    Navigator.pushNamed(
      context,
      RouteName.bookDetail,
      arguments: bookInfo.bookUuid,
    );
  } else {
    Navigator.pushNamed(
      context,
      '/bookDetail',
      arguments: bookInfo.bookUuid,
    );
  }
}

class SearchScreen extends StatefulWidget {
  final bool isHome;
  const SearchScreen({super.key, this.isHome = false});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with AutomaticKeepAliveClientMixin {
  bool isLoading = false;
  bool isBookInfoLoading = false;
  bool isSearchDataLoading = false;

  late ScrollController _scrollController;

  String query = '';
  List<BookSearchInfo> searchResult = [];
  bool isEnd = false;

  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent &&
        !isEnd) {
      _loadMoreData();
    }
  }

  Future<void> _loadMoreData() async {
    if (isLoading) return;
    if (isSearchDataLoading) return;
    currentPage++;
    setState(() {
      isSearchDataLoading = true;
    });
    Map<String, dynamic> response =
        await searchBook(context, query, currentPage);
    setState(() {
      searchResult.addAll(response['search_list']);
      isEnd = response['is_end'];
      isSearchDataLoading = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorSet.background,
      body: SafeArea(
        maintainBottomViewPadding: true,
        child: Stack(
          children: [
            Column(
              children: [
                CustomAppBar(
                  label: '도서 검색',
                  onlyLabel: widget.isHome,
                ),
                SizedBox(
                  width: Scaler.width(0.85, context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: Scaler.width(0.85, context) - 35,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            right: 10,
                          ),
                          child: TextField(
                            textInputAction: TextInputAction.search,
                            onChanged: (value) {
                              setState(() {
                                query = value;
                              });
                            },
                            onSubmitted: (value) async {
                              setState(() {
                                isLoading = true;
                              });
                              Map<String, dynamic> response =
                                  await searchBook(context, value, 1);
                              setState(() {
                                searchResult = response['search_list'];
                                isEnd = response['is_end'];
                                isLoading = false;
                              });
                            },
                            autofocus: true,
                            decoration: InputDecoration(
                              hintText: '검색어를 입력해주세요',
                              hintStyle: TextStyles.textFieldStyle.copyWith(
                                color: ColorSet.grey,
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: ColorSet.grey, width: 1.0),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
                                ),
                              ),
                              contentPadding: const EdgeInsets.all(10),
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: ColorSet.border, width: 1.0),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
                                ),
                              ),
                              prefixIcon: const Icon(
                                Icons.search,
                                color: ColorSet.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () async {
                              BarcodeScanner.scan().then((value) async {
                                if (value.type != ResultType.Cancelled ||
                                    value.type != ResultType.Error) {
                                  Map<String, dynamic> response =
                                      await searchBook(
                                          context, value.rawContent, 1);
                                  setState(() {
                                    searchResult = response['search_list'];
                                    isEnd = response['is_end'];
                                    isLoading = false;
                                  });
                                }
                              });
                            },
                            child: Image.asset(
                              'assets/images/barcode_icon.png',
                              width: 30,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                isLoading
                    ? const Expanded(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 50,
                            ),
                            CupertinoActivityIndicator(
                              color: ColorSet.grey,
                              animating: true,
                              radius: 15,
                            ),
                          ],
                        ),
                      )
                    : Expanded(
                        child: SizedBox(
                          width: Scaler.width(0.85, context),
                          child: (searchResult.isEmpty)
                              ? Column(
                                  children: [
                                    const SizedBox(
                                      height: 50,
                                    ),
                                    Image.asset(
                                      'assets/images/no_search.png',
                                      height: 100,
                                    ),
                                    Text(
                                      '검색 결과가 없습니다',
                                      style: TextStyles.appBarLabel.copyWith(
                                        color: ColorSet.text.withOpacity(0.4),
                                      ),
                                    ),
                                  ],
                                )
                              : Scrollbar(
                                  controller: _scrollController,
                                  child: ScrollConfiguration(
                                    behavior: RemoveGlow(),
                                    child: ListView.builder(
                                      key: const PageStorageKey<String>(
                                          'search-results'),
                                      controller: _scrollController,
                                      shrinkWrap: true,
                                      itemCount: searchResult.length,
                                      itemBuilder: (context, index) {
                                        return SearchResultWidget(
                                          bookInfo: searchResult[index],
                                          onTap: () async {
                                            setState(() {
                                              isBookInfoLoading = true;
                                            });
                                            await showBookInfo(
                                              context,
                                              searchResult[index]
                                                  .isbn
                                                  .trim()
                                                  .split(' ')[0],
                                              searchResult[index].isbn,
                                            ).then((value) {
                                              setState(() {
                                                isBookInfoLoading = false;
                                              });
                                            });
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ),
                        ),
                      ),
              ],
            ),
            isSearchDataLoading
                ? const Loader(loadingTxt: '검색 결과 로딩중...')
                : isBookInfoLoading
                    ? const Loader()
                    : Container()
          ],
        ),
      ),
    );
  }
}
