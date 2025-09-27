// map_marker.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:url_launcher/url_launcher.dart';

/// ─────────────── 지도 핀(마커) ───────────────
/// - 지도에 핀을 추가/삭제
/// - 탭 이벤트를 콜백으로 외부에 전달
class MapMarker {
  final String id;
  final String name;
  final String address;
  final NLatLng position;
  final NPoint anchor;
  final int zIndex;

  NaverMapController? _controller;
  NMarker? _pin;

  MapMarker({
    required this.id,
    required this.name,
    required this.address,
    required this.position,
    this.anchor = const NPoint(0.5, 1.0),
    this.zIndex = 0,
  });

  Future<void> addTo({
    required NaverMapController controller,
    required void Function() onTap,
    required BuildContext context, // ⬅️ 추가
  }) async {
    _controller = controller;
    await remove();

    // ⬅️ SVG를 위젯으로 렌더해서 NOverlayImage로 변환
    final pinIcon = await NOverlayImage.fromWidget(
      context: context,
      widget: SizedBox(
        child: SvgPicture.asset(
          'assets/images/location_pin_icon.svg',
          width: 34,
          fit: BoxFit.contain,
        ),
      ),
    );

    final pin = NMarker(
      id: id,
      position: position,
      icon: pinIcon, // ⬅️ 아이콘 적용
      anchor: anchor,
    );
    if (zIndex != 0) pin.setZIndex(zIndex);
    pin.setOnTapListener((_) => onTap());
    await controller.addOverlay(pin);
    _pin = pin;
  }

  Future<void> remove() async {
    if (_controller == null || _pin == null) return;
    try {
      await _controller!.deleteOverlay(_pin!.info);
    } catch (_) {}
    _pin = null;
  }
}

/// ─────────────── 말풍선 위젯 오버레이 ───────────────
/// - 진짜 플러터 위젯으로 네모 말풍선 렌더(버튼 클릭 가능)
/// - 컨트롤러의 latLngToScreenLocation으로 위치를 계산하여 Stack 위에 배치
class MarkerBubbleOverlay extends StatefulWidget {
  final NaverMapController controller;
  final NLatLng target; // 말풍선이 붙을 위경도(핀 위치)
  final String name;
  final String address;
  final bool visible; // 표시/숨김
  final Size size; // 말풍선 크기
  final double aboveMeters; // 핀 위로 띄울 높이(미터)
  final EdgeInsets mapPadding; // NaverMap contentPadding과 동일하게 주면 겹침 방지

  const MarkerBubbleOverlay({
    super.key,
    required this.controller,
    required this.target,
    required this.name,
    required this.address,
    required this.visible,
    this.size = const Size(260, 110),
    this.aboveMeters = 48,
    this.mapPadding = EdgeInsets.zero,
  });

  @override
  State<MarkerBubbleOverlay> createState() => _MarkerBubbleOverlayState();
}

class _MarkerBubbleOverlayState extends State<MarkerBubbleOverlay> {
  Offset _anchorPx = Offset.zero; // 지도 위(좌상단 기준) 픽셀 좌표

  @override
  void initState() {
    super.initState();
    _reposition();
  }

