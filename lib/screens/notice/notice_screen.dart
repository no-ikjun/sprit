import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sprit/apis/services/notice.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/providers/new_notice.dart';
import 'package:sprit/screens/notice/widgets/notice_tile.dart';
import 'package:sprit/widgets/custom_app_bar.dart';

class NoticeScreen extends StatefulWidget {
  const NoticeScreen({super.key});

  @override
  State<NoticeScreen> createState() => _NoticeScreenState();
}

class _NoticeScreenState extends State<NoticeScreen> {
  final ScrollController _scrollController = ScrollController();

  List<NoticeInfo> noticeList = [];

  void _getNoticeList() async {
    final list = await NoticeService.getNoticeList(context);
    context.read<NewNoticeState>().updateNewNotice(false);
    if (mounted) {
      setState(() {
        noticeList = list;
      });
      if (noticeList.isNotEmpty) {
        final prefs = await SharedPreferences.getInstance();
        prefs.setString(
          'noticeUuid',
          noticeList[0].noticeUuid,
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _getNoticeList();
  }

  @override
  Widget build(BuildContext context) {
    Widget scrollView = CustomScrollView(
      controller: _scrollController,
      slivers: <Widget>[
        if (Platform.isIOS)
          CupertinoSliverRefreshControl(
            onRefresh: () async {
              _getNoticeList();
            },
          ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return NoticeTile(
                noticeInfo: noticeList[index],
              );
            },
            childCount: noticeList.length, // 목록의 전체 길이를 설정
          ),
        ),
        SliverFillRemaining(
          hasScrollBody: true,
          child: Container(
            color: ColorSet.background,
          ),
        )
      ],
    );

    if (Platform.isAndroid) {
      scrollView = RefreshIndicator(
        onRefresh: () async {
          _getNoticeList();
        },
        color: ColorSet.primary,
        child: scrollView,
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorSet.background,
      body: SafeArea(
        maintainBottomViewPadding: true,
        child: Column(
          children: [
            const CustomAppBar(label: '공지사항'),
            Expanded(
              child: scrollView,
            ),
          ],
        ),
      ),
    );
  }
}
