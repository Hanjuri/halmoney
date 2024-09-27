import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:halmoney/JobSearch_pages/JobList_widget.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import 'package:halmoney/FirestoreData/user_Info.dart';
import 'package:halmoney/FirestoreData/JobProvider.dart';

class JobSearch extends StatefulWidget {
  final UserInfo userInfo;
  const JobSearch({super.key, required this.userInfo});

  @override
  _JobSearchState createState() => _JobSearchState();
}

class _JobSearchState extends State<JobSearch> {
  String? userDocId;
  List<String> userLikes = [];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _fetchUserLikes();
    // Jobs data는 JobsProvider를 통해 가져오기 때문에 별도 호출 필요 없음
  }

  Future<void> _fetchUserLikes() async {
    try {
      // Fetch the user document based on the provided widget.id
      final QuerySnapshot userQuery = await FirebaseFirestore.instance
          .collection('user')
          .where('id', isEqualTo: widget.userInfo.userId)
          .get();

      if (userQuery.docs.isNotEmpty) {
        // Assuming there is only one user document matching the id
        final String userId = userQuery.docs.first.id;
        userDocId = userId;

        // Fetch the user's likes sub-collection
        final QuerySnapshot userLikesQuery = await FirebaseFirestore.instance
            .collection('user')
            .doc(userId)
            .collection('users_like')
            .get();

        // Extract the 'num' field from each document, if it exists
        setState(() {
          userLikes = userLikesQuery.docs
              .where((doc) => (doc.data() as Map<String, dynamic>).containsKey('num'))
              .map((doc) => doc['num'].toString())
              .toList();
        });
        print('---------------------------');
        print(userLikes);
      } else {
        print("No user found with the provided id.");
      }
    } catch (error) {
      print("Failed to fetch user likes!: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    // JobsProvider를 통해 데이터를 가져옴
    final jobsProvider = Provider.of<JobsProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.notoSansKrTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: SafeArea(
        top: true,
        left: false,
        bottom: true,
        right: false,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('공고리스트'),
            centerTitle: true,
            backgroundColor: const Color.fromARGB(250, 51, 51, 255),
            leading: IconButton(
              onPressed: () async {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios_rounded),
              color: Colors.grey,
            ),
          ),
          body: jobsProvider.isLoading
              ? const Center(child: CircularProgressIndicator())  // 로딩 중
              : jobsProvider.jobs.isEmpty
              ? const Center(child: Text('No jobs available'))
              : ListView.builder(
            itemCount: jobsProvider.jobs.length,
            itemBuilder: (context, index) {
              final job = jobsProvider.jobs[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: JobList(
                  userInfo: widget.userInfo,
                  num: job['num'],
                  title: job['title'],
                  address: job['address'],
                  wage: job['wage'],
                  career: job['career'],
                  detail: job['detail'],
                  workweek: job['workweek'],
                  image_path: job['image_path'],
                  isLiked: userLikes.contains(job['num'].toString()),  // 사용자 좋아요 정보 반영
                  endday: job['end_day'],
                  manager_call: job['manager_call'] ?? 'No Call Number',
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