  @override
  void didUpdateWidget(covariant MarkerBubbleOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.target != widget.target ||
        oldWidget.visible != widget.visible ||
        oldWidget.size != widget.size ||
        oldWidget.aboveMeters != widget.aboveMeters) {
      _reposition();
    }
  }

  Future<void> _reposition() async {
    if (!mounted) return;

    final meterPerDp = widget.controller
        .getMeterPerDpAtLatitude(latitude: widget.target.latitude, zoom: 15);

    final dyDp = widget.aboveMeters / meterPerDp;

    // 위경도 → 화면 좌표
    final p = await widget.controller.latLngToScreenLocation(widget.target);
    final px = Offset(p.x, p.y - dyDp); // 위로 'aboveMeters'만큼 올림

    if (!mounted) return;
    setState(() => _anchorPx = px);
  }

  // 외부에서 onCameraChange/onCameraIdle 때 호출해 위치 갱신해줄 수 있게 메서드 노출
  void updatePosition() => _reposition();

  @override
  Widget build(BuildContext context) {
    if (!widget.visible) return const SizedBox.shrink();

    // 말풍선 좌표: 앵커를 말풍선 하단 중앙으로 보정
    final left = _anchorPx.dx - widget.size.width / 2 + widget.mapPadding.left;
    final top = _anchorPx.dy - widget.size.height - 20 + widget.mapPadding.top;

    return Positioned(
      left: left,
      top: top,
      width: widget.size.width,
      height: widget.size.height,
      child: _BubbleCard(
        title: widget.name,
        address: widget.address,
        onNaverMap: () => _openNaverPlace(
          widget.name,
          widget.address,
          widget.target,
        ),
      ),
    );
  }

  Future<void> _openNaverPlace(String name, String address, NLatLng pos) async {
    final rawLabel =
        (name.isNotEmpty ? name : address).replaceAll('\n', ' ').trim();
    final label = Uri.encodeComponent(rawLabel);
    final lat = pos.latitude.toStringAsFixed(7);
    final lng = pos.longitude.toStringAsFixed(7);

    String appName = 'sprit.app';
    try {
      appName = (await PackageInfo.fromPlatform()).packageName;
    } catch (_) {}

    // NAVER 지도 앱 스킴
    final nmapPlace = Uri.parse(
        'nmap://place?lat=$lat&lng=$lng&name=$label&appname=$appName');
    final nmapMap =
        Uri.parse('nmap://map?lat=$lat&lng=$lng&zoom=17&appname=$appName');

    // 웹 백업: 좌표 중심 + 검색어를 같이 넣어 '서울시청 기본' 이슈 방지
    final webUrl = Uri.parse(
        'https://map.naver.com/v5/search/$label?c=$lng,$lat,17,0,0,0');

    if (Platform.isAndroid) {
      // 권장: Intent 스킴 (미설치 시 자동으로 스토어/웹 핸들링 가능)
      final intentUrl = Uri.parse(
          'intent://place?lat=$lat&lng=$lng&name=$label&appname=$appName'
          '#Intent;scheme=nmap;action=android.intent.action.VIEW;'
          'category=android.intent.category.BROWSABLE;package=com.nhn.android.nmap;end');

      if (await canLaunchUrl(intentUrl) &&
          await launchUrl(intentUrl, mode: LaunchMode.externalApplication)) {
        return;
      }

      if (await canLaunchUrl(nmapPlace) &&
          await launchUrl(nmapPlace, mode: LaunchMode.externalApplication)) {
        return;
      }

      await launchUrl(webUrl, mode: LaunchMode.externalApplication);
    } else {
      // iOS: nmap 스킴 (Info.plist에 LSApplicationQueriesSchemes 필요)
      if (await canLaunchUrl(nmapPlace) &&
          await launchUrl(nmapPlace, mode: LaunchMode.externalApplication)) {
        return;
      }

      if (await canLaunchUrl(nmapMap) &&
          await launchUrl(nmapMap, mode: LaunchMode.externalApplication)) {
        return;
      }

      await launchUrl(webUrl, mode: LaunchMode.externalApplication);
    }
  }
}

/// 네모 말풍선 UI
class _BubbleCard extends StatelessWidget {
  final String title;
  final String address;
  final VoidCallback onNaverMap;

  const _BubbleCard({
    required this.title,
    required this.address,
    required this.onNaverMap,
  });

  @override
  Widget build(BuildContext context) {
    final t = title.isNotEmpty ? title : '이름 없음';
    final a = address.isNotEmpty ? address : '주소 정보 없음';

    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            Text(
              a,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
            const Spacer(),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: onNaverMap,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: ColorSet.primary,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              'assets/images/naver_small_icon.svg',
                              width: 14,
                              height: 14,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '네이버 지도 열기',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
