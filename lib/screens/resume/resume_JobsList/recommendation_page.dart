import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:halmoney/JobSearch_pages/Recruit_main_page.dart';
import '../../../FirestoreData/user_Info.dart';
import '../user_prompt_factor.dart';
import 'fetchRecommendations.dart';


class RecommendationPage extends StatefulWidget {
  final UserInfo userInfo;
  final UserPromptFactor userPromptFactor;

  const RecommendationPage({
    Key? key,
    required this.userInfo,
    required this.userPromptFactor,
  }) : super(key: key);

  @override
  _RecommendationPageState createState() => _RecommendationPageState();
}

class _RecommendationPageState extends State<RecommendationPage> {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('추천 공고 목록',
        style:TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color:Colors.black
        )),
        backgroundColor: Colors.white,
        elevation: 5.0,
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            children: recommendedJobs.map((job) {
              return Column(
                children: [
                  CondSearch(job: job),
                  const SizedBox(height: 10),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class CondSearch extends StatelessWidget {
  final DocumentSnapshot job;

  const CondSearch({super.key, required this.job});

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

    return ElevatedButton(
      onPressed: () {
       /*Navigator.push(
          context, // 콤마 추가
          MaterialPageRoute(
            builder: (context) => RecruitMain(
              id: jobData['id'] ?? 'No',
              num: jobData['num'] ?? 'No',
              title: jobData['title'] ?? 'NO',
              address: address,
              wage: wage,
              career: jobData['job_name'] ?? '',
              detail: jobData['detail'] ?? '',
              workweek: jobData['work_week'] ?? '',
              image_path: jobData['image_path'] ?? '',
              endday: jobData['endday'] ?? '',
              manager_call: jobData['manager_call'] ?? '',
            ),
          ),
        ); */
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: SizedBox( // SizedBox로 수정
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