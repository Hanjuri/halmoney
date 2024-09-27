import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// 하위 카테고리를 생성하는 함수
List<String> generateSubCategories(List<String> interestWorks) {
  print(interestWorks);
  // 하위 카테고리를 정의한 매핑 테이블
  Map<String, List<String>> subCategoryMap = {
    '공공·복지': ['간병인','사회복지사', '방문 요양사', '재활 요양사', '재가 요양보호사','병원 간병인', '가정 간병인','시설 요양보호사(노인요양사)', '노인 간병인','요양 보호사 및 간병인','간호조무사'],
    '건축·시설': ['청소원', '환경미화원', '건물 관리','건물 청소원(공공건물,아파트,사무실,병원,상가,공장 등)','호텔·콘도·숙박시설 청소원(룸메이드,하우스키퍼)'],
    '식음료': ['조리원', '주방 보조', '단체 급식 보조원','한식 조리사(일반 음식점)','주방 보조원','병원 급식 조리사'],
    '고객상담·TM': ['콜센터 상담원', '고객센터', '전화 상담','콜센터 상담원(콜센터·고객센터·CS센터)'],
    '사무': ['사무 보조', '행정 보조', '자료 입력','총무 및 일반 사무원'],
    '회계·세무':['회계 사무원(회계·세무 사무소)','회계 사무원','전산자료 입력원 및 사무 보조원','재무 사무원'],
    '교육': ['교사', '교사 보조', '보육 교사','유치원 교사', '초등 교사', '학원 교사'],
    '의류·바이오':['간병인','사회복지사', '방문 요양사', '재활 요양사', '재가 요양보호사','병원 간병인', '가정 간병인','시설 요양보호사(노인요양사)', '노인 간병인','요양 보호사 및 간병인','간호조무사','치과위생사','치과기공사']
  };

  List<String> subCategories = [];

  // interestWorks 리스트의 각 항목에 대해 하위 카테고리를 찾아 추가
  for (String work in interestWorks) {
    subCategories.addAll(subCategoryMap[work] ?? ['일반']);
  }

  // 중복 제거 후 반환
  return subCategories.toSet().toList();
}

// 추천 공고를 가져오는 함수
Future<List<DocumentSnapshot>> fetchRecommendations({
  required String interestPlace,
  required List<String> interestWork,
}) async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<DocumentSnapshot> recommendedJobs = [];

  try {
    // 모든 공고 가져오기
    final QuerySnapshot jobSnapshot = await _firestore.collection('jobs').get();
    final List<DocumentSnapshot> allJobs = jobSnapshot.docs;

    // 관심 분야에 대한 하위 카테고리 생성
    List<String> subCategories = generateSubCategories(interestWork);
    print('관심 지역: $interestPlace');
    print('관심 분야: $interestWork');
    print('생성된 하위 카테고리: $subCategories');

    List<Map<String, dynamic>> recommendations = [];

    for (var jobDoc in allJobs) {
      // jobDoc.data()는 nullable이므로 null 체크 필요
      final jobData = jobDoc.data() as Map<String, dynamic>?;

      if (jobData == null) {
        // 데이터가 null일 경우 건너뛰기
        continue;
      }

      final String jobTitle = jobData['job_name'] ?? ''; // job_name에서 공고 제목 가져오기
      final String jobAddress = jobData['address'] ?? ''; // address에서 공고 주소 가져오기

      int similarityScore = 0;

      // 관심 분야 및 하위 카테고리와 일치하는 경우 유사도 점수 증가
      bool isMatched = false; // 일치 여부 확인
      for (String field in subCategories) {  // 하위 카테고리로 체크
        print('관심분야 $field, 공고 제목: $jobTitle'); // 디버깅용 출력

        if (jobTitle.contains(field)) {
          print('일치하는 관심분야: $field, 공고 제목: $jobTitle'); // 일치할 경우 출력
          similarityScore += 5;
          isMatched = true;
          break;
        }
      }

      // 관심 분야와 일치하지 않더라도 관심 지역과 일치하는 경우 유사도 점수 증가
      if (jobAddress.contains(interestPlace)) {
        similarityScore += 3;
      }

      if (similarityScore > 0 && isMatched) {  // 관심 분야 일치가 있을 때만 추천
        recommendations.add({
          'job': jobDoc, // 공고 전체 데이터
          'similarity_score': similarityScore
        });
      }
    }

    // 유사도 점수를 기준으로 공고 정렬
    recommendations.sort((a, b) => b['similarity_score'].compareTo(a['similarity_score']));

    // 상위 7개 공고만 선택
    recommendedJobs = recommendations.take(7).map((r) => r['job'] as DocumentSnapshot).toList();

    // 출력 수정
    print('추천된 공고---------------------');
    for (var recommendation in recommendations) {
      final jobData = (recommendation['job'] as DocumentSnapshot).data() as Map<String, dynamic>;
      print('공고 제목: ${jobData['job_name'] ?? '제목 없음'}');
      print('공고 주소: ${jobData['address'] ?? '주소 없음'}');
      print('유사도 점수: ${recommendation['similarity_score']}');
    }
  } catch (error) {
    print("Failed to fetch jobs: $error");
    // 예외 처리 추가 가능
  }

  return recommendedJobs;
}