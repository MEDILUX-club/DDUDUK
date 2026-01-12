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
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // 인터셉터 추가
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

  // ──────────────────────────────────────
  // HTTP Methods
  // ──────────────────────────────────────

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

/// 인증 인터셉터 - 토큰 자동 주입
class _AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // 로그인/회원가입은 토큰 불필요
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
      } catch (_) {
        // TokenService가 초기화되지 않은 경우 무시
      }
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // 401 에러 시 토큰 갱신 시도
    if (err.response?.statusCode == 401) {
      // TODO: 토큰 갱신 로직 구현
      // 현재는 그냥 에러 전달
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
      debugPrint('│ 📤 REQUEST: ${options.method} ${options.uri}');
      if (options.data != null) {
        debugPrint('│ 📦 Body: ${options.data}');
      }
      debugPrint('└─────────────────────────────────────');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('┌─────────────────────────────────────');
      debugPrint('│ 📥 RESPONSE: ${response.statusCode} ${response.requestOptions.uri}');
      debugPrint('│ 📦 Data: ${response.data}');
      debugPrint('└─────────────────────────────────────');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('┌─────────────────────────────────────');
      debugPrint('│ ❌ ERROR: ${err.response?.statusCode} ${err.requestOptions.uri}');
      debugPrint('│ 💬 Message: ${err.message}');
      if (err.response?.data != null) {
        debugPrint('│ 📦 Data: ${err.response?.data}');
      }
      debugPrint('└─────────────────────────────────────');
    }
    handler.next(err);
  }
}
