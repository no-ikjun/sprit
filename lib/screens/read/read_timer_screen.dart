import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scaler/scaler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sprit/apis/services/book.dart';
import 'package:sprit/apis/services/record.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/screens/read/widgets/selected_book.dart';
import 'package:sprit/widgets/custom_app_bar.dart';
import 'package:sprit/widgets/custom_button.dart';
import 'package:sprit/widgets/remove_glow.dart';
import 'package:sprit/widgets/switch_button.dart';

Future<RecordInfo> getRecordInfoByUuid(
  BuildContext context,
  String recordUuid,
) async {
  return await RecordService.getRecordByRecordUuid(context, recordUuid);
}

Future<void> deleteRecordByUuid(
  BuildContext context,
  String recordUuid,
) async {
  return await RecordService.deleteRecord(context, recordUuid);
}

Future<BookInfo> getBookInfoByUuid(
  BuildContext context,
  String bookUuid,
) async {
  return await BookInfoService.getBookInfoByUuid(context, bookUuid);
}

void _showBottomModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    builder: (context) {
      TextEditingController textarea = TextEditingController();
      return Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: SingleChildScrollView(
          child: SafeArea(
            maintainBottomViewPadding: true,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 8,
                ),
                Container(
                  width: 60,
                  height: 8,
                  decoration: BoxDecoration(
                    color: ColorSet.superLightGrey,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  '문구 작성',
                  style: TextStyles.timerBottomSheetTitleStyle,
                ),
                const SizedBox(
                  height: 8,
                ),
                const Text(
                  '기억하고 싶은 문구를 작성해주세요',
                  style: TextStyles.timerBottomSheetDescriptionStyle,
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: Scaler.width(0.8, context),
                  child: TextField(
                    controller: textarea,
                    autofocus: true,
                    keyboardType: TextInputType.multiline,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      hintText: "예) 선택. 집중. 몰입 대상을 정하자.",
                      hintStyle: TextStyles.timerBottomSheetHintTextStyle,
                      contentPadding: EdgeInsets.all(15),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: ColorSet.lightGrey,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: ColorSet.lightGrey,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: Scaler.width(0.8, context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('리마인드 알림 받기',
                              style:
                                  TextStyles.timerBottomSheetReminderTextStyle),
                          Text(
                            '150자 이내의 문구만 알림으로 받을 수 있어요',
                            style: TextStyles.timerBottomSheetReminderMentStyle,
                          ),
                        ],
                      ),
                      CustomSwitch(onToggle: () {}, switchValue: true),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomButton(
                  onPressed: () {},
                  width: Scaler.width(0.8, context),
                  height: 45,
                  child: const Text(
                    '저장하기',
                    style: TextStyles.loginButtonStyle,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class ReadTimerScreen extends StatefulWidget {
  final String recordUuid;
  const ReadTimerScreen({super.key, required this.recordUuid});

  @override
  State<ReadTimerScreen> createState() => _ReadTimerScreenState();
}

class _ReadTimerScreenState extends State<ReadTimerScreen>
    with WidgetsBindingObserver {
  bool isBookInfoLoading = false;

  Future<void> getRecordInfo(BuildContext context, String recordUuid) async {
    await getRecordInfoByUuid(context, recordUuid).then((recordInfo) {
      setState(() {
        selectedRecordInfo = recordInfo;
      });
      getBookInfo(context, recordInfo.bookUuid);
    });
  }

  Future<void> getBookInfo(BuildContext context, String bookUuid) async {
    setState(() {
      isBookInfoLoading = true;
    });
    await getBookInfoByUuid(context, bookUuid).then((bookInfo) {
      setState(() {
        selectedBookInfo = bookInfo;
        isBookInfoLoading = false;
      });
    });
  }

  Timer? _timer;
  int _elapsedSeconds = 0;
  bool _isRunning = true;
  DateTime? _lastPausedTime;

  RecordInfo selectedRecordInfo = const RecordInfo(
    recordUuid: '',
    bookUuid: '',
    userUuid: '',
    goalType: '',
    goalScale: 0,
    start: '',
    end: '',
    createdAt: '',
  );

  BookInfo selectedBookInfo = const BookInfo(
    bookUuid: '',
    isbn: '',
    title: '',
    authors: [],
    publisher: '',
    translators: [],
    searchUrl: '',
    thumbnail: '',
    content: '',
    publishedAt: '',
    updatedAt: '',
    score: 0,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadTimerState();
    getRecordInfo(context, widget.recordUuid);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      debugPrint('백그라운드 전환');
      _lastPausedTime = DateTime.now();
      _saveTimerState();
    } else if (state == AppLifecycleState.resumed) {
      debugPrint('다시 돌아옴');
      _updateTimerAfterResume();
    }
  }

  void _updateTimerAfterResume() {
    final currentTime = DateTime.now();
    if (_lastPausedTime != null) {
      final pauseDuration = currentTime.difference(_lastPausedTime!).inSeconds;
      setState(() {
        _elapsedSeconds += pauseDuration;
      });
      _lastPausedTime = null;
    }
    _loadTimerState();
  }

  void _startTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedSeconds++;
      });
    });
    setState(() {
      _isRunning = true;
    });
    _saveTimerState();
  }

  void _stopTimer() {
    if (_timer != null) {
      _timer!.cancel();
      _saveTimerState();
      setState(() {
        _isRunning = false;
      });
    }
  }

  void _loadTimerState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _elapsedSeconds = prefs.getInt('elapsedSeconds') ?? 0;
      _isRunning = prefs.getBool('isRunning') ?? true;
    });

    if (_isRunning && _timer == null) {
      _startTimer();
    }
  }

  void _saveTimerState() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('elapsedSeconds', _elapsedSeconds);
    prefs.setBool('isRunning', _isRunning);
  }

  String _formatTime(int seconds) {
    final int hours = seconds ~/ 3600;
    final int minutes = (seconds % 3600) ~/ 60;
    final int secondsLeft = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secondsLeft.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: ColorSet.background,
        body: SafeArea(
          maintainBottomViewPadding: false,
          child: Column(
            children: [
              const CustomAppBar(
                label: '독서 기록',
                onlyLabel: true,
              ),
              ScrollConfiguration(
                behavior: RemoveGlow(),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SelectedBook(
                        selectedBookInfo: selectedBookInfo,
                        padding: 10,
                        isLoading: isBookInfoLoading,
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Text(
                        _isRunning ? '독서 기록 중 🔥' : '잠시 쉬는 중 😴',
                        style: TextStyles.readRecordTitleStyle,
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Container(
                        width: Scaler.width(0.63, context),
                        height: Scaler.width(0.63, context),
                        decoration: BoxDecoration(
                          color: ColorSet.white,
                          borderRadius: BorderRadius.circular(
                            Scaler.width(0.63, context),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: ColorSet.primary.withOpacity(0.3),
                              offset: const Offset(0, 0),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 25),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  const Text(
                                    '독서 목표',
                                    style: TextStyles.timerGoalTitleStyle,
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    (selectedRecordInfo.goalType == 'PAGE')
                                        ? '${selectedRecordInfo.goalScale} 페이지'
                                        : selectedRecordInfo.goalScale >= 60
                                            ? '${selectedRecordInfo.goalScale ~/ 60} 시간'
                                            : '${selectedRecordInfo.goalScale} 분',
                                    style: TextStyles.timerGoalDescriptionStyle,
                                  ),
                                ],
                              ),
                              Text(
                                _formatTime(_elapsedSeconds),
                                style: TextStyles.timerTimeStyle,
                              ),
                              Column(
                                children: [
                                  const SizedBox(
                                    height: 6,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      if (_isRunning) {
                                        _stopTimer();
                                      } else {
                                        _startTimer();
                                      }
                                    },
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    child: SvgPicture.asset(
                                      _isRunning
                                          ? 'assets/images/pause_button.svg'
                                          : 'assets/images/play_button.svg',
                                      width: Scaler.width(0.63, context) * 0.2,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Column(
                        children: [
                          const Text(
                            '기억하고 싶은 내용이 있다면?',
                            style: TextStyles.timerLeaveMentStyle,
                          ),
                          const SizedBox(
                            height: 9,
                          ),
                          InkWell(
                            onTap: () {
                              _showBottomModal(context);
                            },
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: ColorSet.white,
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    offset: const Offset(0, 0),
                                    blurRadius: 4,
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    '문구 남기기',
                                    style: TextStyles.timerLeaveButtonStyle,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  SvgPicture.asset(
                                    'assets/images/write_icon.svg',
                                    width: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 28,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: () async {
                              //TODO: 진짜 종료할건지 팝업 띄우기
                              await deleteRecordByUuid(
                                context,
                                widget.recordUuid,
                              );
                              Navigator.pop(context);
                              SharedPreferences.getInstance().then(
                                (prefs) {
                                  prefs.remove('elapsedSeconds');
                                  prefs.remove('isRunning');
                                },
                              );
                            },
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(
                                color: ColorSet.lightGrey,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 36,
                              ),
                              child: const Center(
                                child: Text(
                                  '닫기',
                                  style: TextStyles.timerEndingButtonStyle,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 60,
                            decoration: BoxDecoration(
                              color: ColorSet.primary,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: ColorSet.primary.withOpacity(0.3),
                                  offset: const Offset(0, 4),
                                  blurRadius: 4,
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                            ),
                            child: const Center(
                              child: Text(
                                '저장 및 독서 종료',
                                style: TextStyles.timerEndingButtonStyle,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
