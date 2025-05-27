import 'dart:convert'; 
import 'package:flutter/material.dart';


import '../model/news_item.dart'; 
import '../service/api_service.dart'; 
import 'login_screen.dart'; 

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  Future<void> _createAccount() async {
    final name = _fullNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showSnackbar('모든 필드를 입력해주세요.');
      return;
    }

    if (password != confirmPassword) {
      _showSnackbar('비밀번호가 일치하지 않습니다.');
      return;
    }

    final result = await ApiService.registerUser(
      fullName: name,
      email: email,
      password: password,
    );

    if (result['success'] == true) {
      _showSnackbar('계정이 성공적으로 생성되었습니다.');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } else {
      _showSnackbar(result['message'] ?? '회원가입에 실패했습니다.');
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.zero,
          child: Container(
            height: screenHeight,
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(color: Color(0x19000000), blurRadius: 3, offset: Offset(0, 1)),
                BoxShadow(color: Color(0x19000000), blurRadius: 2, offset: Offset(0, 1)),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                const Text(
                  '회원가입',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '아이디를 만들고 시작하세요!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF868E96),
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),

                _buildInputField(_fullNameController, '이름'),
                const SizedBox(height: 16),
                _buildInputField(_emailController, '아이디'),
                const SizedBox(height: 16),
                _buildInputField(_passwordController, '비밀번호', obscureText: true),
                const SizedBox(height: 16),
                _buildInputField(_confirmPasswordController, '비밀번호 재입력', obscureText: true),
                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: _createAccount,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: const Color(0xFF228BE6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    '계정 생성',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '이미 아이디가 있으신가요?',
                      style: TextStyle(color: Color(0xFF868E96), fontSize: 14),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                        );
                      },
                      style: TextButton.styleFrom(foregroundColor: const Color(0xFF228BE6)),
                      child: const Text(
                        '로그인',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(TextEditingController controller, String label, {bool obscureText = false}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: const Color(0xFFE9ECEF)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: TextField(
          controller: controller,
          obscureText: obscureText,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            labelText: label,
            border: InputBorder.none,
            labelStyle: const TextStyle(color: Color(0xFF999999)),
          ),
        ),
      ),
    );
  }
}
