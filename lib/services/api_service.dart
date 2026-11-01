import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/post.dart';
import '../models/user.dart';

class ApiService {
  static const _baseUrl = 'https://jsonplaceholder.typicode.com';

  Future<List<User>> getUsers({
    Duration timeout = const Duration(seconds: 10),
  }) async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/users'))
          .timeout(timeout);
      if (response.statusCode != 200) {
        throw HttpException('Gagal memuat user: ${response.statusCode}');
      }
      final data = jsonDecode(response.body) as List<dynamic>;
      return data
          .map((item) => User.fromJson(item as Map<String, dynamic>))
          .toList();
    } on TimeoutException {
      throw Exception(
        'Request melebihi batas waktu ${timeout.inSeconds} detik.',
      );
    } on SocketException {
      throw Exception('Tidak ada koneksi internet.');
    } on FormatException {
      throw Exception('Format response tidak valid.');
    }
  }

  // ==================== LATIHAN 3: ENDPOINT /posts - MULAI ====================
  Future<List<Post>> getPosts() async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/posts'))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode != 200) {
        throw HttpException('Gagal memuat post: ${response.statusCode}');
      }
      final data = jsonDecode(response.body) as List<dynamic>;
      return data
          .map((item) => Post.fromJson(item as Map<String, dynamic>))
          .toList();
    } on TimeoutException {
      throw Exception('Request post timeout.');
    } on SocketException {
      throw Exception('Tidak ada koneksi internet.');
    }
  }
  // ===================== LATIHAN 3: ENDPOINT /posts - SELESAI =====================

  // ==================== LATIHAN 1: LOGIN DENGAN TOKEN - API MULAI ====================
  Future<String> login(String email, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (email.trim().isEmpty || password.isEmpty) {
      throw Exception('Email dan password wajib diisi.');
    }
    return 'dummy_token_${DateTime.now().millisecondsSinceEpoch}';
  }
  // ===================== LATIHAN 1: LOGIN DENGAN TOKEN - API SELESAI =====================
}
