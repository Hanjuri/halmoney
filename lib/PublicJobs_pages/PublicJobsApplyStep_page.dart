import 'package:flutter/material.dart';
import 'PublicJobsDescribe.main.dart';
import 'package:halmoney/screens/resume/step1_hello.dart';
import 'package:halmoney/FirestoreData/user_Info.dart';

class PublicJobsApplyPage extends StatefulWidget {
  final String id;
  final String applystep;
  final UserInfo userInfo;

  PublicJobsApplyPage({
    required this.id,
    required this.applystep,
    required this.userInfo,

    Key? key,
  }) : super(key: key);

  @override
  _PublicJobsApplyPageState createState() => _PublicJobsApplyPageState();
}

class _PublicJobsApplyPageState extends State<PublicJobsApplyPage> {
  int _currentStep = 0;
  List<String> _steps = [];

  @override
  void initState() {
    super.initState();
    // applystep을 쉼표로 나누어 각각의 절차를 리스트로 변환
    _steps = widget.applystep.split(',').map((step) => step.trim()).toList();
  }

  void _onStepContinue() {
    setState(() {
      if (_currentStep < _steps.length - 1) {
        _currentStep++;
      } else {
        // 모든 스텝이 완료되면 팝업을 띄움
        _showCompletionDialog();
      }
    });
  }

  void _onStepCancel() {
    setState(() {
      if (_currentStep > 0) {
        _currentStep--;
      }
    });
  }

  // 팝업 다이얼로그를 보여주는 함수
  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('모든 절차 확인완료!'),
          content: const Text('다시 공공 일자리 리스트로 돌아갈까요? 지원서를 작성할까요?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PublicJobsDescribe(id: widget.id, userInfo: widget.userInfo,)),
                );// 팝업 닫기
              },
              child: const Text('리스트로 돌아가기'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 팝업 닫기
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StepHelloPage(userInfo: widget.userInfo,)),
                );
              },
              child: const Text('이력서 작성하기'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(250, 51, 51, 255),
        title: const Text('자격요견 확인하기',
        ),
      ),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: _onStepContinue,
        onStepCancel: _onStepCancel,
        steps: List.generate(_steps.length, (index) {
          return Step(
            title: Text('절차 ${index + 1}'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _steps[index],
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                const Text(
                  '준비되셨나요...?',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            isActive: _currentStep >= index,
            state: _currentStep > index ? StepState.complete : StepState.indexed,
          );
        }),
      ),
    );
  }
}