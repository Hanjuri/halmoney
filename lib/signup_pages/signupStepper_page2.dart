import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'signupStepper_page2.dart';
import 'package:halmoney/get_user_info/step1_welcome.dart';

class SignupPgTwoStepper extends StatefulWidget {
  final String id; // 전달받은 id를 저장할 변수

  const SignupPgTwoStepper({super.key, required this.id});

  @override
  _SignupPgTwoStepperState createState() => _SignupPgTwoStepperState();
}

class _SignupPgTwoStepperState extends State<SignupPgTwoStepper> {
  int _currentStep = 0;
  final TextEditingController genderController = TextEditingController();
  final TextEditingController ageGroupController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  String _errorMessage = '';

  // Stepper가 이동할 때 호출되는 함수
  void _continue() {
    setState(() {
      _errorMessage = '';
    });

    if (_currentStep == 0 && genderController.text.isEmpty) {
      setState(() {
        _errorMessage = '성별을 선택해주세요.';
      });
      return;
    }

    if (_currentStep == 1 && ageGroupController.text.isEmpty) {
      setState(() {
        _errorMessage = '연령대를 선택해주세요.';
      });
      return;
    }

    if (_currentStep == 2 && addressController.text.isEmpty) {
      setState(() {
        _errorMessage = '주소를 선택해주세요.';
      });
      return;
    }

    setState(() {
      if (_currentStep < 2) {
        _currentStep++;
      } else {
        _saveData(context);
      }
    });
  }

  void _cancel() {
    setState(() {
      if (_currentStep > 0) {
        _currentStep--;
      }
    });
  }

  void _saveData(BuildContext context) async {
    final gender = genderController.text;
    final ageGroup = ageGroupController.text;
    final address = addressController.text;

    try {
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('user')
          .where('id', isEqualTo: widget.id)
          .get();

      final List<DocumentSnapshot> documents = result.docs;

      if (documents.isNotEmpty) {
        final String docId = documents.first.id;

        await FirebaseFirestore.instance.collection('user').doc(docId).update({
          'gender': gender,
          'ageGroup': ageGroup,
          'address': address,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User updated successfully")),
        );

        // 완료 후 다음 화면으로 이동
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => StepWelcome(id: widget.id)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User not found")),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update user: $error")),
      );
    }
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
              '회원정보',
              style: TextStyle(fontFamily: 'NanumGothicFamily', fontWeight: FontWeight.w600, fontSize: 18.0, color: Colors.white),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Theme(
            data:ThemeData(
              primaryColor: Colors.grey,
              colorScheme: ColorScheme.light(
                primary: Color.fromARGB(250, 51, 51, 255)
              )
      ),
            child: Stepper(
              type: StepperType.vertical,
              currentStep: _currentStep,
              onStepContinue: _continue,
              onStepCancel: _cancel,
              controlsBuilder: (BuildContext context, ControlsDetails details) {
                return Row(
                  children: [
                    ElevatedButton(
                      onPressed: details.onStepContinue,
                      child: Text('다음'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey, // 버튼 색상
                        foregroundColor: Colors.white,
                        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: details.onStepCancel,
                      child: Text('이전'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,  // 버튼 색상
                        foregroundColor: Colors.white,
                        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                      ),
                    ),
                  ],
                );
              },
              steps: _buildSteps(),
            ),
          ),
          if (_errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            ),
        ],
      ),
    );
  }

  List<Step> _buildSteps() {
    return [
      Step(
        title: const Text('성별', style:TextStyle(fontSize:20,)),
        content: MyButtonList(
          buttons: [
            ButtonData(
              text: '여성',
              onPressed: () {
                genderController.text = '여성';
              },
            ),
            ButtonData(
              text: '남성',
              onPressed: () {
                genderController.text = '남성';
              },
            ),
          ],
        ),
        isActive: _currentStep == 0,
      ),
      Step(
        title: const Text('연령대', style:TextStyle(fontSize:20,)),
        content: MyButtonList(
          buttons: [
            ButtonData(
              text: '40대',
              onPressed: () {
                ageGroupController.text = '40대';
              },
            ),
            ButtonData(
              text: '50대',
              onPressed: () {
                ageGroupController.text = '50대';
              },
            ),
            ButtonData(
              text: '60대',
              onPressed: () {
                ageGroupController.text = '60대';
              },
            ),
            ButtonData(
              text: '70대',
              onPressed: () {
                ageGroupController.text = '70대';
              },
            ),
          ],
        ),
        isActive: _currentStep == 1,
      ),
      Step(
        title: const Text('주소', style:TextStyle(fontSize:20,)),
        content: DropdownButtonExample(addressController: addressController),
        isActive: _currentStep == 2,
      ),
    ];
  }
}

