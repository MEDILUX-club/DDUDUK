/// API 예외 클래스
class ApiException implements Exception {
  final int? statusCode;
  final String message;
  final dynamic data;

  ApiException({
    this.statusCode,
    required this.message,
    this.data,
  });

  @override
  String toString() => 'ApiException(statusCode: $statusCode, message: $message)';

  /// 사용자에게 보여줄 에러 메시지
  String get userMessage {
    switch (statusCode) {
      case 400:
        return '잘못된 요청입니다.';
      case 401:
        return '인증이 필요합니다. 다시 로그인해주세요.';
      case 403:
        return '접근 권한이 없습니다.';
      case 404:
        return '요청한 데이터를 찾을 수 없습니다.';
      case 409:
        return '이미 존재하는 데이터입니다.';
      case 500:
        return '서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.';
      default:
        return message.isNotEmpty ? message : '알 수 없는 오류가 발생했습니다.';
    }
  }
}

/// 네트워크 예외
class NetworkException extends ApiException {
  NetworkException({String? message})
      : super(
          message: message ?? '네트워크 연결을 확인해주세요.',
        );
}

/// 토큰 만료 예외
class TokenExpiredException extends ApiException {
  TokenExpiredException()
      : super(
          statusCode: 401,
          message: '인증이 만료되었습니다.',
        );
}
