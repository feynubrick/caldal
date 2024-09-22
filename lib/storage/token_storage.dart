import 'package:calendar_scheduler/const/types.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static final TokenStorage _instance = TokenStorage._internal();
  factory TokenStorage() => _instance;
  TokenStorage._internal();

  final storage = const FlutterSecureStorage();

  final Map<TokenType, String> _tokenKeyMap = {
    TokenType.accessToken: 'access_token',
    TokenType.refreshToken: 'refresh_token',
  };

  String _getKey(TokenType type) => _tokenKeyMap[type]!;

  Future<void> saveToken(TokenType type, String token) async {
    await storage.write(key: _getKey(type), value: token);
  }

  Future<String?> getToken(TokenType type) async {
    final token = await storage.read(key: _getKey(type));
    return token;
  }

  Future<void> deleteToken(TokenType type) async {
    await storage.delete(key: _getKey(type));
  }

  Future<void> deleteAllTokens() async {
    await storage.deleteAll();
  }
}
