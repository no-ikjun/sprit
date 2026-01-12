import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/apis/services/notice.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/common/util/functions.dart';
import 'package:sprit/widgets/custom_app_bar.dart';

Future<NoticeInfo> getNoticeInfo(String recordUuid) async {
  try {
    return await NoticeService.getNoticeInfo(recordUuid);
  } catch (e) {
    return const NoticeInfo(
      noticeUuid: '',
      title: '',
      body: '',
      type: '',
      createdAt: '',
    );
  }
}

class NoticeDetailScreen extends StatefulWidget {
  final String recordUuid;
  const NoticeDetailScreen({super.key, required this.recordUuid});

  @override
  State<NoticeDetailScreen> createState() => _NoticeDetailScreenState();
}

class _NoticeDetailScreenState extends State<NoticeDetailScreen> {
  NoticeInfo? noticeInfo;

  void _getNoticeInfo() async {
    final info = await getNoticeInfo(widget.recordUuid);
    if (mounted) {
      setState(() {
        noticeInfo = info;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getNoticeInfo();
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
            const CustomAppBar(label: '공지사항'),
            noticeInfo != null
                ? Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 24,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: Scaler.width(0.85, context),
                                child: Text(
                                  noticeInfo!.title,
                                  style: TextStyles.noticeDetailTitleStyle,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: Scaler.width(0.85, context),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      noticeInfo!.type == 'UPDATE'
                                          ? 'assets/images/notice_update_icon.svg'
                                          : noticeInfo!.type == 'BUG'
                                              ? 'assets/images/notice_bug_icon.svg'
                                              : 'assets/images/notice_event_icon.svg',
                                      width: 16,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      '${noticeInfo!.type == 'UPDATE' ? '업데이트' : noticeInfo!.type == 'BUG' ? '버그 리포트' : '이벤트'}  |  ${getPastTime(noticeInfo!.createdAt)}',
                                      style: TextStyles.noticeTileTypeStyle,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          SizedBox(
                            width: Scaler.width(0.85, context),
                            child: Text(
                              noticeInfo!.body,
                              style: TextStyles.noticeDetailContentStyle,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : const Column(
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      Center(
                        child: CupertinoActivityIndicator(
                          radius: 15,
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
