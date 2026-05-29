import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginService extends ChangeNotifier {
  static final LoginService _instance = LoginService._internal();
  factory LoginService() => _instance;
  LoginService._internal();

  final String _baseUrl = 'https://fakestoreapi.com/auth/login';
  final _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  String? _token;
  bool get isLoggedIn => _token != null;

  /// Verifica se há um token salvo e atualiza o estado
  Future<void> checkAuthStatus() async {
    final token = await _storage.read(key: 'auth_token');
    if (_token != token) {
      _token = token;
      notifyListeners();
    }
  }

  Future<bool> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode < 300) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        _token = data['token'];
        await _storage.write(key: 'auth_token', value: _token);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<String?> getToken() async {
    _token ??= await _storage.read(key: 'auth_token');
    return _token;
  }

  Future<void> logout() async {
    _token = null;
    await _storage.delete(key: 'auth_token');
    notifyListeners();
  }
}
