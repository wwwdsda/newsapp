import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'dart:convert';
import 'screens/login_screen.dart';
import 'service/api_service.dart';

void _allNewsSave() async {
  await ApiService.saveNews('/korea_news_save');
  await ApiService.saveNews('/world_news_save');
  await ApiService.saveNews('/economy_news_save');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ko_KR', null);
  runApp(const MyApp());
  _allNewsSave();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF8F9FA), 
        primarySwatch: Colors.blue,
      ),
      home: const LoginScreen(),
    );
  }
}

