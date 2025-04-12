import 'package:amplitude_flutter/amplitude.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AmplitudeService {
  late Amplitude _amplitude;

  Future<void> init() async {
    _amplitude = Amplitude.getInstance(instanceName: 'sprit');
    await _amplitude.init(dotenv.env["AMPLITUDE_API_KEY"]!);
  }

  void logEvent(String eventName, {Map<String, dynamic>? properties}) {
    _amplitude.logEvent(
      kReleaseMode ? eventName : "DEV_LOG",
      eventProperties: properties,
    );
  }
}
