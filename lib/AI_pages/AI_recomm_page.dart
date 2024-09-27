import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:halmoney/FirestoreData/JobProvider.dart';
import 'package:halmoney/FirestoreData/user_Info.dart';
import 'package:provider/provider.dart';
import 'cond_search_result_page.dart';

class AIRecommPage extends StatefulWidget {
  final UserInfo userInfo;
  const AIRecommPage({super.key, required this.userInfo});

  @override
  _AIRecommPage createState() => _AIRecommPage();
}

class _AIRecommPage extends State<AIRecommPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<String> interestPlace = []; // 사용자의 관심 지역
  List<String> interestWork = []; // 사용자의 관심 분야 목록
  List<Map<String, dynamic>> viewedJobs = []; // 사용자가 본 공고 목록
  List<Map<String, dynamic>> likedJobs = []; // 사용자가 찜한 공고 목록
  List<Map<String, dynamic>> recommendedJobs = []; // 추천된 공고 목록
  bool isLoading = true; // 로딩 상태 플래그

  @override
  void initState() {
    super.initState();
    fetchUserData(); // 초기 데이터 가져오기
  }

  // 사용자 데이터를 Firestore에서 가져오는 함수
  Future<void> fetchUserData() async {
    try {
      // 사용자의 ID로 Firestore에서 사용자 문서 가져오기
      final QuerySnapshot result = await _firestore
          .collection('user')
          .where('id', isEqualTo: widget.userInfo.userId)
          .get();
      final List<DocumentSnapshot> documents = result.docs;

      if (documents.isNotEmpty) {
        final String docId = documents.first.id;

        // 검색 조건 정보 가져오기
        final interestPlaceSnapshot = await _firestore
            .collection('user')
            .doc(docId)
            .collection('preferredConditions')
            .doc('conditions')
            .get();
        final interestPlaceData = interestPlaceSnapshot.data();

        if (interestPlaceData != null) {
          setState(() {
            // 관심 직종, 지역, 급여 형태, 근무일수를 가져오기
            List<String> locations = List<String>.from(interestPlaceData['location']);
            //List<String> paymentTypes = List<String>.from(interestWorkData['payment_type']);
            //List<String> workingDays = List<String>.from(interestWorkData['working_days']);

            // 사용자 정보 업데이트
            interestPlace = locations;

            // 조건을 로그에 출력해 확인할 수 있도록 설정
            print("Preferred Locations: $locations");
            //print("Preferred Payment Types: $paymentTypes");
            //print("Preferred Working Days: $workingDays");
          });
        }


        // 관심 지역 가져오기 - 회원가입 과정 수정
        final interestWorkSnapshot = await _firestore
            .collection('user')
            .doc(docId)
            .collection('Interest')
            .doc('interest')
            .get();
        final interestWorkData = interestWorkSnapshot.data();

        if (interestWorkData != null) {
          setState(() {
            // 관심 직종, 지역, 급여 형태, 근무일수를 가져오기
            List<String> jobTypes = List<String>.from(interestWorkData['selectedFields']);
            //List<String> paymentTypes = List<String>.from(interestWorkData['payment_type']);
            //List<String> workingDays = List<String>.from(interestWorkData['working_days']);

            // 사용자 정보 업데이트
            interestWork = jobTypes;  // 관심 직종 저장

            // 조건을 로그에 출력해 확인할 수 있도록 설정
            print("Preferred Job Types: $jobTypes");
            //print("Preferred Payment Types: $paymentTypes");
            //print("Preferred Working Days: $workingDays");
          });
        }

        // 사용자가 본 공고 목록 가져오기
        final viewedJobsSnapshot = await _firestore
            .collection('user')
            .doc(docId)
            .collection('viewed_jobs')
            .get();
        setState(() {
          viewedJobs = viewedJobsSnapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return {
              'job_title': data['job_title'],
              //'viewed_at': data['viewed_at']
            };
          }).toList();
        });


        // 추천시스템 계산 코드 호출
        computeRecommendations();
      }
    } catch (error) {
      print("Failed to fetch user data: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch user data: $error")),
      );
    }
  }


  //TF-IDF 계산
  Map<String, double> computeTFIDF(String document, List<String> corpus) {
    Map<String, double> wordFrequency = {};
    List<String> words = document.split(' ');

    // 문서 내 빈도 계산
    for (String word in words) {
      wordFrequency[word] = (wordFrequency[word] ?? 0) + 1;
    }

    // TF-IDF 점수 계산
    for (String word in wordFrequency.keys) {
      int documentFrequency = corpus.where((doc) => doc.split(' ').contains(word)).length; // 정확한 단어 매칭
      wordFrequency[word] = (wordFrequency[word]! / words.length) *
          log(corpus.length / (documentFrequency + 1));
    }

    return wordFrequency;
  }



  double cosineSimilarity(Map<String, double> vec1, Map<String, double> vec2) {
    double dotProduct = 0.0;
    double magnitude1 = 0.0;
    double magnitude2 = 0.0;

    for (String key in vec1.keys) {
      dotProduct += vec1[key]! * (vec2[key] ?? 0);
      magnitude1 += pow(vec1[key]!, 2);
    }

    for (String key in vec2.keys) {
      magnitude2 += pow(vec2[key]!, 2);
    }

    magnitude1 = sqrt(magnitude1);
    magnitude2 = sqrt(magnitude2);

    if (magnitude1 != 0.0 && magnitude2 != 0.0) {
      return dotProduct / (magnitude1 * magnitude2);
    } else {
      return 0.0;
    }
  }


  // 추천 계산 함수
  void computeRecommendations() {
    final jobsProvider = Provider.of<JobsProvider>(context, listen: false);

    // 사용자의 관심 분야와 열람한 공고 제목을 하나의 프로파일로 합치기
    List<String> userProfile = List.from(interestWork);
    userProfile.addAll(interestPlace);  // 관심 지역을 프로파일에 추가
    userProfile.addAll(viewedJobs.map<String>((job) => job['job_title']).toList());
    String userProfileStr = userProfile.join(' ');

    print("User Profile: $userProfile");

    // 필터링된 추천 데이터 리스트
    List<Map<String, dynamic>> filteredJobs = [];

    print("Total job count from provider: ${jobsProvider.jobs.length}");
    // 일차적으로 관심 직무 또는 관심 지역에 해당하는 공고만 필터링
    for (int i = 0; i < jobsProvider.jobs.length; i++) {
      final job = jobsProvider.jobs[i];

      // 관심 직무 또는 관심 지역에 해당하는 공고 필터링
      bool isWorkMatched = interestWork.any((work) => job['title'].contains(work));
      bool isPlaceMatched = interestPlace.any((place) => job['address'].contains(place));

      if (isWorkMatched || isPlaceMatched) {
        filteredJobs.add(job);
      }
    }

    print("Filtered job count: ${filteredJobs.length}");

    // 필터링된 데이터와 유사도 계산
    List<Map<String, dynamic>> recommendations = [];
    List<String> jobDescriptions = filteredJobs.map<String>((job) {
      return '${job['title'] ?? ''} ${job['detail'] ?? ''} ${job['address'] ?? ''}';
    }).toList();

    print("Starting TF-IDF computation...");
    Map<String, double> userProfileTFIDF = computeTFIDF(userProfileStr, jobDescriptions + [userProfileStr]);
    print("TF-IDF computation completed.");

    print("Starting recommendation computation...");
    for (int i = 0; i < filteredJobs.length; i++) {
      final job = filteredJobs[i];
      String jobDesc = '${job['title'] ?? ''} ${job['detail'] ?? ''} ${job['address'] ?? ''}';
      Map<String, double> jobTFIDF = computeTFIDF(jobDesc, jobDescriptions + [userProfileStr]);

      double similarityScore = cosineSimilarity(userProfileTFIDF, jobTFIDF);

      // 관심 지역과 일치하는지 확인 후 가중치 추가
      if (interestPlace.any((place) => job['address'].contains(place))) {
        similarityScore += 0.1;
      }

      // 관심 직무(직종) 일치 여부 확인 후 가중치 추가
      if (interestWork.any((work) => job['title'].contains(work))) {
        similarityScore += 0.2; // 직무가 일치하면 점수 추가
      }

      job['similarity_score'] = similarityScore;
      recommendations.add({
        'job': job,
        'similarity_score': similarityScore
      });
    }

    // 유사도 점수를 기준으로 공고 정렬
    recommendations.sort((a, b) => b['similarity_score'].compareTo(a['similarity_score']));

    // 상위 15개 공고만 선택
    final topRecommendations = recommendations.take(15).toList();
    print("추천시스템 결과: $topRecommendations");

    setState(() {
      recommendedJobs = topRecommendations.map((r) => r['job'] as Map<String, dynamic>).toList();
      isLoading = false;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CondSearchResultPage(userInfo: widget.userInfo, jobs: recommendedJobs),
      ),
    );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(250, 51, 51, 255),
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
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      body: isLoading ? const Center(child: CircularProgressIndicator()) : Container(),
    );
  }
}

