import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_result.freezed.dart';

@freezed
class ApiResult<T> with _$ApiResult<T> {
  const factory ApiResult.success(T data) = Success<T>;
  const factory ApiResult.failure(ApiError error) = Failure<T>;
}

@freezed
class ApiError with _$ApiError {
  const factory ApiError({
    required String message,
    required int statusCode,
    Map<String, List<String>>? details,
    @Default(false) bool isNetwork,
    @Default(false) bool isTimeout,
    @Default(false) bool isUnauthorized,
  }) = _ApiError;

  factory ApiError.network() => const ApiError(
    message: 'Network connection error',
    statusCode: -1,
    isNetwork: true,
  );

  factory ApiError.timeout() => const ApiError(
    message: 'Request timeout',
    statusCode: -1,
    isTimeout: true,
  );

  factory ApiError.unauthorized() => const ApiError(
    message: 'Unauthorized access',
    statusCode: 401,
    isUnauthorized: true,
  );

  factory ApiError.serverError() => const ApiError(
    message: 'Server error occurred',
    statusCode: 500,
  );

  factory ApiError.unknown() => const ApiError(
    message: 'An unknown error occurred',
    statusCode: -1,
  );
}