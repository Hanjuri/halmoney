import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:halmoney/JobSearch_pages/JobList_widget.dart';

class UserViewedJobsPage extends StatefulWidget {
  final String userId;

  const UserViewedJobsPage({super.key, required this.userId});

  @override
  _UserViewedJobsPageState createState() => _UserViewedJobsPageState();
}

class _UserViewedJobsPageState extends State<UserViewedJobsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 앱바 디자인 영역
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(250, 51, 51, 255),
        elevation: 1.0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  'AI 자기소개서 작성           ',
                  style: TextStyle(
                    fontFamily: 'NanumGothicFamily',
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0,
                    color: Colors.white,
                  ),
                )),
          ],
        ),
      ),

      // 내부 영역
      body: Padding(
        padding: const EdgeInsets.only(
            left: 25.0, right: 30.0, top: 30.0, bottom: 50.0),
        child: Text('최근 본 공고가 없습니다!'),
      ),
    );
  }
}
// final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// List<Map<String, dynamic>> jobs = [];
//
// @override
// void initState() {
//   super.initState();
//   _fetchJobs();
// }
//
// Future<void> _fetchJobs() async {
//   try {
//     // Fetch user data
//     final userResult = await _firestore
//         .collection('user')
//         .where('id', isEqualTo: widget.userId)
//         .get();
//     final List<DocumentSnapshot> userDocs = userResult.docs;
//
//     if (userDocs.isNotEmpty) {
//       final String userDocId = userDocs.first.id;
//
//       // Fetch viewed jobs
//       final viewedJobsSnapshot = await _firestore
//           .collection('user')
//           .doc(userDocId)
//           .collection('viewed_jobs')
//           .get();
//
//       final List<String> viewedJobTitles = viewedJobsSnapshot.docs.map((doc) {
//         final data = doc.data() as Map<String, dynamic>;
//         return data['job_title'] as String;
//       }).toList();
//
//       // Fetch all jobs
//       final QuerySnapshot jobSnapshot = await _firestore.collection('jobs').get();
//       final List<DocumentSnapshot> allJobDocs = jobSnapshot.docs;
//
//       // Match viewed jobs with all jobs
//       final matchedJobs = allJobDocs.where((job) {
//         final jobData = job.data() as Map<String, dynamic>;
//         return viewedJobTitles.contains(jobData['title']);
//       }).toList();
//
//       setState(() {
//         jobs = matchedJobs.map((job) {
//           final data = job.data() as Map<String, dynamic>;
//           return {
//             'num': data['num'] ?? 0,
//             'title': data['title'] ?? 'No Title.',
//             'address': data['address'] ?? 'No address',
//             'career': data['career'] ?? 'No Career',
//             'wage': data['wage'] ?? 'No wage',
//             'week': data['work_time_week'] ?? 'No week',
//             'detail': data['detail'] ?? 'No detail',
//             'image_path': data['image_path'] ?? 'No path',
//             'end_day':data['end_day']??'No end day',
//             'isLiked': false, // Default value, can be updated if needed
//           };
//         }).toList();
//       });
//     }
//   } catch (error) {
//     print("Failed to fetch jobs: $error");
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Failed to fetch jobs: $error")),
//     );
//   }
// }
//
// @override
// Widget build(BuildContext context) {
//   return MaterialApp(
//     debugShowCheckedModeBanner: false,
//     theme: ThemeData(
//       textTheme: GoogleFonts.notoSansKrTextTheme(
//         Theme.of(context).textTheme,
//       ),
//     ),
//     home: SafeArea(
//       top: true,
//       left: false,
//       bottom: true,
//       right: false,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('최근 본 공고'),
//           centerTitle: true,
//           backgroundColor: Colors.white,
//           leading: IconButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             icon: const Icon(Icons.arrow_back_ios_rounded),
//             color: Colors.grey,
//           ),
//         ),
//         body: jobs.isEmpty
//             ? const Center(
//           child: Text('최근 본 공고가 없습니다!'),
//         )
//             : Text('최근 본 공고가 없습니다!'),
//         //     : ListView.builder(
//         //   itemCount: jobs.length,
//         //   itemBuilder: (context, index) {
//         //     final job = jobs[index];
//         //     return Padding(
//         //       padding: const EdgeInsets.symmetric(vertical: 8.0),
//         //       child: JobList(
//         //         id: widget.userId,
//         //         num: job['num'],
//         //         title: job['title'],
//         //         address: job['address'],
//         //         wage: job['wage'],
//         //         career: job['career'],
//         //         detail: job['detail'],
//         //         workweek: job['week'],
//         //         isLiked: job['isLiked'],
//         //         image_path: job['image_path'],
//         //         endday:job['end_day'],
//         //         manager_call: job['manager_call'],
//         //       ),
//         //     );
//         //   },
//         // ),
//       ),
//     ),
//   );
// }
