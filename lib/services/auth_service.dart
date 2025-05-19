import 'package:dio/dio.dart';
import 'package:inkingi/models/generic_response.dart';
import 'package:inkingi/models/login_models.dart';
import 'package:inkingi/models/register_models.dart';

class AuthService {
  final Dio _dio = Dio();
  final String _baseUrl = 'http://54.161.32.33:8090/inkingi-service';

  AuthService() {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
  }

  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await _dio.post(
        '/login',
        data: request.toJson(),
      );
      if (response.statusCode == 200) {
        return LoginResponse.fromJson(response.data);
      } else {
        throw _handleError(response.statusCode);
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw 'Connection timed out. Please check your internet connection.';
      } else if (e.type == DioExceptionType.connectionError) {
        throw 'Network error. Please check your internet connection.';
      } else {
        throw _handleError(e.response?.statusCode);
      }
    } catch (e) {
      throw 'An unexpected error occurred during login. Please try again.';
    }
  }

  Future<void> register(RegisterRequest request) async {
    try {
      final response = await _dio.post(
        '/auth/register',
        data: request.toJson(),
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw _handleError(response.statusCode);
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw 'Connection timed out. Please check your internet connection.';
      } else if (e.type == DioExceptionType.connectionError) {
        throw 'Network error. Please check your internet connection.';
      } else {
        throw _handleError(e.response?.statusCode);
      }
    } catch (e) {
      throw 'An unexpected error occurred during registration. Please try again.';
    }
  }

  Future<GenericResponse> activateUser(
      String userId, String activationCode) async {
    try {
      final response = await _dio.get(
        '/activate-user/$userId/$activationCode',
      );
      if (response.statusCode == 200) {
        return GenericResponse.fromJson(response.data);
      } else {
        throw _handleError(response.statusCode);
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw 'Connection timed out. Please check your internet connection.';
      } else if (e.type == DioExceptionType.connectionError) {
        throw 'Network error. Please check your internet connection.';
      } else {
        throw _handleError(e.response?.statusCode);
      }
    } catch (e) {
      throw 'An unexpected error occurred during account activation. Please try again.';
    }
  }

  String _handleError(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Invalid request. Please check your input and try again.';
      case 401:
        return 'Invalid username or password. Please try again.';
      case 403:
        return 'Access denied. Please contact support.';
      case 409:
        return 'Username or email already exists. Please use a different one.';
      case 500:
        return 'Server error. Please try again later.';
      default:
        return 'An error occurred. Please try again.';
    }
  }
}
