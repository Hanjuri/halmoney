import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:halmoney/JobSearch_pages/JobList_widget.dart';
class UserLikesScreen extends StatefulWidget {
  final String id;

  const UserLikesScreen({super.key, required this.id});

  @override
  _UserLikesState createState() => _UserLikesState();
}
class _UserLikesState extends State<UserLikesScreen> {
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
        child: Text('찜한 공고가 없습니다!'),
      ),
    );
  }
}
//   @override
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   List<Map<String, dynamic>> jobs = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchJobs();
//   }
//
//   Future<void> _fetchJobs() async {
//     try {
//       // 사용자가 찜한 작업 목록을 가져오기 위해 users_like 컬렉션을 쿼리합니다.
//       final QuerySnapshot result = await _firestore
//           .collection('user')
//           .where('id', isEqualTo: widget.id)
//           .get();
//       final List<DocumentSnapshot> documents = result.docs;
//
//       if (documents.isNotEmpty) {
//         final String docId = documents.first.id;
//
//         // 사용자가 찜한 작업 목록을 가져옵니다.
//         final QuerySnapshot userLikesResult = await _firestore
//             .collection('user')
//             .doc(docId)
//             .collection('users_like')
//             .get();
//
//         // 사용자가 찜한 작업 목록을 jobs 리스트에 추가합니다.
//         setState(() {
//           jobs = userLikesResult.docs.map((doc) {
//             final data = doc.data() as Map<String, dynamic>;
//             return {
//               'num': data['num'] ?? 0,
//               'title': data['title'] ?? 'No Title.',
//               'address': data['address']?? 'No address',
//               'career.dart': data['career.dart']?? 'No Career',
//               'wage': data['wage']?? 'No wage',
//               'week': data['week']?? 'No week',
//               'detail': data['detail']?? 'No detail',
//               'image_path':data['image_path']??'No path',
//               'isLiked': true,
//               // 나머지 필드도 필요에 따라 추가할 수 있습니다.
//             };
//           }).toList();
//         });
//       }
//     } catch (error) {
//       print("Failed to update interest place: $error");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Failed to update interest place: $error")),
//       );
//     }
//   }
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         textTheme: GoogleFonts.notoSansKrTextTheme(
//           Theme.of(context).textTheme,
//         ),
//       ),
//
//       home : SafeArea(
//         top: true,
//         left: false,
//         bottom: true,
//         right: false,
//         child: Scaffold(
//           appBar: AppBar(
//             title : const Text('찜 목록'),
//             centerTitle: true,
//             backgroundColor: Colors.white,
//             leading: IconButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               icon: const Icon(Icons.arrow_back_ios_rounded,),
//               color: Colors.grey,
//             ),
//           ),
//           body: jobs.isEmpty
//               ? const Row(
//
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Text('찜한 목록이 없음!')
//             ],
//           )
//               : ListView.builder(
//             itemCount: jobs.length,
//             itemBuilder: (context, index) {
//               final job = jobs[index];
//               return Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 8.0),
//                 child: JobList(
//                   id: widget.id,
//                   num: job['num'],
//                   title: job['title'],
//                   address: job['address'],
//                   wage: job['wage'],
//                   career: job['career.dart'],
//                   detail: job['detail'],
//                   workweek: job['week'],
//                   isLiked: job['isLiked'],
//                   image_path: job['image_path'],
//                   endday:job['end_day'],
//                   manager_call: job['manager_call'],
//
//                 ),
//               );
//             },
//           ),
//
//         ),
//       ),
//     );
//   }
//
// }


