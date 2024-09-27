import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:halmoney/signup_pages/signupStepper_page2.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class SignupPageOne extends StatefulWidget {
  const SignupPageOne({super.key});

  @override
  _SignupPageOneState createState() => _SignupPageOneState();
}

class _SignupPageOneState extends State<SignupPageOne> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String? _errorMessage;

  // 사용 후 리소스 해제
  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // 아이디 중복, 비번 일치 확인
  Future<void> _validateAndSubmit() async {
    setState(() {
      _errorMessage = null;
    });

    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _errorMessage = '비밀번호가 일치하지 않습니다.';
      });
      return;
    }

    final String name = _nameController.text;
    final String id = _idController.text;
    final String password = _passwordController.text;
    final String phone = _phoneController.text;

    // 디버깅을 위해 입력된 값을 출력합니다.
    print('Name: $name');
    print('ID: $id');
    print('Password: $password');
    print('Phone: $phone');

    // 비밀번호 해쉬화
    final bytes = utf8.encode(password);
    final hashedPassword = sha256.convert(bytes).toString();


    try {
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('user')
          .where('id', isEqualTo: id)
          .get();

      final List<DocumentSnapshot> documents = result.docs;

      if (documents.isNotEmpty) {
        setState(() {
          _errorMessage = '중복된 ID입니다.';
        });
      } else {
        FirebaseFirestore.instance.collection('user').add({
          'name': name,
          'id': id,
          'password': hashedPassword,
          'phone': phone,
        });

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignupPgTwoStepper(id: id)),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = '오류가 발생했습니다: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 80.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 타이틀
            const Text(
              '본인의 정보를 입력해주세요.',
              style: TextStyle(
                fontSize: 23.0,
                fontFamily: 'NanumGothic',
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              '성명',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.black87,
                fontFamily: 'NanumGothic',
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 45,
              child: TextField(
                controller: _nameController,
                style: const TextStyle(fontSize: 15.0, height: 2.0),
                decoration: const InputDecoration(
                  hintText: '이름을 입력하세요',
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              '아이디',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.black87,
                fontFamily: 'NanumGothic',
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 45,
              child: TextField(
                controller: _idController,
                style: const TextStyle(fontSize: 15.0, height: 2.0),
                decoration: const InputDecoration(
                  hintText: '아이디를 입력하세요',
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              '비밀번호',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.black87,
                fontFamily: 'NanumGothic',
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 45,
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                style: const TextStyle(fontSize: 15.0, height: 2.0),
                decoration: const InputDecoration(
                  hintText: '비밀번호를 입력하세요',
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              '비밀번호 확인',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.black87,
                fontFamily: 'NanumGothic',
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 45,
              child: TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                style: const TextStyle(fontSize: 15.0, height: 2.0),
                decoration: const InputDecoration(
                  hintText: '비밀번호를 한 번 더 입력하세요',
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              '전화번호',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.black87,
                fontFamily: 'NanumGothic',
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 45,
              child: TextField(
                keyboardType: TextInputType.number,
                controller: _phoneController,
                style: const TextStyle(fontSize: 15.0, height: 2.0),
                decoration: const InputDecoration(
                  hintText: '전화번호를 입력하세요',
                ),
              ),
            ),
            const SizedBox(height: 10),
            // 비번 불일치 시 에러 메시지
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(250, 51, 51, 255),
                minimumSize: const Size(360, 45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                _validateAndSubmit();
              },
              child: const Text(
                '다음',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
