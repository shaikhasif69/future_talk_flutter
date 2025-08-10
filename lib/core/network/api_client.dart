import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../storage/secure_storage_service.dart';
import 'dart:io';

class ApiClient {
  // Dynamic base URL based on platform
  // Environment configuration
  static const bool _useProduction = true; // Change to false for development
  
  static String get baseUrl {
    if (_useProduction) {
      // Production backend URL
      return 'https://future.bytefuse.in/api/v1';
      // return 'http://10.0.2.2:8000/api/v1';

    }
    
    // Development URLs based on platform
    if (kIsWeb) {
      // Web - use localhost
      return 'http://127.0.0.1:8000/api/v1';
    } else if (Platform.isAndroid) {
      // Android emulator - use 10.0.2.2 (special IP that maps to host)
      return 'http://10.0.2.2:8000/api/v1';
    } else if (Platform.isIOS) {
      // iOS simulator - use localhost
      return 'http://127.0.0.1:8000/api/v1';
    } else {
      // Default fallback
      return 'http://127.0.0.1:8000/api/v1';
    }
  }
  
  late final Dio _dio;

  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  ApiClient._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await SecureStorageService.getAccessToken();
          print('🌐 [ApiClient] Token for ${options.path}: ${token != null ? 'EXISTS (${token.length} chars)' : 'NULL'}');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
            print('🌐 [ApiClient] Added Authorization header: Bearer ${token.substring(0, 20)}...');
          } else {
            print('🌐 [ApiClient] No token found, no Authorization header');
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            final refreshed = await _refreshToken();
            if (refreshed) {
              final token = await SecureStorageService.getAccessToken();
              error.requestOptions.headers['Authorization'] = 'Bearer $token';
              
              final clonedRequest = await _dio.fetch(error.requestOptions);
              return handler.resolve(clonedRequest);
            } else {
              await _clearTokens();
            }
          }
          handler.next(error);
        },
      ),
    );

    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      requestHeader: true,
      responseHeader: false,
      error: true,
    ));
  }

  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await SecureStorageService.getRefreshToken();
      if (refreshToken == null) return false;

      final response = await _dio.post(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
        options: Options(headers: {'Authorization': null}),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        await SecureStorageService.saveTokens(
          accessToken: data['access_token'],
          refreshToken: data['refresh_token'],
        );
        return true;
      }
    } catch (e) {
      print('Token refresh failed: $e');
    }
    return false;
  }

  Future<void> _clearTokens() async {
    await SecureStorageService.clearTokens();
  }

  Dio get dio => _dio;

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) {
    return _dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> post(String path, {dynamic data}) {
    return _dio.post(path, data: data);
  }

  Future<Response> put(String path, {dynamic data}) {
    return _dio.put(path, data: data);
  }

  Future<Response> delete(String path, {dynamic data}) {
    return _dio.delete(path, data: data);
  }
}