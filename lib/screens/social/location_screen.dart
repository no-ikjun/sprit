import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/apis/services/location.dart';
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

  final GlobalKey _bubbleKey = GlobalKey(); // 말풍선 위치 갱신용
  MapMarker? _selected; // 선택된 마커
  bool _bubbleVisible = false;

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
              child: Container(
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

                                final overlay = controller.getLocationOverlay();
                                overlay.setIsVisible(true);

                                controller.setLocationTrackingMode(
                                  NLocationTrackingMode.noFollow,
                                );

                                final pos = _initialPosition!;
                                await _loadAndPlotLocations(
                                  latitude: pos.latitude,
                                  longitude: pos.longitude,
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

                            // ⬇️ 말풍선 위젯 오버레이 (선택된 마커가 있을 때만)
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

  Future<void> _loadAndPlotLocations({
    required double latitude,
    required double longitude,
  }) async {
    if (_isPlotted) return; // 초기 1회만 표시
    try {
      // API 호출 파라미터 설정
      const int radius = 50000000; // 1km 반경
      const int zoom = 15;
      const int maxCandidates = 200;

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
}
