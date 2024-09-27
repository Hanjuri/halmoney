import 'dart:convert';
import 'package:halmoney/FirestoreData/user_Info.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:huggingface_dart/huggingface_dart.dart';
import 'cond_search_result_page.dart';

class SearchEngine extends StatefulWidget {
  final UserInfo userInfo;
  const SearchEngine({super.key, required this.userInfo});

  @override
  _SearchEngine createState() => _SearchEngine();
}

class _SearchEngine extends State<SearchEngine> {
  final TextEditingController _controller = TextEditingController();
  List<String> _keywords = [];

  //HuggingFace GLiNER 사용해보기
  HfInference hfInference = HfInference('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');

  
  // 키워드 추출 함수
  Future<void> _searchKeyWords() async {
    try {
      final response = await http.post(
        Uri.parse('http://172.20.6.214:5000/nerExtraction'), // Flask 서버의 IP 주소
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'text': _controller.text,
          'labels': ['Job', 'Ability'],
        }),
      );

      if (response.statusCode == 200) {
        final entities = jsonDecode(response.body);
        setState(() {
          _keywords.clear();

          if (entities['Job'] != null) {
            _keywords.addAll(List<String>.from(entities['Job']));
          }
          if (entities['Ability'] != null) {
            _keywords.addAll(List<String>.from(entities['Ability']));
          }
          if (entities['WorkPeriod'] != null) {
            _keywords.addAll(List<String>.from(entities['WorkPeriod']));
          }
        });
        // Debugging 로그
        print('Keywords: $_keywords');
      } else {
        print('Failed to load entities. Status Code: ${response.statusCode}');
        throw Exception('Failed to load entities');
      }
    } catch (e) {
      print('Error occurred while fetching keywords: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch keywords: $e")),
      );
    }
  }

  // 일자리 필터링 함수
  Future<void> _filterJobs() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      Query jobQuery = firestore.collection('jobs');

      final QuerySnapshot jobResult = await jobQuery.get();
      final List<DocumentSnapshot> jobDocuments = jobResult.docs;

      final filteredJobs = jobDocuments.where((job) {
        final jobData = job.data() as Map<String, dynamic>;

        final jobName = jobData['job_name'] as String;

        // 추출된 키워드 중 하나라도 일치하면 해당 일자리 포함
        final jobMatch = _keywords.isEmpty || _keywords.any((keyword) => jobName.contains(keyword));

        return jobMatch;
      }).map((job) => job.data() as Map<String, dynamic>).toList();

      print('Filtered jobs count: ${filteredJobs.length}');
      if (filteredJobs.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CondSearchResultPage(userInfo: widget.userInfo, jobs: filteredJobs)),
        );
      } else {
        print('No matching jobs found');
        _showNoJobsDialog(context);
      }
    } catch (error) {
      print("Failed to filter jobs: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to filter jobs: $error")),
      );
    }
  }

  // 조건에 맞는 공고가 없을 때 팝업
  void _showNoJobsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('조건에 맞는 공고가 없습니다!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 25.0, right: 30.0, top: 150.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '어떤 일자리를\n원하시나요?',
              style: TextStyle(
                fontSize: 35.0,
                fontFamily: 'NanumGothic',
                fontWeight: FontWeight.w600,
                height: 1.8,
              ),
            ),
            SizedBox(height: 30.0),
            Text(
              '예시\n'
                  '저는 고등학교에서 국어 교사로 20년간 근무하였습니다. 학생을 교육하는 곳에서 하루에 5시간씩 일하고 싶습니다.',
              style: TextStyle(
                fontSize: 19.0,
                fontFamily: 'NanumGothic',
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 30.0),
            // 추출된 키워드들이 화면에 표시됩니다
            Container(
              height: 50.0,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _keywords.map((keyword) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Chip(
                        label: Text(keyword),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            // 텍스트 입력 필드
            SizedBox(
              height: 80,
              child: TextField(
                controller: _controller,
                style: const TextStyle(fontSize: 18.0, height: 2.0),
                decoration: const InputDecoration(
                  hintText: '답변을 적어주세요',
                ),
              ),
            ),
            SizedBox(height: 20.0),
            // 버튼들 (키워드 추출, 일자리 검색)
            Row(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(250, 51, 51, 255),
                    minimumSize: const Size(175, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _searchKeyWords,
                  child: const Text(
                    '키워드 추출',
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                ),
                SizedBox(width: 5),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(250, 51, 51, 255),
                    minimumSize: const Size(175, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _filterJobs,
                  child: const Text(
                    '일자리 검색',
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
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
