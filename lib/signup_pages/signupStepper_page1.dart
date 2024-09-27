import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'signupStepper_page2.dart';

class SignupStepperOne extends StatefulWidget {
  const SignupStepperOne({super.key});

  @override
  _SignupStepperOneState createState() => _SignupStepperOneState();
}

class _SignupStepperOneState extends State<SignupStepperOne> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  // Input 데이터 관리
  String _name = '';
  String _id = '';
  String _password = '';
  String _confirmPassword = '';
  String _phoneNumber = '';
  String? _errorMessage;

  // Stepper가 이동할 때 호출되는 함수
  void _continue() async {
    setState(() {
      _errorMessage = null;
    });

    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();

    if (_currentStep < 4) {
      setState(() {
        _currentStep++;
      });
      print('현재 단계: $_currentStep');
    } else {
      // 비밀번호가 일치하는지 다시 한 번 확인
      if (_password != _confirmPassword) {
        setState(() {
          _errorMessage = '비밀번호가 일치하지 않습니다.';
        });
        return;
      }

      // 비밀번호 해쉬화
      final bytes = utf8.encode(_password);
      final hashedPassword = sha256.convert(bytes).toString();

      try {
        // Firestore에서 ID 중복 체크
        final QuerySnapshot result = await FirebaseFirestore.instance
            .collection('user')
            .where('id', isEqualTo: _id)
            .get();

        final List<DocumentSnapshot> documents = result.docs;

        if (documents.isNotEmpty) {
          setState(() {
            _errorMessage = '중복된 ID입니다.';
          });
        } else {
          // Firestore에 회원정보 저장
          await FirebaseFirestore.instance.collection('user').add({
            'name': _name,
            'id': _id,
            'password': hashedPassword,
            'phone': _phoneNumber,
          });

          // 회원가입 완료 알림
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('회원가입 완료'),
                content: Text(
                  '회원가입이 성공적으로 완료되었습니다!',
                  style: TextStyle(fontSize: 15),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text('확인'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignupPgTwoStepper(id: _id)),
                      );
                    },
                  ),
                ],
              );
            },
          );
        }
      } catch (e) {
        setState(() {
          _errorMessage = '오류가 발생했습니다: $e';
        });
      }
    }
  }

  void _cancel() {
    setState(() {
      if (_currentStep > 0) {
        _currentStep--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(250, 51, 51, 255),
        title: Row(
          children: [
            Image.asset(
              'assets/images/img_logo.png',
              height: 40,
            ),
            const SizedBox(width: 8),
            const Text(
              '회원가입',
              style: TextStyle(fontFamily: 'NanumGothicFamily', fontWeight: FontWeight.w600, fontSize: 18.0, color: Colors.white),
            ),
          ],
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: Theme(
                data: ThemeData(
                  primarySwatch: Colors.grey, // 기본 색상
                  colorScheme: ColorScheme.light(
                    primary: Color.fromARGB(250, 51, 51, 255),// active한 Step 동그라미 색상 변경
                  ),
                ),
                child: Stepper(
                  type: StepperType.vertical,
                  currentStep: _currentStep,
                  onStepContinue: _continue,
                  onStepCancel: _cancel,
                  controlsBuilder:
                      (BuildContext context, ControlsDetails details) {
                        return Row(
                          children: [
                            SizedBox(height: 20),
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed: details.onStepContinue,
                                  child: Text('다음'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey,
                                    foregroundColor: Colors.white,// 기본 색상
                                    textStyle: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ).copyWith(
                                    // 버튼이 눌린 상태일 때의 색상을 파란색으로 변경
                                    backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                                          (Set<MaterialState> states) {
                                        if (states.contains(MaterialState.pressed)) {
                                          return Color.fromARGB(250, 100, 100, 255); // 눌렸을 때 색상
                                        }
                                        return Colors.grey; // 기본 색상
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                ElevatedButton(
                                  onPressed: details.onStepCancel,
                                  child: Text('이전'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey,
                                    foregroundColor: Colors.white,
                                    textStyle: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),


                          ],
                        );
                  },
                  steps: [
                    Step(
                      title: Text("성명",
                      style:TextStyle(fontSize:20,)),
                      content: TextFormField(
                        decoration:
                        InputDecoration(labelText: '성명을 입력하세요'),
                        validator: (value) {
                          if (_currentStep == 0) {
                            if (value == null || value.trim().isEmpty) {
                              return '성명을 입력해주세요';
                            }
                          }
                          return null;
                        },
                        onSaved: (value) => _name = value!,
                      ),
                      isActive: _currentStep == 0, // active 상태를 명확히 표시
                    ),
                    Step(
                      title: Text("아이디",
                          style:TextStyle(fontSize:20,)),
                      content: TextFormField(
                        decoration: InputDecoration(
                            labelText: '아이디를 입력하세요'),
                        validator: (value) {
                          if (_currentStep == 1) {
                            if (value == null || value.trim().isEmpty) {
                              return '아이디를 입력해주세요';
                            }
                          }
                          return null;
                        },
                        onSaved: (value) => _id = value!,
                      ),
                      isActive: _currentStep == 1, // active 상태
                    ),
                    Step(
                      title: Text("비밀번호",
                          style:TextStyle(fontSize:20,)),
                      content: TextFormField(
                        decoration:
                        InputDecoration(labelText: '비밀번호를 입력하세요'),
                        obscureText: true,
                        validator: (value) {
                          if (_currentStep == 2) {
                            if (value == null || value.trim().isEmpty) {
                              return '비밀번호를 입력해주세요';
                            }
                            if (value.length < 6) {
                              return '비밀번호는 6자 이상이어야 합니다';
                            }
                          }
                          return null;
                        },
                        onSaved: (value) => _password = value!,
                      ),
                      isActive: _currentStep == 2, // active 상태
                    ),
                    Step(
                      title: Text("비밀번호 확인",
                          style:TextStyle(fontSize:20,)),
                      content: TextFormField(
                        decoration: InputDecoration(
                            labelText: '비밀번호를 다시 입력하세요'),
                        obscureText: true,
                        validator: (value) {
                          if (_currentStep == 3) {
                            if (value == null || value.isEmpty) {
                              return '비밀번호 확인을 입력해주세요';
                            }
                            if (value != _password) {
                              return '비밀번호가 일치하지 않습니다';
                            }
                          }
                          return null;
                        },
                        onSaved: (value) => _confirmPassword = value!,
                      ),
                      isActive: _currentStep == 3, // active 상태
                    ),
                    Step(
                      title: Text("전화번호",
                          style:TextStyle(fontSize:20,)),
                      content: TextFormField(
                        decoration: InputDecoration(labelText: '전화번호를 입력하세요'),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (_currentStep == 4) {
                            if (value == null || value.trim().isEmpty) {
                              return '전화번호를 입력해주세요!';
                            }
                          }
                          return null;
                        },
                        onSaved: (value) => _phoneNumber = value!,
                      ),
                      isActive: _currentStep == 4, // active 상태
                    ),
                  ],
                ),
              ),
            ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}