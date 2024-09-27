import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:halmoney/JobSearch_pages/JobList_widget.dart';

import '../../../JobSearch_pages/Recruit_main_page.dart';
import '../../../FirestoreData/user_Info.dart';

class Recommen_Component extends StatelessWidget {
  final UserInfo userInfo;
  final List<DocumentSnapshot> jobs;

  const Recommen_Component(
      {super.key, required this.userInfo, required this.jobs});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          children: jobs.map((job) {
            return Column(
              children: [
                Cond_Search(userInfo: userInfo, job: job),
                const SizedBox(
                  height: 10,
                )
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

class Cond_Search extends StatelessWidget {
  final UserInfo userInfo;
  final DocumentSnapshot job;

  const Cond_Search({super.key, required this.job, required this.userInfo});

  @override
  Widget build(BuildContext context) {
    // jobData가 Map<String, dynamic> 타입이거나 null일 수 있습니다.
    final Map<String, dynamic>? jobData = job.data() as Map<String, dynamic>?;

    // jobData가 null이면 데이터가 없거나 유효하지 않은 경우입니다.
    if (jobData == null) {
      return Container(
        child: Text('데이터가 없거나 유효하지 않습니다'),
      );
    }

    // jobData에서 각 필드를 가져오기 전에 null 여부를 확인하여 처리합니다.
    String jobName = jobData['job_name'] ?? '직종 정보 없음';
    String address = jobData['address'] ?? '주소 정보 없음';
    String wage = jobData['wage'] ?? '급여 정보 없음';

    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Recruit_main(
                userInfo: userInfo,
                num: jobData['num'] ?? 'No',
                title: jobData['title'] ?? 'NO',
                address: address,
                wage: wage,
                career: jobData['job_name'] ?? '',
                detail: jobData['detail'] ?? '',
                workweek: jobData['work_week'] ?? '',
                image_path: jobData['image_path'] ?? '',
                endday: jobData['endday'] ?? '',
                manager_call: jobData['manager_call'] ?? ''
                //userId: widget.id,
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
      child: Container(
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
                  )
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
                  Container(
                    child: Row(
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
                  ),
                  const SizedBox(height: 3),
                  Container(
                    child: Row(
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
                  ),
                  const SizedBox(height: 3),
                  Container(
                    child: Row(
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
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
