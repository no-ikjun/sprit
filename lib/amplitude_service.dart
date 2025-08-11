import 'package:amplitude_flutter/amplitude.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AmplitudeService {
  Amplitude? _amp;
  bool _initing = false;

  Future<void> init() async {
    if (_amp != null || _initing) return;
    _initing = true;
    _amp = Amplitude.getInstance(instanceName: 'sprit');
    await _amp!.init(dotenv.env['AMPLITUDE_API_KEY']!);
    _initing = false;
  }

  Future<void> logEvent(String eventName,
      {Map<String, dynamic>? properties}) async {
    if (_amp == null) await init(); // ★ 필요시 즉시 초기화
    _amp?.logEvent(
      kReleaseMode ? eventName : 'DEV_LOG',
      eventProperties: properties,
    );
  }
}
