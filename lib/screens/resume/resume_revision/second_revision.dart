import 'package:flutter/material.dart';
import 'package:halmoney/FirestoreData/user_Info.dart';
import 'package:halmoney/screens/resume/user_prompt_factor.dart';
import 'package:halmoney/resume2/introduction_service.dart';
import 'third_revision.dart';

class SecondParagraphPage extends StatefulWidget {
  final String firstParagraph;
  final String secondParagraph;
  final String thirdParagraph;
  final UserInfo userInfo;
  final UserPromptFactor userPromptFactor;

  const SecondParagraphPage({
    Key? key,
    required this.firstParagraph,
    required this.secondParagraph,
    required this.thirdParagraph,
    required this.userInfo,
    required this.userPromptFactor,
  }) : super(key: key);

  @override
  _SecondParagraphPageState createState() => _SecondParagraphPageState();
}

class _SecondParagraphPageState extends State<SecondParagraphPage> {
  final TextEditingController _modificationController = TextEditingController();
  String revisedSecondParagraph = '';
  bool _isLoading = false;
  final IntroductionService _service = IntroductionService();

  @override
  void initState() {
    super.initState();
    revisedSecondParagraph = widget.secondParagraph;
  }

  Future<void> _editSecondParagraph({String tag = ''}) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final revisedText = await _service.generateRevisedIntroduction(
       widget.secondParagraph,
        _modificationController.text + '$tag',
      );
      setState(() {
        revisedSecondParagraph = revisedText;
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _resetToOriginal() {
    setState(() {
      revisedSecondParagraph = widget.secondParagraph;
    });
  }

  void _goToThirdPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ThirdParagraphPage(
          firstParagraph: widget.firstParagraph,
          secondParagraph: revisedSecondParagraph.isNotEmpty?revisedSecondParagraph:widget.secondParagraph,
          thirdParagraph: widget.thirdParagraph,
          userInfo: widget.userInfo,
          userPromptFactor: widget.userPromptFactor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(250, 51, 51, 255),
        title: const Text('두 번째 문단 수정'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 수정 이전 문단 표시
            const Text('수정 이전 문단:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  widget.secondParagraph,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // 수정 이후 문단 표시
            const Text('수정 이후 문단:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  revisedSecondParagraph!= widget.secondParagraph
                      ? revisedSecondParagraph
                      : '아직 수정된 문단이 없습니다.', // 수정된 문단이 없으면 기본 메시지 출력
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            Container(
              height: 120,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TextField는 위에 배치
                  TextField(
                    controller: _modificationController,
                    decoration: const InputDecoration(hintText: '수정 사항을 입력하세요'),
                  ),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                      scrollDirection:Axis.horizontal,
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                              height: 55,
                              child: Row(
                                children: [
                                  ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor: WidgetStateProperty
                                          .resolveWith<Color>(
                                            (Set<WidgetState> states) {
                                          if (states
                                              .contains(WidgetState.pressed)) {
                                            return Colors.blueGrey; // 클릭(pressed) 시 배경색
                                          }
                                          return const Color.fromARGB(255, 233, 236, 239); // 기본 배경색
                                        },
                                      ),
                                      elevation: WidgetStateProperty
                                          .resolveWith<double>(
                                            (Set<WidgetState> states) {
                                          if (states
                                              .contains(WidgetState.pressed)) {
                                            return 5.0; // 클릭(pressed) 시 그림자 깊이 증가
                                          }
                                          return 3.0; // 기본 그림자 깊이
                                        },
                                      ),
                                      padding:
                                      WidgetStateProperty.all<EdgeInsets>(
                                        const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                      ),
                                      shape: WidgetStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      // 버튼을 클릭했을 때 동작
                                      _editSecondParagraph(tag: '간략하게');
                                    },
                                    child: const Text('간략하게',
                                        style: TextStyle(color: Colors.black26,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  SizedBox(width: 8),
                                ],
                              )),
                          Container(
                              height: 55,
                              child: Row(
                                children: [
                                  ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor: WidgetStateProperty
                                          .resolveWith<Color>(
                                            (Set<WidgetState> states) {
                                          if (states
                                              .contains(WidgetState.pressed)) {
                                            return Colors.blueGrey; // 클릭(pressed) 시 배경색
                                          }
                                          return const Color.fromARGB(255, 233, 236, 239); // 기본 배경색
                                        },
                                      ),
                                      elevation: WidgetStateProperty
                                          .resolveWith<double>(
                                            (Set<WidgetState> states) {
                                          if (states
                                              .contains(WidgetState.pressed)) {
                                            return 5.0; // 클릭(pressed) 시 그림자 깊이 증가
                                          }
                                          return 3.0; // 기본 그림자 깊이
                                        },
                                      ),
                                      padding:
                                      WidgetStateProperty.all<EdgeInsets>(
                                        const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                      ),
                                      shape: WidgetStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      // 버튼을 클릭했을 때 동작
                                      _editSecondParagraph(tag: '구체적으로');
                                    },
                                    child: const Text('구체적으로',
                                        style: TextStyle(color: Colors.black26,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  SizedBox(width: 8),
                                ],
                              )),
                          Container(
                              height: 55,
                              child: Row(
                                children: [
                                  ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor: WidgetStateProperty
                                          .resolveWith<Color>(
                                            (Set<WidgetState> states) {
                                          if (states
                                              .contains(WidgetState.pressed)) {
                                            return Colors.blueGrey; // 클릭(pressed) 시 배경색
                                          }
                                          return const Color.fromARGB(255, 233, 236, 239); // 기본 배경색
                                        },
                                      ),
                                      elevation: WidgetStateProperty
                                          .resolveWith<double>(
                                            (Set<WidgetState> states) {
                                          if (states
                                              .contains(WidgetState.pressed)) {
                                            return 5.0; // 클릭(pressed) 시 그림자 깊이 증가
                                          }
                                          return 3.0; // 기본 그림자 깊이
                                        },
                                      ),
                                      padding:
                                      WidgetStateProperty.all<EdgeInsets>(
                                        const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                      ),
                                      shape: WidgetStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      // 버튼을 클릭했을 때 동작
                                      _editSecondParagraph(tag: '정중하게');
                                    },
                                    child: const Text('정중하게',
                                        style: TextStyle(color: Colors.black26,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  SizedBox(width: 8),
                                ],
                              )),
                          Container(
                              height: 55,
                              child: Row(
                                children: [
                                  ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor: WidgetStateProperty
                                          .resolveWith<Color>(
                                            (Set<WidgetState> states) {
                                          if (states
                                              .contains(WidgetState.pressed)) {
                                            return Colors.blueGrey; // 클릭(pressed) 시 배경색
                                          }
                                          return const Color.fromARGB(255, 233, 236, 239); // 기본 배경색
                                        },
                                      ),
                                      elevation: WidgetStateProperty
                                          .resolveWith<double>(
                                            (Set<WidgetState> states) {
                                          if (states
                                              .contains(WidgetState.pressed)) {
                                            return 5.0; // 클릭(pressed) 시 그림자 깊이 증가
                                          }
                                          return 3.0; // 기본 그림자 깊이
                                        },
                                      ),
                                      padding:
                                      WidgetStateProperty.all<EdgeInsets>(
                                        const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                      ),
                                      shape: WidgetStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      // 버튼을 클릭했을 때 동작
                                      _editSecondParagraph(tag: '자연스럽게');
                                    },
                                    child: const Text('자연스럽게',
                                        style: TextStyle(color: Colors.black26,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  SizedBox(width: 8),
                                ],
                              )),
                          Container(
                              height: 55,
                              child: Row(
                                children: [
                                  ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor: WidgetStateProperty
                                          .resolveWith<Color>(
                                            (Set<WidgetState> states) {
                                          if (states
                                              .contains(WidgetState.pressed)) {
                                            return Colors.blueGrey; // 클릭(pressed) 시 배경색
                                          }
                                          return const Color.fromARGB(255, 233, 236, 239); // 기본 배경색
                                        },
                                      ),
                                      elevation: WidgetStateProperty
                                          .resolveWith<double>(
                                            (Set<WidgetState> states) {
                                          if (states
                                              .contains(WidgetState.pressed)) {
                                            return 5.0; // 클릭(pressed) 시 그림자 깊이 증가
                                          }
                                          return 3.0; // 기본 그림자 깊이
                                        },
                                      ),
                                      padding:
                                      WidgetStateProperty.all<EdgeInsets>(
                                        const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                      ),
                                      shape: WidgetStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      // 버튼을 클릭했을 때 동작
                                      _editSecondParagraph(tag: '더 길게');
                                    },
                                    child: const Text('더 길게',
                                        style: TextStyle(color: Colors.black26,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  SizedBox(width: 8),
                                ],
                              )),
                          Container(
                              height: 55,
                              child: Row(
                                children: [
                                  ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor: WidgetStateProperty
                                          .resolveWith<Color>(
                                            (Set<WidgetState> states) {
                                          if (states
                                              .contains(WidgetState.pressed)) {
                                            return Colors.blueGrey; // 클릭(pressed) 시 배경색
                                          }
                                          return const Color.fromARGB(255, 233, 236, 239); // 기본 배경색
                                        },
                                      ),
                                      elevation: WidgetStateProperty
                                          .resolveWith<double>(
                                            (Set<WidgetState> states) {
                                          if (states
                                              .contains(WidgetState.pressed)) {
                                            return 5.0; // 클릭(pressed) 시 그림자 깊이 증가
                                          }
                                          return 3.0; // 기본 그림자 깊이
                                        },
                                      ),
                                      padding:
                                      WidgetStateProperty.all<EdgeInsets>(
                                        const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                      ),
                                      shape: WidgetStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      // 버튼을 클릭했을 때 동작
                                      _editSecondParagraph(tag: '더 짧게');
                                    },
                                    child: const Text('더 짧게',
                                        style: TextStyle(color: Colors.black26,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  SizedBox(width: 8),
                                ],
                              )),
                        ],
                      )
                  )

                  // 태그 버튼 추가
                ],
              ),
            ),

            const SizedBox(height: 5),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _isLoading
                    ? const CircularProgressIndicator()
                    : Container(
                  height: 50,
                  child:ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                      WidgetStateProperty.resolveWith<Color>(
                            (Set<WidgetState> states) {
                          if (states.contains(WidgetState.pressed)) {
                            return Colors.blueAccent; // 클릭(pressed) 시 배경색
                          }
                          return Color.fromARGB(250, 51, 51, 255);
                        },
                      ),
                      elevation: WidgetStateProperty.resolveWith<double>(
                            (Set<WidgetState> states) {
                          if (states.contains(WidgetState.pressed)) {
                            return 10.0; // 클릭(pressed) 시 그림자 깊이 증가
                          }
                          return 5.0; // 기본 그림자 깊이
                        },
                      ),
                      padding: WidgetStateProperty.all<EdgeInsets>(
                        const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                      ),
                      shape:
                      WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    onPressed: _editSecondParagraph,
                    child: const Text('수정하기',
                        style:TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 20),
                Container(
                  height:50,
                  child:ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                      WidgetStateProperty.resolveWith<Color>(
                            (Set<WidgetState> states) {
                          if (states.contains(WidgetState.pressed)) {
                            return Colors.blueAccent; // 클릭(pressed) 시 배경색
                          }
                          return Color.fromARGB(250, 51, 51, 255);
                        },
                      ),
                      elevation: WidgetStateProperty.resolveWith<double>(
                            (Set<WidgetState> states) {
                          if (states.contains(WidgetState.pressed)) {
                            return 10.0; // 클릭(pressed) 시 그림자 깊이 증가
                          }
                          return 5.0; // 기본 그림자 깊이
                        },
                      ),
                      padding: WidgetStateProperty.all<EdgeInsets>(
                        const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                      ),
                      shape:
                      WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    onPressed: _resetToOriginal,
                    child: const Text('원래대로',
                        style:TextStyle(fontSize: 15, fontWeight: FontWeight.bold)
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Container(
                  height:50,
                  child:ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                      WidgetStateProperty.resolveWith<Color>(
                            (Set<WidgetState> states) {
                          if (states.contains(WidgetState.pressed)) {
                            return Colors.blueAccent; // 클릭(pressed) 시 배경색
                          }
                          return Color.fromARGB(250, 51, 51, 255);
                        },
                      ),
                      elevation: WidgetStateProperty.resolveWith<double>(
                            (Set<WidgetState> states) {
                          if (states.contains(WidgetState.pressed)) {
                            return 10.0; // 클릭(pressed) 시 그림자 깊이 증가
                          }
                          return 5.0; // 기본 그림자 깊이
                        },
                      ),
                      padding: WidgetStateProperty.all<EdgeInsets>(
                        const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                      ),
                      shape:
                      WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    onPressed: _goToThirdPage,
                    child: const Text('다음 문단 수정',
                        style:TextStyle(fontSize: 15, fontWeight: FontWeight.bold)
                    ),
                  ),
                ),


              ],
            ),
          ],
        ),
      ),
    );
  }
}