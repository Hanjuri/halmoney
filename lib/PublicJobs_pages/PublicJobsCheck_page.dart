import 'package:flutter/material.dart';
import 'PublicJobsCheckQuestion.dart';
import 'PublicJobsDescribe.main.dart';
import 'PublicJobsApplyStep_page.dart';
import 'package:halmoney/FirestoreData/user_Info.dart';

class PublicJobsCheckPage extends StatefulWidget {
  final String id;
  final String title;
  final String region;
  final String career;
  final String requirementsText;
  final String applystep;
  final UserInfo userInfo;

  PublicJobsCheckPage({
    required this.id,
    required this.title,
    required this.region,
    required this.career,
    required this.requirementsText,
    required this.applystep,
    required this.userInfo,
    Key? key,
  }) : super(key: key);

  @override
  _PublicJobsCheckPageState createState() => _PublicJobsCheckPageState();
}

class _PublicJobsCheckPageState extends State<PublicJobsCheckPage> {
  late Future<List<String>> _questionsFuture;
  int _currentStep = 0;
  List<bool> _isChecked = [];

  @override
  void initState() {
    super.initState();
    // 질문 목록 생성
    _questionsFuture = QuestionGeneratorService().generateQuestionsFromText(
      title: widget.title,
      hireregion: widget.region,
      applypersoncareer: widget.career,
      text: widget.requirementsText,
    );

    // 체크박스 상태 초기화
    _questionsFuture.then((questions) {
      setState(() {
        _isChecked = List<bool>.filled(questions.length, false);
      });
    });
  }

  void _onStepContinue(List<String> questions) {
    setState(() {
      if (_currentStep < questions.length - 1) {
        _currentStep++;
      } else {
        // 모든 질문이 완료되면 다음 페이지로 이동
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PublicJobsApplyPage(id: widget.id, applystep: widget.applystep, userInfo: widget.userInfo,)),
        );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(250, 51, 51, 255),
        title: const Text('자격요건 확인하기'),
      ),
      body: FutureBuilder<List<String>>(
        future: _questionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('에러 발생: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('질문이 없습니다.'));
          } else {
            final questions = snapshot.data!;
            return Stepper(
              currentStep: _currentStep,
              onStepContinue: () => _onStepContinue(questions),
              onStepCancel: _onStepCancel,
              steps: List.generate(questions.length, (index) {
                return Step(
                  title: Text('질문 ${index + 1}'),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        questions[index],
                        style: TextStyle(fontSize: 16),
                      )
                    ],
                  ),
                  isActive: _currentStep >= index,
                  state: _isChecked.length > index && _isChecked[index]
                      ? StepState.complete
                      : StepState.indexed,
                );
              }),
            );
          }
        },
      ),
    );
  }
}