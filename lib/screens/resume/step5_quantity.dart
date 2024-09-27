import 'package:flutter/material.dart';
import 'package:halmoney/FirestoreData/user_Info.dart';
import 'package:halmoney/screens/resume/step7_resumeCreate.dart';
import 'package:halmoney/screens/resume/user_prompt_factor.dart';

class StepQuantityPage extends StatefulWidget {
  final UserInfo userInfo;
  final UserPromptFactor userPromptFactor;

  const StepQuantityPage({
    super.key,
    required this.userInfo,
    required this.userPromptFactor,
  });

  @override
  State<StepQuantityPage> createState() => _StepQuantityPageState();
}

class _StepQuantityPageState extends State<StepQuantityPage> {
  int quantity = 300;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(250, 51, 51, 255),
        elevation: 1.0,
        leading: null,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Row(
                children: [
                  //SizedBox(width: 5),
                  Icon(
                    Icons.chevron_left,
                    size: 30,
                  ),
                  Text('이전',
                      style: TextStyle(
                        fontFamily: 'NanumGothicFamily',
                        fontSize: 20.0,
                        color: Colors.white,
                      )),
                ],
              ),
            ),
            Container(
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  '4 / 5',
                  style: TextStyle(
                    fontFamily: 'NanumGothicFamily',
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0,
                    color: Colors.white,
                  ),
                )),
            GestureDetector(
              onTap: () {
                widget.userPromptFactor.editQuantity(quantity);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => StepResumeCreate(
                        userInfo : widget.userInfo,
                        userPromptFactor : widget.userPromptFactor,
                      )),
                );
              },
              child: const Row(
                children: [
                  Text('다음',
                      style: TextStyle(
                        fontFamily: 'NanumGothicFamily',
                        fontSize: 20.0,
                        color: Colors.white,
                      )),
                  Icon(
                    Icons.chevron_right,
                    size: 30,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body:Padding(
        padding: const EdgeInsets.only(
            left: 25.0, right: 25.0, top: 25.0, bottom: 15.0),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),

            Expanded(
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('자기소개서\n글자 수를 선택해주세요',
                          style: TextStyle(
                            fontFamily: 'NanumGothicFamily',
                            fontWeight: FontWeight.w500,
                            fontSize: 28.0,
                            color: Colors.black,
                          )),
                    ],
                  ),
                  const SizedBox(height: 60),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          minimumSize: const Size(200, 80),
                          backgroundColor: quantity == 300 ? Color.fromARGB(250, 51, 51, 255) : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            quantity = 300;
                          });
                        },
                        child: const Text(
                          '300자',
                          style: TextStyle(
                            fontFamily: 'NanumGothicFamily',
                            //fontWeight: FontWeight.w500,
                            fontSize: 30.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30,),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          minimumSize: const Size(200, 80),
                          backgroundColor: quantity == 500 ? Color.fromARGB(250, 51, 51, 255) : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            quantity = 500;
                          });
                        },
                        child: const Text(
                          '500자',
                          style: TextStyle(
                            fontFamily: 'NanumGothicFamily',
                            fontWeight: FontWeight.w500,
                            fontSize: 30.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30,),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          minimumSize: const Size(200, 80),
                          backgroundColor: quantity == 750 ? Color.fromARGB(250, 51, 51, 255) : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            quantity = 750;
                          });
                        },
                        child: const Text(
                          '750자',
                          style: TextStyle(
                            fontFamily: 'NanumGothicFamily',
                            fontWeight: FontWeight.w500,
                            fontSize: 30.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}