import 'package:flutter/material.dart';

import '../services/secure_storage_service.dart';
import 'login_screen.dart';
import 'post_list_screen.dart';
import 'user_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _storage = SecureStorageService();
  final _tokenController = TextEditingController();
  String? _savedToken;
  bool _hasToken = false;

  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  @override
  void dispose() {
    _tokenController.dispose();
    super.dispose();
  }

  Future<void> _checkToken() async {
    final token = await _storage.getToken();
    if (!mounted) return;
    setState(() {
      _savedToken = token;
      _hasToken = token != null;
    });
  }

  Future<void> _saveToken() async {
    final token = _tokenController.text.trim();
    if (token.isEmpty) {
      _showMessage('Token tidak boleh kosong');
      return;
    }
    await _storage.saveToken(token);
    _tokenController.clear();
    await _checkToken();
    if (mounted) _showMessage('Token berhasil disimpan di secure storage');
  }

  Future<void> _deleteToken() async {
    await _storage.deleteToken();
    await _checkToken();
    if (mounted) _showMessage('Token berhasil dihapus');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout?'),
        content: const Text('Token akan dihapus dari secure storage.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await _storage.deleteToken();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Secure Storage & HTTP'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildStorageCard(),
            const SizedBox(height: 16),
            _buildHttpCard(),
            const SizedBox(height: 16),
            _buildPracticeCard(),
            const SizedBox(height: 16),
            _buildSecurityNote(),
          ],
        ),
      ),
    );
  }

  Widget _buildStorageCard() {
    final tokenPreview = _savedToken == null
        ? ''
        : '${_savedToken!.substring(0, _savedToken!.length.clamp(0, 10))}...';
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.lock, color: Colors.deepPurple),
                SizedBox(width: 8),
                Text(
                  'Secure Storage',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text('Simpan token atau PIN di secure storage terenkripsi.'),
            const SizedBox(height: 16),
            TextField(
              controller: _tokenController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Token',
                hintText: 'Masukkan token dummy',
                prefixIcon: Icon(Icons.vpn_key),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _saveToken,
                    icon: const Icon(Icons.save),
                    label: const Text('Simpan'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _hasToken ? _deleteToken : null,
                    icon: const Icon(Icons.delete),
                    label: const Text('Hapus'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              _hasToken
                  ? 'Token tersimpan: $tokenPreview'
                  : 'Belum ada token tersimpan',
              style: TextStyle(
                color: _hasToken ? Colors.green[800] : Colors.red[800],
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHttpCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Row(
              children: [
                Icon(Icons.cloud, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  'HTTP Request',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Ambil data dari REST API JSONPlaceholder menggunakan GET.',
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const UserListScreen()),
              ),
              icon: const Icon(Icons.list),
              label: const Text('Lihat Daftar Pengguna'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPracticeCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Fitur Latihan 1-5',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Login dan logout menggunakan token tersedia pada aplikasi.',
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PostListScreen()),
              ),
              icon: const Icon(Icons.article),
              label: const Text('Latihan 3: Lihat Daftar Posts'),
            ),
            const SizedBox(height: 8),
            const Text(
              'Latihan 4: pencarian user dan Latihan 5: timeout configurable '
              'tersedia pada halaman Daftar Pengguna.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityNote() {
    return Card(
      color: Colors.amber[50],
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Catatan Keamanan',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '1. Token dan PIN disimpan terenkripsi.\n'
              '2. Jangan mencetak token ke log.\n'
              '3. Gunakan HTTPS untuk komunikasi API.\n'
              '4. Tangani error dengan pesan ramah pengguna.',
            ),
          ],
        ),
      ),
    );
  }
}
