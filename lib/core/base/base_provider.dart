// lib/core/providers/base_provider.dart
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:hsse_app/core/configs/app_config.dart';

class BaseProvider extends GetxService {
  late Dio _dio;

  Dio get dio => _dio;

  @override
  void onInit() {
    super.onInit();
    _initializeDio();
  }

  void _initializeDio() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: Duration(milliseconds: AppConfig.connectTimeout),
        receiveTimeout: Duration(milliseconds: AppConfig.receiveTimeout),
        sendTimeout: Duration(milliseconds: AppConfig.sendTimeout),
        headers: _getDefaultHeaders(),
      ),
    );

    _setupInterceptors();
  }

  Map<String, dynamic> _getDefaultHeaders() {
    final headers = <String, dynamic>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'User-Agent': AppConfig.userAgent,
    };

    final apiKey = AppConfig.apiKey;
    if (apiKey != null && apiKey.isNotEmpty) {
      headers['Authorization'] = 'Bearer $apiKey';
    }

    return headers;
  }

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          _logRequest(options);
          handler.next(options);
        },
        onResponse: (response, handler) {
          _logResponse(response);
          handler.next(response);
        },
        onError: (error, handler) {
          _logError(error);
          handler.next(error);
        },
      ),
    );

    _dio.interceptors.add(RetryInterceptor());

    if (AppConfig.isProduction) {
      _dio.interceptors.add(SSLPinningInterceptor());
    }
  }

  void _logRequest(RequestOptions options) {
    if (!AppConfig.isLoggingEnabled) return;

    debugPrint('🚀 REQUEST: ${options.method} ${options.uri}');
    if (options.data != null) {
      debugPrint('📦 DATA: ${options.data}');
    }
    if (options.queryParameters.isNotEmpty) {
      debugPrint('❓ QUERY: ${options.queryParameters}');
    }
  }

  void _logResponse(Response response) {
    if (!AppConfig.isLoggingEnabled) return;

    debugPrint(
      '✅ RESPONSE: ${response.statusCode} ${response.requestOptions.uri}',
    );
    debugPrint('📥 DATA: ${response.data}');
  }

  void _logError(DioException error) {
    if (!AppConfig.isLoggingEnabled) return;

    debugPrint('❌ ERROR: ${error.type} ${error.requestOptions.uri}');
    debugPrint('💥 MESSAGE: ${error.message}');
    if (error.response?.data != null) {
      debugPrint('📄 RESPONSE: ${error.response?.data}');
    }
  }

  // GET Request
  Future<Response> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  // POST Request
  Future<Response> post(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  // PUT Request
  Future<Response> put(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  // DELETE Request
  Future<Response> delete(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  // Upload File
  Future<Response> uploadFile(
    String endpoint,
    File file, {
    String fieldName = 'file',
    Map<String, dynamic>? additionalData,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      final fileSize = await file.length();
      if (fileSize > AppConfig.maxUploadSize) {
        throw DioException(
          requestOptions: RequestOptions(path: endpoint),
          error:
              'File size exceeds maximum allowed size (${AppConfig.maxUploadSize ~/ 1024 ~/ 1024}MB)',
          type: DioExceptionType.badResponse,
        );
      }

      final formData = FormData.fromMap({
        fieldName: await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
        ...?additionalData,
      });

      return await _dio.post(
        endpoint,
        data: formData,
        onSendProgress: onSendProgress,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );
    } catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  // Error handling - just for logging, actual error handling di service layer
  void _handleError(dynamic error) {
    if (error is DioException) {
      String errorMessage = '';

      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          errorMessage = 'Request timeout. Please check your connection.';
          break;

        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          final responseData = error.response?.data;

          switch (statusCode) {
            case 401:
              errorMessage = 'Unauthorized access.';
              break;
            case 403:
              errorMessage = 'Access forbidden.';
              break;
            case 404:
              errorMessage = 'Resource not found.';
              break;
            case 422:
              errorMessage = 'Validation error.';
              break;
            case 429:
              errorMessage = 'Too many requests.';
              break;
            case 500:
            case 502:
            case 503:
              errorMessage = 'Server error.';
              break;
            default:
              errorMessage =
                  responseData?['message'] ?? 'Server error occurred.';
          }
          break;

        case DioExceptionType.connectionError:
          errorMessage = 'Network connection error.';
          break;

        case DioExceptionType.cancel:
          errorMessage = 'Request was cancelled.';
          break;

        default:
          errorMessage = error.message ?? 'An unknown error occurred.';
      }

      if (AppConfig.isLoggingEnabled) {
        debugPrint('💥 API ERROR: $errorMessage');
        if (error.response?.data != null) {
          debugPrint('📄 ERROR DETAILS: ${error.response?.data}');
        }
      }
    }
  }

  // Utility methods
  void updateApiKey(String newApiKey) {
    _dio.options.headers['Authorization'] = 'Bearer $newApiKey';
  }

  void clearApiKey() {
    _dio.options.headers.remove('Authorization');
  }

  void updateBaseUrl(String newBaseUrl) {
    _dio.options.baseUrl = newBaseUrl;
  }

  void addHeader(String key, String value) {
    _dio.options.headers[key] = value;
  }

  void removeHeader(String key) {
    _dio.options.headers.remove(key);
  }
}

// Retry Interceptor
class RetryInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final request = err.requestOptions;
    final retries = request.extra['retries'] ?? 0;

    if (retries < AppConfig.maxRetries && _shouldRetry(err)) {
      request.extra['retries'] = retries + 1;

      // Exponential backoff
      await Future.delayed(Duration(seconds: retries + 1));

      try {
        final response = await Dio().fetch(request);
        handler.resolve(response);
      } catch (e) {
        handler.next(err);
      }
    } else {
      handler.next(err);
    }
  }

  bool _shouldRetry(DioException error) {
    return error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError ||
        (error.response?.statusCode != null &&
            error.response!.statusCode! >= 500);
  }
}

// SSL Pinning Interceptor (placeholder)
class SSLPinningInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // TODO: Implement SSL pinning validation
    if (AppConfig.certificatePins.isNotEmpty) {
      // Add SSL pinning logic here
    }
    handler.next(options);
  }
}
