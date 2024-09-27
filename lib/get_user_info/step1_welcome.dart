// 작성자 : 황제하
// signup_pages(회원가입)와 연결되는 페이지
// 회원가입 절차 이후 사용자 정보를 받는 페이지

import 'package:flutter/material.dart';
import 'package:halmoney/FirestoreData/user_Info.dart';
import 'package:halmoney/get_user_info/step2_user_career.dart';

class StepWelcome extends StatefulWidget {
  final String id;

  const StepWelcome({super.key, required this.id});

  @override
  State<StepWelcome> createState() => _StepWelcomeState();
}

class _StepWelcomeState extends State<StepWelcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 앱바 디자인 영역
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1.0,
        title: Row(
          children: [
            Image.asset(
              'assets/images/img_logo.png',
              fit: BoxFit.contain,
              height: 40,
            ),
            Container(
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  '할MONEY',
                  style: TextStyle(
                    fontFamily: 'NanumGothicFamily',
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0,
                    color: Colors.black,
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
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                //경력 입력 페이지로 이동
                GestureDetector(
                  onTap: () async {
                    UserInfo userInfo = await UserInfo.create(widget.id);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StepUserCareer(
                            userInfo: userInfo,
                          ),
                        ));
                  },
                  child: const Row(
                    children: [
                      Text('시작하기',
                          style: TextStyle(
                            fontFamily: 'NanumGothicFamily',
                            fontSize: 25.0,
                            color: Colors.black,
                          )),
                      Icon(
                        Icons.keyboard_double_arrow_right,
                        size: 40,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                    '회원 가입을 축하드립니다.',
                    //추후 문구 수정 필요
                    //애니메이션 효과 추가
                    style: TextStyle(
                      fontFamily: 'NanumGothicFamily',
                      fontWeight: FontWeight.w500,
                      fontSize: 28.0,
                      color: Colors.black,
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
