import 'dart:convert';

import 'package:calendar_scheduler/util/url.dart';
import 'package:dio/dio.dart';

class AuthRepository {
  final _dio = Dio();

  final _targetUrl = 'http://${getLocalHostName()}:8000/api/v1/account/auth';

  Future<({String refreshToken, String accessToken})> register({
    required String email,
    required String password,
  }) async {
    final result = await _dio.post(
      '$_targetUrl/sign-up',
      data: {
        'email': email,
        'password': password,
      },
    );
    final refreshToken = result.data['refresh'] as String;
    final accessToken = result.data['access'] as String;
    return (refreshToken: refreshToken, accessToken: accessToken);
  }

  Future<({String refreshToken, String accessToken})> login({
    required String email,
    required String password,
  }) async {
    final result = await _dio.post(
      '$_targetUrl/token/pair',
      data: {
        'email': email,
        'password': password,
      },
    );

    final refreshToken = result.data['refresh'] as String;
    final accessToken = result.data['access'] as String;
    return (refreshToken: refreshToken, accessToken: accessToken);
  }

  Future<String> rotateAccessToken({
    required String refreshToken,
  }) async {
    final result = await _dio.post('$_targetUrl/token/refresh',
        options: Options(
          headers: {
            'authorization': 'Bearer $refreshToken',
          },
        ));

    return result.data['access'] as String;
  }
}
