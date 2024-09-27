import 'package:flutter/material.dart';
import 'package:halmoney/FirestoreData/user_Info.dart';
import 'package:halmoney/resume2/introduction_service.dart';
import 'package:halmoney/screens/resume/resume_revision/second_revision.dart';
import 'package:halmoney/screens/resume/user_prompt_factor.dart';

class FirstParagraphPage extends StatefulWidget {
  final String firstParagraph;
  final String secondParagraph;
  final String thirdParagraph;
  final UserInfo userInfo;
  final UserPromptFactor userPromptFactor;

  const FirstParagraphPage({
    Key? key,
    required this.firstParagraph,
    required this.secondParagraph,
    required this.thirdParagraph,
    required this.userInfo,
    required this.userPromptFactor,
  }) : super(key: key);

  @override
  _FirstParagraphPageState createState() => _FirstParagraphPageState();
}

class _FirstParagraphPageState extends State<FirstParagraphPage> {
  final TextEditingController _modificationController = TextEditingController();
  String revisedFirstParagraph = ''; // 수정된 문단 저장
  bool _isLoading = false;
  final IntroductionService _service = IntroductionService();

  @override
  void initState() {
    super.initState();
    revisedFirstParagraph = widget.firstParagraph;
  }

  Future<void> _editFirstParagraph({String tag = ''}) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // 수정 내용에 태그를 추가
      final revisedText = await _service.generateRevisedIntroduction(
        widget.firstParagraph, // 수정 이전 문단 전달
        _modificationController.text + ' $tag', // 수정 내용 + 태그 전달
      );
      setState(() {
        revisedFirstParagraph = revisedText; // 수정된 문단 업데이트
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
      revisedFirstParagraph = widget.firstParagraph;
    });
  }


  void _goToSecondPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SecondParagraphPage(
          firstParagraph: revisedFirstParagraph.isNotEmpty
              ? revisedFirstParagraph
              : widget.firstParagraph,
          secondParagraph: widget.secondParagraph,
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
        title: const Text('첫 번째 문단 수정'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('수정 이전 문단:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  widget.firstParagraph,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // 수정 이후 문단 표시
            const Text('수정 이후 문단:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  revisedFirstParagraph != widget.firstParagraph
                      ? revisedFirstParagraph
                      : '아직 수정된 문단이 없습니다.',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // TextField 및 태그 버튼
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
                      scrollDirection: Axis.horizontal,
                      child: Row(
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
                                      _editFirstParagraph(tag: '간략하게');
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
                                      _editFirstParagraph(tag: '구체적으로');
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
                                      _editFirstParagraph(tag: '정중하게');
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
                                      _editFirstParagraph(tag: '자연스럽게');
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
                                      _editFirstParagraph(tag: '더 길게');
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
                                      _editFirstParagraph(tag: '더 짧게');
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
                      ))

                  // 태그 버튼 추가
                ],
              ),
            ),

            const SizedBox(height: 10),

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
                    onPressed: _editFirstParagraph,
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
                    onPressed: _goToSecondPage,
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
