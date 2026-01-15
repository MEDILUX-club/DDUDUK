import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:dduduk_app/api/endpoints.dart';
import 'package:dduduk_app/api/api_exception.dart';
import 'package:dduduk_app/services/token_service.dart';

/// Dio 기반 API 클라이언트
class ApiClient {
  static ApiClient? _instance;
  late final Dio _dio;

  ApiClient._() {
    _dio = Dio(
      BaseOptions(
        baseUrl: Endpoints.baseUrl,
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.addAll([
      _AuthInterceptor(),
      _LoggingInterceptor(),
    ]);
  }

  /// 싱글톤 인스턴스
  static ApiClient get instance {
    _instance ??= ApiClient._();
    return _instance!;
  }

  /// Dio 인스턴스 접근
  Dio get dio => _dio;

  /// GET 요청
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// POST 요청
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// PUT 요청
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// PATCH 요청
  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// DELETE 요청
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Dio 에러를 ApiException으로 변환
  ApiException _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException(message: '서버 연결 시간이 초과되었습니다.');

      case DioExceptionType.connectionError:
        return NetworkException();

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final data = e.response?.data;

        String message = '서버 오류가 발생했습니다.';
        if (data is Map<String, dynamic>) {
          message = data['message'] ?? data['error'] ?? message;
        }

        if (statusCode == 401) {
          return TokenExpiredException();
        }

        return ApiException(
          statusCode: statusCode,
          message: message,
          data: data,
        );

      case DioExceptionType.cancel:
        return ApiException(message: '요청이 취소되었습니다.');

      default:
        return ApiException(message: e.message ?? '알 수 없는 오류가 발생했습니다.');
    }
  }
}

/// 인증 인터셉터 - 토큰 자동 주입 및 갱신
class _AuthInterceptor extends Interceptor {
  bool _isRefreshing = false;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final noAuthPaths = [
      Endpoints.login,
      Endpoints.refresh,
    ];

    if (!noAuthPaths.contains(options.path)) {
      try {
        final token = TokenService.instance.getAccessToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
      } catch (_) {}
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // 401 에러이고, refresh 요청이 아닌 경우에만 토큰 갱신 시도
    if (err.response?.statusCode == 401 &&
        err.requestOptions.path != Endpoints.refresh &&
        !_isRefreshing) {
      _isRefreshing = true;

      try {
        // 현재 refresh token 가져오기
        final refreshToken = TokenService.instance.getRefreshToken();
        if (refreshToken == null) {
          _isRefreshing = false;
          handler.next(err);
          return;
        }

        // 토큰 갱신 요청
        final response = await ApiClient.instance.dio.post(
          Endpoints.refresh,
          data: {'refreshToken': refreshToken},
        );

        // 새 토큰 저장
        final newAccessToken = response.data['accessToken'] as String;
        final newRefreshToken = response.data['refreshToken'] as String;
        final userId = TokenService.instance.getUserId();

        if (userId != null) {
          await TokenService.instance.saveTokens(
            accessToken: newAccessToken,
            refreshToken: newRefreshToken,
            userId: userId,
          );
        }

        _isRefreshing = false;

        // 원래 요청 재시도
        final opts = err.requestOptions;
        opts.headers['Authorization'] = 'Bearer $newAccessToken';

        final retryResponse = await ApiClient.instance.dio.fetch(opts);
        handler.resolve(retryResponse);
        return;
      } catch (refreshError) {
        _isRefreshing = false;
        // 토큰 갱신 실패 - 원래 에러 전달 (로그아웃 처리 필요)
        if (kDebugMode) {
          debugPrint('🔴 토큰 갱신 실패: $refreshError');
        }
      }
    }

    handler.next(err);
  }
}

/// 로깅 인터셉터 - 디버그 모드에서만 로그 출력
class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('┌─────────────────────────────────────');
      debugPrint('│  REQUEST: ${options.method} ${options.uri}');
      if (options.data != null) {
        debugPrint('│  Body: ${options.data}');
      }
      debugPrint('└─────────────────────────────────────');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('┌─────────────────────────────────────');
      debugPrint('│  RESPONSE: ${response.statusCode} ${response.requestOptions.uri}');
      debugPrint('│  Data: ${response.data}');
      debugPrint('└─────────────────────────────────────');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('┌─────────────────────────────────────');
      debugPrint('│  ERROR: ${err.response?.statusCode} ${err.requestOptions.uri}');
      debugPrint('│  Message: ${err.message}');
      if (err.response?.data != null) {
        debugPrint('│ Data: ${err.response?.data}');
      }
      debugPrint('└─────────────────────────────────────');
    }
    handler.next(err);
  }
}
