import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:halmoney/screens/resume/resumeView.dart';

class ResumeManage extends StatefulWidget {
  final String id;

  const ResumeManage({super.key, required this.id});

  @override
  _ResumeManageState createState() => _ResumeManageState();
}

class _ResumeManageState extends State<ResumeManage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<DocumentSnapshot> _resumes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchResumes();
  }

  Future<void> _fetchResumes() async {
    try {
      final QuerySnapshot result = await _firestore
          .collection('user')
          .where('id', isEqualTo: widget.id)
          .get();
      final List<DocumentSnapshot> documents = result.docs;

      if (documents.isNotEmpty) {
        final String docId = documents.first.id;
        QuerySnapshot querySnapshot = await _firestore
            .collection('user')
            .doc(docId)
            .collection('resumes')
            .orderBy('createdAt', descending: true)
            .get();
        setState(() {
          _resumes = querySnapshot.docs;
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Failed to fetch resumes: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _formatDate(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    return '${date.year}-${date.month}-${date.day}';
  }

  String _getSelfIntroductionPreview(String selfIntroduction) {
    const previewLength = 50; // Adjust this value based on how much you want to show
    return selfIntroduction.length > previewLength
        ? '${selfIntroduction.substring(0, previewLength)}...'
        : selfIntroduction;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'NanumGothicBold',
      ),
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('이력서 관리'),
            centerTitle: true,
            backgroundColor: Colors.white,
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back_ios_rounded),
              color: Colors.grey,
            ),
          ),
          body: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
            children: [
              const Divider(),
              GestureDetector(
                // onTap: () async{
                //   final result = await Navigator.push(
                //     context,
                //     MaterialPageRoute(builder: (context) => StepHelloPage(id: widget.id)),
                //   );
                //   if (result ==true){
                //     _fetchResumes();
                //   }
                // },
                child: Container(
                  margin: const EdgeInsets.all(15.0),
                  padding: const EdgeInsets.all(18.0),
                  height: 150,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(250, 51, 51, 255),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        spreadRadius: 2.5,
                        blurRadius: 10.0,
                        offset: Offset(2, 2),
                        blurStyle: BlurStyle.inner,
                      ),
                    ],
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('새 이력서 작성하기',
                          style: TextStyle(
                            fontSize: 30.0,
                            color: Colors.white,
                          ))
                    ],
                  ),
                ),
              ),
              ..._resumes.map((resume) {
                Map<String, dynamic> data = resume.data() as Map<String, dynamic>;
                return GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResumeView(
                          id: widget.id,
                          resumeId: resume.id,
                        ),
                      ),
                    );
                    if (result == true) {
                      _fetchResumes();
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.all(15.0),
                    padding: const EdgeInsets.all(18.0),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          spreadRadius: 2.5,
                          blurRadius: 10.0,
                          offset: Offset(2, 2),
                          blurStyle: BlurStyle.inner,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['title'] ?? 'No Title',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '작성일: ${_formatDate(data['createdAt'])}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _getSelfIntroductionPreview(data['resumeItem']['selfIntroduction'] ?? ''),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}