// 성별 버튼 색깔 변경 처리
class MyButtonList extends StatefulWidget {
  const MyButtonList({super.key, required this.buttons});

  final List<ButtonData> buttons;

  @override
  State<MyButtonList> createState() => _MyButtonListState();
}

class _MyButtonListState extends State<MyButtonList> {
  late List<bool> favoriateState;

  @override
  void initState() {
    favoriateState = List.generate(
        widget.buttons.length, (index) => widget.buttons[index].isFavorite);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView( // 스크롤 가능하게 수정
      scrollDirection: Axis.horizontal, // 가로로 스크롤 설정
      child: Row(
        children: [
          for (var i = 0; i < widget.buttons.length; i++) ...[
            MyWidget(
              text: widget.buttons[i].text,
              onPressed: () {
                for (var j = 0; j < favoriateState.length; j++) {
                  favoriateState[j] = false;
                }
                setState(() {
                  favoriateState[i] = true;
                  if (widget.buttons[i].onPressed != null) {
                    widget.buttons[i].onPressed!();
                  }
                });
              },
              isFavourte: favoriateState[i],
            ),
            if (i != widget.buttons.length - 1) SizedBox(width: 10), // 버튼 사이 간격 조절
          ]
        ],
      ),
    );
  }
}

class ButtonData {
  final String text;
  final Function()? onPressed;
  final bool isFavorite;

  ButtonData({required this.text, this.onPressed, this.isFavorite = false});
}

class MyWidget extends StatelessWidget {
  const MyWidget(
      {super.key,
        required this.text,
        required this.onPressed,
        this.isFavourte = false});

  final String text;
  final Function()? onPressed;
  final bool isFavourte;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: isFavourte
                ? const Color.fromARGB(250, 51, 51, 255)
                : Colors.grey,
            foregroundColor: Colors.white, // 텍스트 색상
            minimumSize: const Size(60, 45),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12))),
        onPressed: onPressed,
        child: Text(text, style: const TextStyle(fontSize: 18)));
  }
}

// 주소 선택 dropdown
class DropdownButtonExample extends StatefulWidget {
  const DropdownButtonExample({super.key, required this.addressController});

  final TextEditingController addressController;

  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  List<String> cities = ['-시/도-', '서울특별시', '경기도'];
  List<List<String>> gugun = [
  ['-시/군/구-'],
  [
  '-시/군/구-',
    '강남구',
    '강동구',
    '강북구',
    '강서구',
    '관악구',
    '광진구',
    '구로구',
    '금천구',
    '노원구',
    '도봉구',
    '동대문구',
    '동작구',
    '마포구',
    '서대문구',
    '서초구',
    '성동구',
    '성북구',
    '송파구',
    '양천구',
    '영등포구',
    '용산구',
    '은평구',
    '종로구',
    '중구',
    '중랑구'
  ],
    [
      '-시/군/구-',
      '가평군',
      '고양시',
      '과천시',
      '광명시',
      '광주시',
      '구리시',
      '군포시',
      '김포시',
      '남양주시',
      '동두천시',
      '부천시',
      '성남시',
      '수원시',
      '시흥시',
      '안산시',
      '안성시',
      '안양시',
      '양주시',
      '여주시',
      '오산시',
      '용인시',
      '의왕시',
      '의정부시',
      '이천시',
      '파주시',
      '평택시',
      '포천시',
      '하남시',
      '화성시'
    ]
  ];

  String selectedSido = '-시/도-';
  String selectedGugun = '-시/군/구-';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Container(
            width: 180,
            height: 90,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: DropdownButton<String>(
              itemHeight: 80,
              isExpanded: true,
              value: selectedSido.isNotEmpty ? selectedSido : null,
              onChanged: (value) {
                setState(() {
                  selectedSido = value!;
                  selectedGugun = gugun[0][0];
                  widget.addressController.text = '$selectedSido, $selectedGugun';
                });
              },
              items: cities.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          // 시구군
          Container(
            width: 180,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            height: 90,
            child: DropdownButton<String>(
              itemHeight: 80,
              isExpanded: true,
              value: selectedGugun.isNotEmpty ? selectedGugun : null,
              onChanged: (value) {
                setState(() {
                  selectedGugun = value!;
                  widget.addressController.text = '$selectedSido, $selectedGugun';
                });
              },
              items: selectedSido.isEmpty
                  ? []
                  : gugun[cities.indexOf(selectedSido)].map((String g) {
                return DropdownMenuItem<String>(
                  value: g,
                  child: Text(g),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}