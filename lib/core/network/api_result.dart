/// API 호출 결과를 나타내는 Result 패턴
sealed class ApiResult<T> {
  const ApiResult();
}

/// 성공 결과
class ApiSuccess<T> extends ApiResult<T> {
  final T data;

  const ApiSuccess(this.data);
}

/// 실패 결과
class ApiFailure<T> extends ApiResult<T> {
  final String message;
  final int? statusCode;
  final dynamic error;

  const ApiFailure(
    this.message, {
    this.statusCode,
    this.error,
  });

  /// 성공 여부 확인
  bool get isSuccess => false;
  bool get isFailure => true;
}

/// ApiResult 확장 메서드
extension ApiResultExtension<T> on ApiResult<T> {
  /// 성공 여부
  bool get isSuccess => this is ApiSuccess<T>;

  /// 실패 여부
  bool get isFailure => this is ApiFailure<T>;

  /// 데이터 가져오기 (성공 시)
  T? get dataOrNull => switch (this) {
        ApiSuccess(data: final d) => d,
        ApiFailure() => null,
      };

  /// 데이터 가져오기 (실패 시 기본값)
  T dataOr(T defaultValue) => switch (this) {
        ApiSuccess(data: final d) => d,
        ApiFailure() => defaultValue,
      };

  /// 에러 메시지 가져오기
  String? get errorMessage => switch (this) {
        ApiSuccess() => null,
        ApiFailure(message: final m) => m,
      };

  /// fold: 성공/실패에 따라 다른 함수 실행
  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(String message, int? statusCode, dynamic error)
        onFailure,
  }) {
    return switch (this) {
      ApiSuccess(data: final d) => onSuccess(d),
      ApiFailure(message: final m, statusCode: final s, error: final e) =>
        onFailure(m, s, e),
    };
  }
}
