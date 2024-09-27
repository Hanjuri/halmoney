import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:halmoney/myAppPage.dart';
import '../FirestoreData/PublicJobsData.dart';
import 'PublicJobsList_widget.dart';
import 'package:halmoney/FirestoreData/user_Info.dart';

class PublicJobsDescribe extends StatefulWidget {
  final String id;
  final UserInfo userInfo;

  PublicJobsDescribe ({
    required this.id,
    required this.userInfo,
    Key? key,
  }) : super(key: key);



  @override
  _PublicJobsDescribeState createState() => _PublicJobsDescribeState();
}

class _PublicJobsDescribeState extends State<PublicJobsDescribe> {
  final PublicJobsData _publicJobsData = PublicJobsData();
  List<Map<String, dynamic>> jobs = [];
  List<String> userLikes = [];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _fetchPublicJobs();
  }

  Future<void> _fetchPublicJobs() async {
    try {
      final List<Map<String, dynamic>> fetchedJobs = await _publicJobsData.fetchPublicJobs();

      setState(() {
        jobs = fetchedJobs.map((job) {
          // Convert the Timestamp to a DateTime object and then to a formatted string
          String endDayStr = 'No end_day';
          if (job['endday'] != null) {
            DateTime endDay = (job['endday'] as Timestamp).toDate();
            endDayStr = DateFormat('yyyy-MM-dd').format(endDay); // Format the DateTime
          }

          return {
            'num': job['num'] ?? 0,
            'title': job['title'] ?? 'No Title.',
            'company': job['company'] ?? 'No company',
            'region': job['region'] ?? 'No address',
            'type': job['type'] ?? 'No type',
            'url': job['url'] ?? 'No url',
            'person': job['person'] ?? 'No person',
            'person2': job['person2'] ?? 'No person2',
            'personcareer': job['personcareer'] ?? 'No person career',
            'personedu': job['personedu'] ?? 'No person edu',
            'applystep': job['applystep'] ?? 'No apply step',
            'image_path': job['image_path'] ?? 'No_path',
            'isLiked': userLikes.contains(job['num'].toString()),
            'end_day': endDayStr,
          };
        }).toList();
        print('공공일자리 공고들! $jobs');
      });
    } catch (error) {
      print("Failed to fetch jobs: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch jobs: $error")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
            title: const Text('공공일자리 리스트', style: TextStyle(color: Colors.white)),
            centerTitle: true,
            backgroundColor: const Color.fromARGB(250, 51, 51, 255),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios_rounded),
              color: Colors.grey,
            ),
          ),
          body: jobs.isEmpty
              ? const Center(child: Text('No jobs available'))
              : ListView.builder(
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              final job = jobs[index];
              return Padding(
                padding: const EdgeInsets.all(2.0),
                child: PublicJobList(
                  id: widget.id,
                  title: job['title'] ?? 'No Title',
                  company: job['company'] ?? 'No Company',
                  region: job['region'] ?? 'No Region',
                  url: job['url'] ?? 'No URL',
                  person: job['person'] ?? 'No Person',
                  person2: job['person2'] ?? 'No Person2',
                  personcareer: job['personcareer'] ?? 'No Person Career',
                  personedu: job['personedu'] ?? 'No Person Education',
                  applystep: job['applystep'] ?? 'No Apply Step',
                  image_path: job['image_path'] ?? 'No Image Path',
                  isLiked: job['isLiked'] ?? false,
                  endday: job['end_day'] ?? 'No End Day',
                  userInfo: widget.userInfo,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
