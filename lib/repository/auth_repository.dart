import 'package:calendar_scheduler/util/url.dart';
import 'package:dio/dio.dart';

import '../const/types.dart';
import '../storage/token_storage.dart';

class AuthRepository {
  final _dio = Dio();
  final TokenStorage tokenStorage;
  final _targetUrl = 'http://${getLocalHostName()}:8000/api/v1/account';

  AuthRepository({required this.tokenStorage});

  Future<void> register({
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
    await tokenStorage.saveToken(TokenType.refreshToken, refreshToken);
    await tokenStorage.saveToken(TokenType.accessToken, accessToken);
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    final result = await _dio.post(
      '$_targetUrl/auth/token/pair',
      data: {
        'email': email,
        'password': password,
      },
    );

    final refreshToken = result.data['refresh'] as String;
    final accessToken = result.data['access'] as String;
    await tokenStorage.saveToken(TokenType.refreshToken, refreshToken);
    await tokenStorage.saveToken(TokenType.accessToken, accessToken);
  }

  Future<void> rotateAccessToken({
    required String refreshToken,
  }) async {
    final result = await _dio.post('$_targetUrl/auth/token/refresh',
        options: Options(
          headers: {
            'authorization': 'Bearer $refreshToken',
          },
        ));
    final newAccessToken = result.data['access'] as String;
    await tokenStorage.saveToken(TokenType.accessToken, newAccessToken);
  }

  Future<String?> getAccessToken() => tokenStorage.getToken(TokenType.accessToken);
  Future<String?> getRefreshToken() => tokenStorage.getToken(TokenType.refreshToken);
  Future<void> clearTokens() => tokenStorage.deleteAllTokens();
}
