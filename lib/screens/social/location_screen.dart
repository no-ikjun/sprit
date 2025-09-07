import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  NaverMapController? _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NaverMap(
        options: const NaverMapViewOptions(
          locationButtonEnable: true, // 내 위치 버튼
          initialCameraPosition: NCameraPosition(
            target: NLatLng(37.5666, 126.979), // 초기값(곧 현재 위치로 이동)
            zoom: 14,
          ),
        ),
        onMapReady: (controller) async {
          _controller = controller;

          // 1) 내 위치 오버레이 표시
          final overlay = controller.getLocationOverlay();
          overlay.setIsVisible(true);

          // 2) 위치 권한 & 서비스 체크
          final ok = await _ensureLocationPermission();
          if (!ok) {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('위치 권한/서비스를 확인해주세요.')),
            );
            return;
          }

          // 3) 현재 좌표 가져오기 (geolocator)
          final pos = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
          );

          // 4) 카메라를 현재 위치로 이동
          controller.updateCamera(
            NCameraUpdate.scrollAndZoomTo(
              target: NLatLng(pos.latitude, pos.longitude),
              zoom: 15,
            ),
          );

          // 5) (선택) 내 위치를 계속 따라가도록
          // - follow: 지도 중심을 내 위치로 유지
          // - face: 진행방향 기준 회전 포함
          controller.setLocationTrackingMode(NLocationTrackingMode.follow);
        },
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
}
