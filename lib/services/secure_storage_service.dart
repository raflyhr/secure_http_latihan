import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// ==================== LATIHAN 1: SIMPAN TOKEN SECURE STORAGE - MULAI ====================
class SecureStorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );
  static const _tokenKey = 'auth_token';

  Future<void> saveToken(String value) =>
      _storage.write(key: _tokenKey, value: value);
  Future<String?> getToken() => _storage.read(key: _tokenKey);
  Future<void> deleteToken() => _storage.delete(key: _tokenKey);
}
// ===================== LATIHAN 1: SIMPAN TOKEN SECURE STORAGE - SELESAI =====================
