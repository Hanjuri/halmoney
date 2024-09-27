import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:halmoney/JobSearch_pages/Recruit_main_page.dart';

import '../FirestoreData/user_Info.dart';

class JobList extends StatefulWidget {
  final UserInfo userInfo;
  final int num;
  final String title;
  final String address;
  final String wage;
  final String career;
  final String detail;
  final String workweek;
  final bool isLiked;
  final String image_path;
  final String endday;
  final String manager_call;

  const JobList({
    required this.userInfo,
    required this.num,
    required this.title,
    required this.address,
    required this.wage,
    required this.career,
    required this.detail,
    required this.workweek,
    required this.isLiked,
    required this.image_path,
    required this.endday,
    required this.manager_call,
    super.key,
  });

  @override
  _JobListState createState() => _JobListState();
}

class _JobListState extends State<JobList> {
  late bool isFavorite;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.isLiked;
  }

  Future<void> toggleFavorite() async {
    final QuerySnapshot result = await _firestore
        .collection('user')
        .where('id', isEqualTo: widget.userInfo.userId)
        .get();
    final List<DocumentSnapshot> documents = result.docs;

    if (documents.isNotEmpty) {
      final String docId = documents.first.id;

      setState(() {
        isFavorite = !isFavorite;
      });

      if (isFavorite) {
        await _firestore.collection('user').doc(docId).collection('users_like').add({
          'num': widget.num,
          'title': widget.title,
          'address': widget.address,
          'wage': widget.wage,
          'career': widget.career,
          'detail': widget.detail,
          'week': widget.workweek,
        });
      } else {
        final QuerySnapshot favoriteResult = await _firestore
            .collection('user')
            .doc(docId)
            .collection('users_like')
            .where('num', isEqualTo: widget.num)
            .get();
        final List<DocumentSnapshot> favoriteDocuments = favoriteResult.docs;
        for (var doc in favoriteDocuments) {
          await doc.reference.delete();
        }
      }
    }
  }

  Future<void> _saveViewedJob() async {
    try {
      final QuerySnapshot result = await _firestore
          .collection('user')
          .where('id', isEqualTo: widget.userInfo.userId)
          .get();
      final List<DocumentSnapshot> documents = result.docs;

      if (documents.isNotEmpty) {
        final String docId = documents.first.id;
        final viewedJobsRef = _firestore
            .collection('user')
            .doc(docId)
            .collection('viewed_jobs')
            .doc();

        await viewedJobsRef.set({
          'job_title': widget.title,
          'viewed_at': Timestamp.now(),
        });
      } else {
        print('User document ID is empty.');
      }
    } catch (error) {
      print('Failed to save job viewing history: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _saveViewedJob();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Recruit_main(
              userInfo: widget.userInfo,
              num: widget.num,
              title: widget.title,
              address: widget.address,
              wage: widget.wage,
              career: widget.career,
              detail: widget.detail,
              workweek: widget.workweek,
              endday:widget.endday,
              image_path: widget.image_path,
              manager_call: widget.manager_call,
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const SizedBox(width: 10),
              SizedBox(
                width: 100,
                height: 100,
                child: Column(
                  children: [
                    Image.asset(
                     widget.image_path,
                      width: 90,
                      height: 90,
                    )
                  ],
                ),
              ),
              const SizedBox(width: 15),
              SizedBox(
                width: 250,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            onPressed: toggleFavorite,
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.address,
                              style: const TextStyle(
                                fontSize: 13,
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
                          Text(
                            widget.wage,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
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
        ],
      ),
    );
  }
}
