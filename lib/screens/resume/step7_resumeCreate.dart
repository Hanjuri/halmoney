// 작성자 : 황제하
// 생성일 : 2024-09-19

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:halmoney/screens/resume/step8_completeResume.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:halmoney/FirestoreData/user_Info.dart';
import 'package:halmoney/screens/resume/user_prompt_factor.dart';
import 'package:halmoney/screens/resume/resume_revision/first_revision.dart';

class StepResumeCreate extends StatefulWidget {
  final UserInfo userInfo;
  final UserPromptFactor userPromptFactor;

  StepResumeCreate({
    super.key,
    required this.userInfo,
    required this.userPromptFactor,
  });

  @override
  State<StepResumeCreate> createState() => _StepResumeCreateState();
}

class _StepResumeCreateState extends State<StepResumeCreate> {
  late List<String> selectedFields;
  late String careers;
  late List<String> selectedStrens;
  late int quantity;
  late String selfIntroduction;
  late String userName;
  Map<String, dynamic>? userData;

  bool _isLoading = true;
  List<DocumentSnapshot> recommendedJobs = [];
  final TextEditingController _selfIntroductionController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchResumeData();
    createSelfIntroduction();

    _selfIntroductionController.addListener(() {
      setState(() {
        selfIntroduction = _selfIntroductionController.text;
      });
    });
  }

  //사용자 정보 불러오기
  Future<void> _fetchResumeData() async {
    try {
      selectedFields = widget.userPromptFactor.selectedFields;
      careers = widget.userPromptFactor.getCareersString();
      selectedStrens = widget.userPromptFactor.selectedStrens;
      quantity = widget.userPromptFactor.quantity;
      userName = widget.userInfo.userName;
    } catch (error) {
      print("Failed to fetch resume data: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch resume data: $error")),
      );
    }
  }

  // 자기소개서 생성 함수
  void createSelfIntroduction() async {
    //GPT 첫번째 자기소개서 작성 함수 호출
    final firstResponse = await _fetchGPTResponse(
      selectedFields: selectedFields,
      careers: careers,
      selectedStrens: selectedStrens,
      quantity: quantity,
    );

    //GPT 두번째 자기소개서 작성 함수 호출
    final secondResponse = await _recreateGPTResponse(
      firstResponse: firstResponse,
    );

    setState(() {
      selfIntroduction = secondResponse;
      _selfIntroductionController.text = secondResponse;
      _isLoading = false;
    });
  }

  //GPT 첫번째 자기소개서 작성 함수
  Future<String> _fetchGPTResponse({
    required List<String> selectedFields,
    required String careers,
    required List<String> selectedStrens,
    required int quantity,
  }) async {
    final apiKey = dotenv.get('GPT_API_KEY');
    const endpoint = 'https://api.openai.com/v1/chat/completions';
    final int maxTokens = quantity;
    final int quantityTokens = (quantity / 2).toInt(); //분량을 2로 나누어서 토큰으로 사용
    final int firstParagraphTokens = (quantityTokens * 0.3).toInt();
    final int secondParagraphTokens = (quantityTokens * 0.5).toInt();
    final int thirdParagraphTokens = (quantityTokens * 0.2).toInt();

    String role = '중장년층 사용자의 정보를 기반으로 자기소개서를 작성';
    String prompt =
        ''' 다음 가이드에 따라 각 항목은 간결하게, '안녕하세요'는 빼고 작성, 전체 분량($quantityTokens)Tokens을 강력하게 제한함;
    첫번째 문단에 포함할 내용 : {
    ($firstParagraphTokens) tokens 내외.
    사용자는 $selectedFields 분야에 지원하고자 합니다.
    이 분야에 지원하게 된 동기를 작성하세요.
    사용자의 경력과 관심사를 바탕으로 자연스럽게 연결해 설명하세요.}
    두번째 문단에 포함할 내용 : {
    ($secondParagraphTokens) tokens 내외.
    사용자의 경력은 다음과 같습니다: ($careers).
    사용자의 경력이 어떻게 지원 분야($selectedFields)와 연관되어 있는지 작성하고, 지원 분야에서 어떤 기여를 할 수 있을지 설명하세요.
    사용자의 장점은 $selectedStrens입니다. 사용자의 장점이 지원 분야에서 어떻게 발휘될 수 있을지 설명하세요.
    특히, 이러한 능력이 해당 직무에서 어떤 방식으로 도움이 될지 구체적으로 작성하세요.}
    세번째 문단에 포함할 내용 : {
    ($thirdParagraphTokens) tokens 내외.
    지원하는 ($selectedFields) 분야에서 사용자가 이루고자 하는 구체적인 목표와 다짐을 포함하여 작성하세요.
    이 목표가 어떻게 조직에 기여할 수 있을지 설명하세요.}
    ''';
    print(prompt);

    try {
      final firstResponse = await http.post(
        Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: json.encode({
          'model': 'gpt-4o-mini',
          'messages': [
            {'role': 'system', 'content': role},
            {'role': 'user', 'content': prompt},
          ],
          'max_tokens': maxTokens,
        }),
      );
      //print("prompt :$prompt");
      print("사용자 정보: $selectedFields, $careers");

      if (firstResponse.statusCode == 200) {
        final responseBody = json.decode(utf8.decode(firstResponse.bodyBytes));

        if (responseBody.containsKey('choices') &&
            responseBody['choices'] is List &&
            responseBody['choices'].isNotEmpty) {
          final text = responseBody['choices'][0]['message']['content'];
          return text;
        } else {
          return 'Failed to fetch response: Invalid response format';
        }
      } else {
        print('Error: ${firstResponse.statusCode} - ${firstResponse.body}');
        return 'Failed to fetch response: ${firstResponse.statusCode} - ${firstResponse.body}';
      }
    } catch (e) {
      print('Exception: $e');
      return 'Failed to fetch response: $e';
    }
  }

  //GPT 두번째 자기소개서 작성 함수
  Future<String> _recreateGPTResponse({
    required String firstResponse,
  }) async {
    final apiKey = dotenv.get('GPT_API_KEY');
    const endpoint = 'https://api.openai.com/v1/chat/completions';
    final int maxTokens = quantity;

    String role = '다음 자소서의 어색한 부분을 수정하여 다시 생성';
    String prompt = firstResponse;

    try {
      final secondResponse = await http.post(
        Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: json.encode({
          'model': 'gpt-4o-mini',
          'messages': [
            {'role': 'system', 'content': role},
            {'role': 'user', 'content': prompt},
          ],
          'max_tokens': maxTokens,
        }),
      );

      if (secondResponse.statusCode == 200) {
        final responseBody = json.decode(utf8.decode(secondResponse.bodyBytes));

        if (responseBody.containsKey('choices') &&
            responseBody['choices'] is List &&
            responseBody['choices'].isNotEmpty) {
          final text = responseBody['choices'][0]['message']['content'];
          return text;
        } else {
          return 'Failed to fetch response: Invalid response format';
        }
      } else {
        print('Error: ${secondResponse.statusCode} - ${secondResponse.body}');
        return 'Failed to fetch response: ${secondResponse.statusCode} - ${secondResponse.body}';
      }
    } catch (e) {
      print('Exception: $e');
      return 'Failed to fetch response: $e';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
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
                      color: Colors.white,
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
                    '5 / 5',
                    style: TextStyle(
                      fontFamily: 'NanumGothicFamily',
                      fontWeight: FontWeight.w600,
                      fontSize: 18.0,
                      color: Colors.white,
                    ),
                  )),
              GestureDetector(
                onTap: () {
                  if (_isLoading == false) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StepCompleteResume(
                                  userInfo: widget.userInfo,
                                  userPromptFactor: widget.userPromptFactor,
                                  userSelfIntroduction: selfIntroduction,
                                )));
                  }
                },
                child: Row(
                  children: [
                    Text('완료',
                        style: TextStyle(
                          fontFamily: 'NanumGothicFamily',
                          fontSize: 20.0,
                          color: _isLoading
                              ? Color.fromARGB(250, 51, 51, 255)
                              : Colors.white,
                        )),
                    Icon(
                      Icons.chevron_right,
                      size: 30,
                      color: _isLoading
                          ? Color.fromARGB(250, 51, 51, 255)
                          : Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: _isLoading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Color(0xff1044FC),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'AI가 자기소개서를\n자동생성중입니다',
                      style: TextStyle(fontSize: 25),
                    ),
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(25.0),
                child: ListView(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const Text('AI가 작성한 자기소개서입니다.',
                        style: TextStyle(fontSize: 20)),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                      '자기소개서를 수정해보세요!',
                      style: TextStyle(fontSize: 25),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _isLoading = true;
                            });
                            createSelfIntroduction();
                          },
                          child: const Text("다시 만들기",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(250, 51, 51, 255),
                            minimumSize: const Size(150, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            List<String> paragraphs =
                                selfIntroduction.split('\n\n');
                            String firstParagraph =
                                paragraphs.isNotEmpty ? paragraphs[0] : '';
                            String secondParagraph =
                                paragraphs.length > 1 ? paragraphs[1] : '';
                            String thirdParagraph =
                                paragraphs.length > 2 ? paragraphs[2] : '';

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FirstParagraphPage(
                                  firstParagraph: firstParagraph,
                                  secondParagraph: secondParagraph,
                                  thirdParagraph: thirdParagraph,
                                  userInfo: widget.userInfo,
                                  userPromptFactor: widget.userPromptFactor,
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            'AI와 수정하기',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(250, 51, 51, 255),
                            minimumSize: const Size(150, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _selfIntroductionController,
                      maxLines: 15,
                      style: TextStyle(fontSize: 20, color: Colors.black),
                      // 폰트 사이즈 및 색상 변경
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black), // 테두리 색상 변경
                        ),
                        hintText: '자기소개서를 입력하세요',
                        hintStyle: TextStyle(color: Colors.grey),
                        // 힌트 텍스트 색상 변경
                        filled: true,
                        fillColor: Colors.white,
                        // 배경 색상 변경
                        contentPadding: EdgeInsets.all(16.0), // 패딩 조정
                      ),
                    ),
                  ],
                ),
              ),

      ),
    );
  }
}
