import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:scaler/scaler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sprit/amplitude_service.dart';
import 'package:sprit/apis/services/book.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/common/value/amplitude_events.dart';
import 'package:sprit/providers/selected_book.dart';
import 'package:sprit/providers/user_info.dart';
import 'package:sprit/widgets/book_thumbnail.dart';
import 'package:sprit/widgets/custom_button.dart';

class RecordShareModal extends StatefulWidget {
  const RecordShareModal({
    super.key,
    required this.amount,
  });

  final String amount;

  @override
  State<RecordShareModal> createState() => _RecordShareModalState();
}

class _RecordShareModalState extends State<RecordShareModal> {
  Uint8List? _imageFile;
  ScreenshotController screenshotController = ScreenshotController();

  bool isImageLoading = false;

  void captureWidget() async {
    await Future.delayed(const Duration(milliseconds: 100));
    screenshotController.capture().then((value) {
      setState(() {
        _imageFile = value;
      });
    }).catchError((onError) {
      debugPrint('captureError: $onError');
    });
  }

  Future<void> saveImage(Uint8List image) async {
    setState(() {
      isImageLoading = true;
    });
    try {
      final directory = await getTemporaryDirectory();
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File('${directory.path}/$fileName');
      final result = await file.writeAsBytes(image);
      await Share.shareXFiles([XFile(result.path)]).then((value) {
        setState(() {
          isImageLoading = false;
        });
      });
    } catch (error) {
      debugPrint('saveImageError: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    captureWidget();
  }

  @override
  Widget build(BuildContext context) {
    final BookInfo bookInfo =
        context.read<SelectedBookInfoState>().getSelectedBookInfo;
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
              Screenshot(
                controller: screenshotController,
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Container(
                    width: Scaler.width(0.8, context),
                    clipBehavior: Clip.none,
                    decoration: BoxDecoration(
                      color: ColorSet.background,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          spreadRadius: 0,
                          blurRadius: 30,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          bottom: 18,
                          left: 18,
                          child: SvgPicture.asset(
                            'assets/images/logo_opacity.svg',
                            height: 18,
                          ),
                        ),
                        Positioned(
                          bottom: Scaler.width(0.05, context),
                          left: -Scaler.width(0.15, context),
                          child: Image.asset(
                            'assets/images/share_background_01.png',
                            width: Scaler.width(0.5, context),
                          ),
                        ),
                        Positioned(
                          bottom: -Scaler.width(0.05, context),
                          right: -Scaler.width(0.15, context),
                          child: Image.asset(
                            'assets/images/share_background_02.png',
                            width: Scaler.width(0.7, context),
                          ),
                        ),
                        Column(
                          children: [
                            const SizedBox(
                              height: 15,
                            ),
                            const Image(
                              image:
                                  AssetImage('assets/images/share_badge.png'),
                              width: 160,
                            ),
                            const SizedBox(
                              height: 18,
                            ),
                            Text(
                              DateFormat('yyyy년 MM월 dd일')
                                  .format(DateTime.now()),
                              style: TextStyles.shareModalDateStyle,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              widget.amount,
                              style: TextStyles.shareModalAmountStyle,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                BookThumbnail(
                                  imgUrl: bookInfo.thumbnail,
                                  width: 55.38,
                                  height: 80,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                SizedBox(
                                  height: 80,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        constraints: BoxConstraints(
                                          maxWidth: Scaler.width(0.8, context) -
                                              87.38,
                                        ),
                                        child: Text(
                                          bookInfo.title,
                                          style: TextStyles
                                              .shareModalBookTitleStyle,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                '저자 ',
                                                style: TextStyles
                                                    .shareModalBookAuthorStyle
                                                    .copyWith(
                                                  color: ColorSet.grey,
                                                ),
                                              ),
                                              Text(
                                                bookInfo.authors[0],
                                                style: TextStyles
                                                    .shareModalBookAuthorStyle,
                                              ),
                                            ],
                                          ),
                                          Text(
                                            '${bookInfo.publisher} · ${(bookInfo.publishedAt.length > 9) ? bookInfo.publishedAt.substring(0, 10) : bookInfo.publishedAt}',
                                            style: TextStyles
                                                .shareModalBookAuthorStyle
                                                .copyWith(
                                              color: ColorSet.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 170,
                            ),
                          ],
                        ),
                        isImageLoading
                            ? const Column(
                                children: [
                                  SizedBox(
                                    height: 50,
                                  ),
                                  Center(
                                    child: CupertinoActivityIndicator(
                                      radius: 17,
                                      animating: true,
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              CustomButton(
                onPressed: () async {
                  AmplitudeService().logEvent(
                    AmplitudeEvent.recordShareModalButton,
                    context.read<UserInfoState>().userInfo.userUuid,
                  );
                  saveImage(_imageFile!);
                },
                width: Scaler.width(0.8, context),
                height: 45,
                child: const Text(
                  '공유하기',
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
  }
}
