
import 'package:flutter/material.dart';
import 'package:halmoney/get_user_info/step5_select_place.dart';
import 'package:halmoney/FirestoreData/user_Info.dart';
import 'package:halmoney/myAppPage.dart';

class StepWorkHours extends StatefulWidget{
  final UserInfo userInfo;

  const StepWorkHours({
    super.key,
    required this.userInfo,
  });

  @override
  State<StepWorkHours> createState() => _StepWorkHoursState();
}

class _StepWorkHoursState extends State<StepWorkHours>{

  double _selectedDays = 0; // 슬라이더 값 저장하는 변수

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Padding(
        padding: const EdgeInsets.only(
            left: 25.0, right: 30.0, top: 25.0, bottom: 15.0),
        child: Column(
          children: [
            // 페이지 이동 영역
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 이전 페이지로 이동
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Row(
                    children: [
                      Icon(
                        Icons.chevron_left,
                        size: 30,
                      ),
                      Text('이전',
                          style: TextStyle(
                            fontFamily: 'NanumGothicFamily',
                            fontSize: 20.0,
                            color: Colors.black,
                          )),
                    ],
                  ),
                ),

                // 다음 페이지로 이동
                GestureDetector(
                  onTap: () {
                    widget.userInfo.preferredWorkTime = '${_selectedDays.toInt()}일';
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>SelectPlace(userInfo: widget.userInfo)),
                    );
                  },
                  child: const Row(
                    children: [
                      Text('다음',
                          style: TextStyle(
                            fontFamily: 'NanumGothicFamily',
                            fontSize: 20.0,
                            color: Colors.black,
                          )),
                      Icon(
                        Icons.chevron_right,
                        size: 30,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 20,
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // 질문 텍스트 상자
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('일주일에 얼만큼 일하고 싶으신가요? \n(주7일기준)',
                            style: TextStyle(
                              fontFamily: 'NanumGothicFamily',
                              fontWeight: FontWeight.w500,
                              fontSize: 20.0,
                              color: Colors.black,
                            )),
                      ],
                    ),
                    const SizedBox(height: 50),

                    Text(
                      '${_selectedDays.toInt()}일',
                      style: const TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Slider(
                      value: _selectedDays,
                      min: 0,
                      max: 7,
                      divisions: 7,
                      label: '${_selectedDays.toInt()}일',
                      onChanged: (double value) {
                        setState(() {
                          _selectedDays = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),

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