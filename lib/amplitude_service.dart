import 'package:amplitude_flutter/amplitude.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AmplitudeService {
  static final AmplitudeService _singleton = AmplitudeService._internal();
  late Amplitude _amplitude;

  factory AmplitudeService() {
    return _singleton;
  }

  AmplitudeService._internal() {
    _amplitude = Amplitude.getInstance(instanceName: 'sprit');
    _amplitude.init(dotenv.env["AMPLITUDE_API_KEY"]!);
  }

  void logEvent(String eventName,
      {Map<String, dynamic>? eventProperties}) async {
    _amplitude.logEvent(
      kReleaseMode ? eventName : "DEV_LOG",
      eventProperties: eventProperties,
    );
  }
}
