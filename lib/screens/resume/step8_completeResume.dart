// 작성자 : 황제하
// 생성일 : 2024-09-23
// 자기소개서 작성 완료 페이지

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:halmoney/FirestoreData/user_Info.dart';
import 'package:halmoney/screens/resume/resumeEdit.dart';
import 'package:halmoney/screens/resume/resume_JobsList/fetchRecommendations.dart';
import 'package:halmoney/screens/resume/user_prompt_factor.dart';
import 'package:halmoney/JobSearch_pages/Recruit_main_page.dart';
import 'package:halmoney/JobSearch_pages/JobList_widget.dart';
import 'package:halmoney/FirestoreData/user_Info.dart';
import 'package:intl/intl.dart';


class StepCompleteResume extends StatefulWidget {
  final UserInfo userInfo;
  final UserPromptFactor userPromptFactor;
  final String userSelfIntroduction;

  StepCompleteResume({
    super.key,
    required this.userInfo,
    required this.userPromptFactor,
    required this.userSelfIntroduction,
  });

  @override
  State<StepCompleteResume> createState() => _StepCompleteResumeState();
}

class _StepCompleteResumeState extends State<StepCompleteResume> {
  bool _isLoading = true;
  List<DocumentSnapshot> recommendedJobs = [];

  @override
  void initState() {
    super.initState();
    _fetchRecommendedJobs();
  }

  Future<void> _fetchRecommendedJobs() async {
    // 관심 지역과 관심 분야를 가져오기
    String interestPlace = widget.userInfo.userAddress;
    List<String> interestWork = widget.userPromptFactor.selectedFields;

    print('관심 지역: $interestPlace');
    print('관심 분야: $interestWork');

    // fetchRecommendations 함수 호출하여 추천 공고 가져오기
    recommendedJobs = await fetchRecommendations(
      interestPlace: interestPlace,
      interestWork: interestWork,
    );

    setState(() {
      _isLoading = false;
    });
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
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  for (int i = 0; i < 7; i++) {
                    Navigator.of(context).pop();
                  }
                },
                child: const Row(
                  children: [
                    Icon(
                      Icons.home,
                      size: 30,
                      color: Colors.white,
                    ),
                    Text('홈으로',
                        style: TextStyle(
                          fontFamily: 'NanumGothicFamily',
                          fontSize: 20.0,
                          color: Colors.white,
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.all(25.0),
            child: ListView(children: [
              const SizedBox(
                height: 40,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Image(
                    image: AssetImage('assets/images/complete.png'),
                    width: 80,
                    height: 80,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    '자기소개서 생성 완료',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 300,
                    child: const Text(
                      '아래 버튼을 눌러서 자기소개서를 복사하거나 이력서로 저장해보세요.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Clipboard.setData(
                          ClipboardData(text: widget.userSelfIntroduction));
                    },
                    child: const Text("자기소개서 복사",
                        style: TextStyle(color: Colors.white, fontSize: 20)
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(250, 51, 51, 255),
                      minimumSize: const Size(250, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ResumeEdit(
                                    userInfo: widget.userInfo,
                                    userPromptFactor: widget.userPromptFactor,
                                    userSelfIntroduction:
                                        widget.userSelfIntroduction,
                                  ))
                          // builder: (context) => RecommendationPage(
                          //       userInfo: widget.userInfo,
                          //       userPromptFactor:
                          //           widget.userPromptFactor,
                          //     )),
                          );
                    },
                    child: const Text("이력서로 저장",
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(250, 51, 51, 255),
                      minimumSize: const Size(250, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              Divider(),
              SizedBox(
                height: 20,
              ),
              Text(widget.userInfo.userName + '님을 위한 추천 공고',
                  style: TextStyle(
                    fontFamily: 'NanumGothicFamily',
                    fontSize: 20.0,
                    color: Colors.black,
                  )),
              Container(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  child: Column(
                    children: recommendedJobs.map((job) {
                      return Column(
                        children: [
                          CondSearch(userInfo:widget.userInfo, job: job),
                          const SizedBox(height: 10),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ])),
      ),
    );
  }
}

class CondSearch extends StatelessWidget {
  final DocumentSnapshot job;
  final UserInfo userInfo;

  const CondSearch({

    required this.job,
    required this.userInfo,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // jobData가 Map<String, dynamic> 타입이거나 null일 수 있습니다.
    final Map<String, dynamic>? jobData = job.data() as Map<String, dynamic>?;

    if (jobData == null) {
      return const Text('데이터가 없거나 유효하지 않습니다');
    }

    // 각 필드에 대한 데이터 처리
    String jobName = jobData['job_name'] ?? '직종 정보 없음';
    String address = jobData['address'] ?? '주소 정보 없음';
    String wage = jobData['wage'] ?? '급여 정보 없음';
    String workweek = jobData.containsKey('workweek') ? jobData['workweek'] : '근무 요일 정보 없음';

    Timestamp endDayTimestamp = jobData['end_day'] ?? Timestamp.now(); // 기본값을 현재 날짜로 설정
    DateTime endDay = endDayTimestamp.toDate(); // Timestamp를 DateTime으로 변환
    String formattedEndDay = DateFormat('yyyy-MM-dd').format(endDay); // 원하는 날짜 형식으로 변환

    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context, // 콤마 추가
          MaterialPageRoute(
            builder: (context) => Recruit_main(
              userInfo: userInfo,
              num: job['num'],
              title: job['title'],
              address: job['address'],
              wage: job['wage'],
              career: job['career'],
              detail: job['detail'],
              workweek: workweek,
              image_path: job['image_path'],
              endday: formattedEndDay,
              manager_call: job['manager_call'] ?? 'No Call Number',
            ),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: SizedBox(
        // SizedBox로 수정
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              child: Column(
                children: [
                  Image.asset(
                    jobData['image_path'],
                    width: 90,
                    height: 80,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 15),
            SizedBox(
              width: 200,
              height: 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          jobName,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          address,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: Color.fromARGB(250, 69, 99, 255),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          wage,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
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
