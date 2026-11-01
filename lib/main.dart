import 'package:flutter/material.dart';

import 'screens/login_screen.dart';

void main() {
  runApp(const SecureHttpLatihanApp());
}

class SecureHttpLatihanApp extends StatelessWidget {
  const SecureHttpLatihanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Secure HTTP Latihan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
