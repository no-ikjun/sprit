import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/apis/services/book_search.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/screens/search/widgets/search_result.dart';
import 'package:sprit/widgets/custom_app_bar.dart';

Future<Map<String, dynamic>> searchBook(
  BuildContext context,
  String query,
  int page,
) async {
  return await BookSearchService.searchBook(context, query, page);
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with AutomaticKeepAliveClientMixin {
  bool isLoading = false;

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
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !isEnd) {
      _loadMoreData();
    }
  }

  Future<void> _loadMoreData() async {
    if (isLoading) return;
    currentPage++;
    Map<String, dynamic> response =
        await searchBook(context, query, currentPage);
    setState(() {
      searchResult.addAll(response['search_list']);
      isEnd = response['is_end'];
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
        child: Column(
          children: [
            const CustomAppBar(
              label: '도서 검색',
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Scaler.width(0.075, context),
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
                  debugPrint(response.toString());
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
                    borderSide: BorderSide(color: ColorSet.grey, width: 1.0),
                    borderRadius: BorderRadius.all(
                      Radius.circular(12),
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(10),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: ColorSet.border, width: 1.0),
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
                              child: ListView.builder(
                                key: const PageStorageKey<String>(
                                    'search-results'),
                                controller: _scrollController,
                                shrinkWrap: true,
                                itemCount: searchResult.length,
                                itemBuilder: (context, index) {
                                  return SearchResultWidget(
                                    bookInfo: searchResult[index],
                                  );
                                },
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
