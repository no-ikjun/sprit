import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/apis/services/location.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/widgets/custom_app_bar.dart';
import 'package:sprit/widgets/map_marker.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  NaverMapController? _controller;
  final List<MapMarker> _markers = [];
  bool _isPlotted = false;
  NLatLng? _initialPosition;
  bool _isInitLoading = true;

  final GlobalKey _mapAreaKey = GlobalKey();
  final GlobalKey _bubbleKey = GlobalKey(); // 말풍선 위치 갱신용
  MapMarker? _selected; // 선택된 마커
  bool _bubbleVisible = false;

  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _prepareInitialPosition();
  }

  @override
  void dispose() {
    for (final m in _markers) {
      m.remove(); // 내부에서 NOverlayInfo로 안전 삭제
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(label: '독서 스팟 찾기'),
            Expanded(
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      key: _mapAreaKey,
                      width: Scaler.width(0.85, context),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: List.generate(
                          1,
                          (index) => BoxShadow(
                            color: const Color(0x0D000000).withOpacity(0.05),
                            offset: const Offset(0, 0),
                            blurRadius: 3,
                            spreadRadius: 0,
                          ),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: (_isInitLoading || _initialPosition == null)
                            ? const Center(child: CircularProgressIndicator())
                            : Stack(
                                children: [
                                  NaverMap(
                                    options: NaverMapViewOptions(
                                      locationButtonEnable: true,
                                      initialCameraPosition: NCameraPosition(
                                        target: _initialPosition!,
                                        zoom: 12,
                                      ),
                                    ),
                                    onMapReady: (controller) async {
                                      _controller = controller;

                                      final overlay =
                                          controller.getLocationOverlay();
                                      overlay.setIsVisible(true);

                                      controller.setLocationTrackingMode(
                                        NLocationTrackingMode.noFollow,
                                      );

                                      final pos = _initialPosition!;
                                      final cam =
                                          await controller.getCameraPosition();
                                      final dynamicRadius =
                                          await _computeViewportRadiusMeters(); // ⬅️ 추가
                                      final dynamicZoom = cam.zoom.round();

                                      await _loadAndPlotLocations(
                                        latitude: pos.latitude,
                                        longitude: pos.longitude,
                                        radius: dynamicRadius, // ⬅️ 전달
                                        zoom: dynamicZoom, // ⬅️ 전달
                                      );
                                    },
                                    // ⬇️ 카메라 이동/정지 때 말풍선 위치 재계산
                                    onCameraChange: (_, __) {
                                      final st = _bubbleKey.currentState;
                                      if (st != null) {
                                        try {
                                          (st as dynamic).updatePosition();
                                        } catch (_) {}
                                      }
                                    },
                                    onCameraIdle: () {
                                      final st = _bubbleKey.currentState;
                                      if (st != null) {
                                        try {
                                          (st as dynamic).updatePosition();
                                        } catch (_) {}
                                      }
                                    },
                                  ),

                                  // 말풍선 위젯 오버레이 (선택된 마커가 있을 때만)
                                  if (_controller != null && _selected != null)
                                    MarkerBubbleOverlay(
                                      key: _bubbleKey,
                                      controller: _controller!,
                                      target: _selected!.position,
                                      name: _selected!.name,
                                      address: _selected!.address,
                                      visible: _bubbleVisible,
                                    ),
                                ],
                              ),
                      ),
                    ),
                  ),
                  // 위치 초기화 버튼
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: Scaler.height(0.05, context),
                      ),
                      child: InkWell(
                        onTap: _isSearching
                            ? null
                            : () async {
                                if (_controller == null) return;

                                setState(() => _isSearching = true);
                                try {
                                  // 1) 현재 카메라 중심/줌 가져오기
                                  final cam = await _controller!
                                      .getCameraPosition(); // NCameraPosition
                                  final center = cam.target;
                                  final zoomLevel = cam.zoom.round();

                                  // 2) 기존과 동일한 파라미터로 재요청 (반경/캡acity 동일, 중심/줌만 현재 카메라 기준)
                                  const int radius = 50000000; // 5km 반경
                                  const int maxCandidates = 200;

                                  final list =
                                      await LocationService.getLocationList(
                                    context,
                                    center.latitude.toString(),
                                    center.longitude.toString(),
                                    radius,
                                    zoomLevel.toInt(),
                                    maxCandidates,
                                  );

                                  if (!mounted) return;

                                  // 3) 기존 마커/말풍선 초기화
                                  for (final m in _markers) {
                                    await m.remove();
                                  }
                                  _markers.clear();
                                  setState(() {
                                    _selected = null;
                                    _bubbleVisible = false;
                                  });

                                  // 4) 새 마커 그리기
                                  if (list.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text('현재 화면 기준 근처 위치 정보가 없습니다.')),
                                    );
                                    return;
                                  }

                                  for (int i = 0; i < list.length; i++) {
                                    final item = list[i];
                                    final marker = MapMarker(
                                      id: 'loc_$i',
                                      name: item.name,
                                      address: item.address,
                                      position: NLatLng(
                                          item.latitude, item.longitude),
                                    );

                                    await marker.addTo(
                                      controller: _controller!,
                                      context: context,
                                      onTap: () {
                                        setState(() {
                                          if (_selected == marker) {
                                            _bubbleVisible = !_bubbleVisible;
                                          } else {
                                            _selected = marker;
                                            _bubbleVisible = true;
                                          }
                                        });

                                        // 말풍선 위치 즉시 보정
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) {
                                          final st = _bubbleKey.currentState;
                                          if (st != null) {
                                            try {
                                              (st as dynamic).updatePosition();
                                            } catch (_) {}
                                          }
                                        });
                                      },
                                    );

                                    _markers.add(marker);
                                  }
                                } catch (e) {
                                  debugPrint('현재 위치에서 검색 실패: $e');
                                } finally {
                                  if (mounted) {
                                    setState(() => _isSearching = false);
                                  }
                                }
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
                          child: _isSearching
                              ? const SizedBox(
                                  width: 100,
                                  height: 16,
                                  child: CupertinoActivityIndicator(
                                    radius: 8,
                                    animating: true,
                                  ),
                                )
                              : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      '현재 위치에서 검색',
                                      style: TextStyles.timerLeaveButtonStyle,
                                    ),
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    SvgPicture.asset(
                                      'assets/images/location_define_icon.svg',
                                      width: 16,
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 위치 서비스/권한을 확인하고 필요 시 요청
  Future<bool> _ensureLocationPermission() async {
    // 위치 서비스(GPS) 켜짐 여부
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    // 권한 상태 확인
    LocationPermission permission = await Geolocator.checkPermission();

    // 요청(denied면 한 번 더 요청)
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return false;
    }

    // 영구 거부 처리
    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  // 지도에 위치 목록을 불러와 마커로 표시
  Future<void> _loadAndPlotLocations({
    required double latitude,
    required double longitude,
    required int radius,
    int? zoom,
    int? maxCandidates,
  }) async {
    if (_isPlotted) return; // 초기 1회만 표시
    try {
      final List<LocationInfo> list = await LocationService.getLocationList(
        context,
        latitude.toString(),
        longitude.toString(),
        radius,
        zoom,
        maxCandidates,
      );

      if (!mounted || _controller == null) return;
      if (list.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('근처 위치 정보가 없습니다.')),
        );
        return;
      }
      debugPrint('위치 목록: ${list.length}건');
      // 마커 생성 및 지도에 추가
      for (int i = 0; i < list.length; i++) {
        final item = list[i];

        final marker = MapMarker(
          id: 'loc_$i',
          name: item.name,
          address: item.address,
          position: NLatLng(item.latitude, item.longitude),
        );

        await marker.addTo(
          controller: _controller!,
          onTap: () {
            setState(() {
              // 같은 마커를 다시 누르면 말풍선 토글, 다른 마커면 교체 + 열기
              if (_selected == marker) {
                _bubbleVisible = !_bubbleVisible;
              } else {
                _selected = marker;
                _bubbleVisible = true;
              }
            });

            // 위치 재계산(카메라 이벤트 없이도 즉시 맞춤)
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final st = _bubbleKey.currentState;
              if (st != null) {
                try {
                  (st as dynamic).updatePosition();
                } catch (_) {}
              }
            });
          },
          context: context,
        );

        _markers.add(marker);
      }

      _isPlotted = true;
    } catch (e) {
      debugPrint('위치 목록 표시 실패: $e');
    }
  }

  // 초기 위치(현재 위치 또는 기본값) 설정
  Future<void> _prepareInitialPosition() async {
    try {
      final ok = await _ensureLocationPermission();
      if (!ok) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('위치 권한/서비스를 확인해주세요.')),
          );
        }
        // 권한이 없을 경우 기본 좌표로 설정(서울 시청)
        _initialPosition = const NLatLng(37.5666, 126.9790);
      } else {
        final pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best,
        );
        _initialPosition = NLatLng(pos.latitude, pos.longitude);
        debugPrint('초기 위치 설정: ${pos.latitude}, ${pos.longitude}');
      }
    } catch (e) {
      debugPrint('초기 위치 가져오기 실패: $e');
      _initialPosition = const NLatLng(37.5666, 126.9790);
    } finally {
      if (mounted) {
        setState(() {
          _isInitLoading = false;
        });
      } else {
        _isInitLoading = false;
      }
    }
  }

  // 현재 뷰포트 반경(m) 계산
  Future<int> _computeViewportRadiusMeters() async {
    if (_controller == null) return 1000; // fallback 1km
    // 카메라 중심 위도에서 1dp당 몇 m인지 계산
    final cam = await _controller!.getCameraPosition();
    final meterPerDp = _controller!.getMeterPerDpAtLatitude(
      latitude: cam.target.latitude,
      zoom: cam.zoom,
    );

    // 지도 위젯의 가로/세로(dp) (논리 픽셀 == dp)
    final size = _mapAreaKey.currentContext?.size ?? MediaQuery.sizeOf(context);
    final w = size.width;
    final h = size.height;

    // 뷰포트 대각선의 절반 ≈ 화면 반경 → m로 변환
    final halfDiagDp = 0.5 * math.sqrt(w * w + h * h);
    final radiusMeters = (halfDiagDp * meterPerDp).round();
    return math.max(1, radiusMeters);
  }
}
