import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:scaler/scaler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sprit/apis/services/record.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/common/util/functions.dart';
import 'package:sprit/popups/read/close_confirm.dart';
import 'package:sprit/popups/read/end_page.dart';
import 'package:sprit/popups/read/end_time.dart';
import 'package:sprit/providers/selected_book.dart';
import 'package:sprit/providers/selected_record.dart';
import 'package:sprit/screens/read/widgets/phrase_modal.dart';
import 'package:sprit/screens/read/widgets/selected_book.dart';
import 'package:sprit/widgets/custom_app_bar.dart';
import 'package:sprit/widgets/remove_glow.dart';

Future<void> deleteRecordByUuid(
  BuildContext context,
  String recordUuid,
) async {
  return await RecordService.deleteRecord(context, recordUuid);
}

class ReadTimerScreen extends StatefulWidget {
  const ReadTimerScreen({super.key});

  @override
  State<ReadTimerScreen> createState() => _ReadTimerScreenState();
}

class _ReadTimerScreenState extends State<ReadTimerScreen>
    with WidgetsBindingObserver {
  void _showBottomModal(
    BuildContext context,
    String phrase,
    bool remind,
    Function onPhraseChanged,
    Function onRemindChanged,
    Function onSubmitted,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      builder: (context) {
        TextEditingController textarea = TextEditingController();
        return PhraseModal(
          textarea: textarea,
          bookUuid: context
              .read<SelectedBookInfoState>()
              .getSelectedBookInfo
              .bookUuid,
        );
      },
    );
  }

  bool isBookInfoLoading = false;

  Timer? _timer;
  int _elapsedSeconds = 0;
  bool _isRunning = true;
  DateTime? _lastPausedTime;

  //문구 관련 상태 관리
  String phrase = '';
  bool remind = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadTimerState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      debugPrint('백그라운드 전환');
      _lastPausedTime = DateTime.now();
      _saveTimerState();
    } else if (state == AppLifecycleState.resumed) {
      debugPrint('다시 돌아옴');
      _updateTimerAfterResume();
    }
  }

  void _updateTimerAfterResume() async {
    final prefs = await SharedPreferences.getInstance();
    final currentTime = DateTime.now();
    if (_lastPausedTime != null) {
      final pauseDuration = currentTime.difference(_lastPausedTime!).inSeconds;
      final wasRunning = prefs.getBool('isRunning') ?? true;
      final newTime =
          wasRunning ? _elapsedSeconds + pauseDuration : _elapsedSeconds;
      setState(() {
        _elapsedSeconds = newTime;
        _isRunning = wasRunning;
      });
      if (_isRunning) {
        _startTimer();
      }
      _lastPausedTime = null;
    }
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
  }

  void _stopTimer() {
    if (_timer != null) {
      _timer!.cancel();
      setState(() {
        _isRunning = false;
      });
    }
  }

  void _loadTimerState() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('recordCreated') != null) {
      final recordCreated = DateTime.parse(prefs.getString('recordCreated')!);
      final now = DateTime.now().toUtc();
      final elapsedSeconds = now.difference(recordCreated).inSeconds;
      if (elapsedSeconds >= 24 * 60 * 60) {
        await deleteRecordByUuid(
          context,
          context
              .read<SelectedRecordInfoState>()
              .getSelectedRecordInfo
              .recordUuid,
        ).then((value) {
          context.read<SelectedRecordInfoState>().removeSelectedRecord();
          _stopTimer();
          _resetTimer();
          prefs.remove('recordCreated');
          Navigator.pop(context);
        });
      }
      setState(() {
        _elapsedSeconds = elapsedSeconds.abs();
      });
    } else {
      setState(() {
        _elapsedSeconds = prefs.getInt('elapsedSeconds') ?? 0;
        _isRunning = prefs.getBool('isRunning') ?? true;
      });
    }

    if (_isRunning && _timer == null) {
      _startTimer();
    }
  }

  void _saveTimerState() async {
    _lastPausedTime = DateTime.now();
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('elapsedSeconds', _elapsedSeconds);
    prefs.setBool('isRunning', _isRunning);
  }

  void _resetTimer() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('elapsedSeconds');
    prefs.remove('isRunning');
    setState(() {
      _elapsedSeconds = 0;
      _isRunning = true;
    });
  }

  String _formatTime(int seconds) {
    final int hours = seconds ~/ 3600;
    final int minutes = (seconds % 3600) ~/ 60;
    final int secondsLeft = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secondsLeft.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final RecordInfo selectedRecordInfo =
        context.read<SelectedRecordInfoState>().getSelectedRecordInfo;
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
                        padding: 10,
                        isLoading: isBookInfoLoading,
                      ),
                      SizedBox(
                        height: Scaler.height(0.03, context),
                      ),
                      Text(
                        _isRunning ? '독서 기록 중 🔥' : '잠시 쉬는 중 😴',
                        style: TextStyles.readRecordTitleStyle,
                      ),
                      SizedBox(
                        height: Scaler.height(0.03, context),
                      ),
                      Container(
                        width: Scaler.width(0.6, context),
                        height: Scaler.width(0.6, context),
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
                                        ? '${selectedRecordInfo.goalScale}페이지'
                                        : selectedRecordInfo.goalScale >= 60
                                            ? '${selectedRecordInfo.goalScale ~/ 60}시간'
                                            : '${selectedRecordInfo.goalScale}분',
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
                                      width: Scaler.width(0.6, context) * 0.2,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: Scaler.height(0.03, context),
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
                              _showBottomModal(context, phrase, remind,
                                  (value) {
                                setState(() {
                                  phrase = value;
                                });
                              }, () {
                                debugPrint('리마인드 알림 변경');
                                setState(() {
                                  remind = !remind;
                                });
                              }, () async {
                                if (phrase.length > 150) {
                                  setState(() {
                                    remind = false;
                                  });
                                } else {
                                  Navigator.pop(context);
                                }
                              });
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
                      SizedBox(
                        height: Scaler.height(0.03, context),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: () async {
                              await showModal(
                                context,
                                CloseConfirm(onLeftPressed: () {
                                  Navigator.pop(context);
                                }, onRightPressed: () async {
                                  await deleteRecordByUuid(
                                    context,
                                    selectedRecordInfo.recordUuid,
                                  );
                                  context
                                      .read<SelectedRecordInfoState>()
                                      .removeSelectedRecord();
                                  _stopTimer();
                                  _resetTimer();
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                }),
                                false,
                              );
                            },
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: Container(
                              height: Scaler.height(0.07, context),
                              decoration: BoxDecoration(
                                color: ColorSet.lightGrey,
                                borderRadius: BorderRadius.circular(
                                  Scaler.height(0.035, context),
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: Scaler.height(0.04, context),
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
                          InkWell(
                            onTap: () {
                              if (selectedRecordInfo.goalType == 'TIME') {
                                showModal(
                                  context,
                                  EndTime(
                                    time: _elapsedSeconds,
                                  ),
                                  false,
                                );
                              } else {
                                showModal(
                                  context,
                                  EndPage(
                                    time: _elapsedSeconds,
                                  ),
                                  false,
                                );
                              }
                            },
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: Container(
                              height: Scaler.height(0.07, context),
                              decoration: BoxDecoration(
                                color: ColorSet.primary,
                                borderRadius: BorderRadius.circular(
                                  Scaler.height(0.035, context),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: ColorSet.primary.withOpacity(0.3),
                                    offset: const Offset(0, 4),
                                    blurRadius: 4,
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: Scaler.height(0.015, context),
                              ),
                              child: const Center(
                                child: Text(
                                  '저장 및 독서 종료',
                                  style: TextStyles.timerEndingButtonStyle,
                                  textAlign: TextAlign.center,
                                ),
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
