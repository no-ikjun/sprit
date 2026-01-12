import 'package:dio/dio.dart';
import 'package:sprit/core/network/api_client.dart';
import 'package:sprit/core/network/api_exception.dart';
import 'package:sprit/core/util/logger.dart';

class LocationInfo {
  final double latitude;
  final double longitude;
  final String name;
  final String address;
  const LocationInfo({
    required this.latitude,
    required this.longitude,
    required this.name,
    required this.address,
  });

  static double _asDouble(dynamic v) {
    if (v is double) return v;
    if (v is int) return v.toDouble();
    if (v is String) return double.tryParse(v) ?? 0.0;
    return 0.0;
  }

  LocationInfo.fromJson(Map<String, dynamic> json)
      : latitude = _asDouble(json['latitude'] ?? json['lat'] ?? json['y']),
        longitude = _asDouble(json['longitude'] ?? json['lng'] ?? json['x']),
        name = json['name']?.toString() ?? json['title']?.toString() ?? '',
        address = json['address']?.toString() ?? json['addr']?.toString() ?? '';

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
        'name': name,
        'address': address,
      };
}

class LocationService {
  /// 주변 위치 목록 조회
  static Future<List<LocationInfo>> getLocationList(
    String latitude,
    String longitude,
    int radius,
    int? zoom,
    int? maxCandidates,
  ) async {
    try {
      final dio = ApiClient.instance.dio;
      final response = await dio.get('/locations/near', queryParameters: {
        'lat': latitude,
        'lng': longitude,
        'radius': radius,
        if (zoom != null) 'zoom': zoom,
        if (maxCandidates != null) 'maxCandidates': maxCandidates,
      });

      if (response.statusCode == 200) {
        final data = response.data;
        List<dynamic> rawList = [];

        if (data is List) {
          rawList = data;
        } else if (data is Map<String, dynamic>) {
          const keys = [
            'data',
            'items',
            'list',
            'locations',
            'results',
            'content'
          ];
          for (final k in keys) {
            final v = data[k];
            if (v is List) {
              rawList = v;
              break;
            }
          }
          if (rawList.isEmpty) {
            final firstList = data.values.firstWhere(
              (v) => v is List,
              orElse: () => const [],
            );
            if (firstList is List) rawList = firstList;
          }
        }

        return rawList
            .whereType<Map<String, dynamic>>()
            .map((e) => LocationInfo.fromJson(e))
            .toList();
      } else {
        throw ServerException.fromResponse(response);
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e, stackTrace) {
      AppLogger.error('위치 조회 실패', e, stackTrace);
      rethrow;
    }
  }
}
