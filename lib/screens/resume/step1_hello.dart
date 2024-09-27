import 'package:flutter/material.dart';
import 'package:halmoney/screens/resume/step2_field.dart';
import 'package:halmoney/FirestoreData/user_Info.dart';
import 'package:halmoney/screens/resume/user_prompt_factor.dart';

class StepHelloPage extends StatefulWidget {
  final UserInfo userInfo;

  const StepHelloPage({super.key, required this.userInfo});

  @override
  State<StepHelloPage> createState() => _StepHelloPageState();
}

class _StepHelloPageState extends State<StepHelloPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 앱바 디자인 영역
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(250, 51, 51, 255),
        elevation: 1.0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  'AI 자기소개서 작성           ',
                  style: TextStyle(
                    fontFamily: 'NanumGothicFamily',
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0,
                    color: Colors.white,
                  ),
                )),
          ],
        ),
      ),

      // 내부 영역
      body: Padding(
        padding: const EdgeInsets.only(
            left: 25.0, right: 30.0, top: 30.0, bottom: 50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                    '안녕하세요\n\n자기소개서 작성을 위해\n몇 가지 질문을 드릴게요\n\n준비되셨다면\n시작하기 버튼을 눌러주세요',
                    style: TextStyle(
                      fontFamily: 'NanumGothicFamily',
                      fontWeight: FontWeight.w500,
                      fontSize: 28.0,
                      color: Colors.black,
                    )),
              ],
            ),
            GestureDetector(
              onTap: () async {
                //프롬프트요소 객체 생성
                UserPromptFactor userPromptFactor = await UserPromptFactor.create(widget.userInfo);
                //step2페이지로 이동
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StepFieldPage(
                        userInfo: widget.userInfo,
                        userPromptFactor: userPromptFactor,
                      ),
                    ));
              },
              child: Container(
                width: 500,
                height: 60,
                decoration: BoxDecoration(
                  color: Color.fromARGB(250, 51, 51, 255),// 배경색
                  borderRadius: BorderRadius.circular(12), // 테두리 둥글게
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26, // 그림자 색상
                      offset: Offset(0, 4), // 그림자 위치
                      blurRadius: 8, // 그림자 흐림 정도
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('시작하기',
                        style: TextStyle(
                          fontFamily: 'NanumGothicFamily',
                          fontSize: 25.0,
                          color: Colors.white,
                        )),
                    Icon(
                      Icons.keyboard_double_arrow_right,
                      size: 40,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
