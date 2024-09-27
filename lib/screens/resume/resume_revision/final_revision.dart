import 'package:flutter/material.dart';
import 'package:halmoney/FirestoreData/user_Info.dart';

import 'package:halmoney/screens/resume/step8_completeResume.dart';
import 'package:halmoney/screens/resume/user_prompt_factor.dart';

class FinalPage extends StatelessWidget {
  final String firstParagraph;
  final String secondParagraph;
  final String thirdParagraph;
  final UserInfo userInfo;
  final UserPromptFactor userPromptFactor;

  const FinalPage({
    super.key,
    required this.firstParagraph,
    required this.secondParagraph,
    required this.thirdParagraph,
    required this.userInfo,
    required this.userPromptFactor,
  });

  /*void _goToResumeView(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResumeView2(
          id: widget.id, // 필요한 다른 정보들
          resumeId: widget.resumeId,
          num: widget.num,
          // 여기서 전달할 문단 추가
          firstParagraph: revisedFirstParagraph,
          secondParagraph: revisedSecondParagraph,
          thirdParagraph: revisedThirdParagraph,
        ),
      ),
    );
  } */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(250, 51, 51, 255),
        title: const Text('최종 생성 자기소개서'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '첫 번째 문단:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(firstParagraph, style: const TextStyle(fontSize: 16)),

              const SizedBox(height: 20),

              const Text(
                '두 번째 문단:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(secondParagraph, style: const TextStyle(fontSize: 16)),

              const SizedBox(height: 20),

              const Text(
                '세 번째 문단:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(thirdParagraph, style: const TextStyle(fontSize: 16)),

              const SizedBox(height: 40),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(250, 51, 51, 255), // 배경색 설정
                  ),
                  onPressed: () {
                    String selfIntroduction = firstParagraph + '\n\n' + secondParagraph + '\n\n' + thirdParagraph;
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    // 이전 화면으로 돌아가기
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StepCompleteResume(
                              userInfo: userInfo,
                              userPromptFactor: userPromptFactor,
                              userSelfIntroduction: selfIntroduction,
                            )));
                  },
                  child: const Text('수정 완료',
                  style:TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}