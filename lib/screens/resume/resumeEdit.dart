import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:halmoney/screens/resume/resumeManage.dart';
import 'package:halmoney/screens/resume/user_prompt_factor.dart';
import 'package:halmoney/get_user_info/career.dart';

import '../../FirestoreData/user_Info.dart';

//이력서 데이터
class ResumeItem {
  late String name;
  late String gender;
  late String ageGroup;
  late String address;
  late String phone;
  late List<Career> careers;
  late String selfIntroduction;

  ResumeItem({
    required this.name,
    required this.gender,
    required this.ageGroup,
    required this.address,
    required this.phone,
    required this.careers,
    required this.selfIntroduction,
  });

  //이력서 데이터를 Map으로 변환하는 함수
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'gender': gender,
      'agegroup': ageGroup,
      'address': address,
      'phone': phone,
      'workExperiences': careers.map((e) => e.toMap()).toList(),
      'selfIntroduction': selfIntroduction,
    };
  }
}

class ResumeEdit extends StatefulWidget {
  final UserInfo userInfo;
  final UserPromptFactor userPromptFactor;
  final String userSelfIntroduction;

  const ResumeEdit({
    Key? key,
    required this.userInfo,
    required this.userPromptFactor,
    required this.userSelfIntroduction,
  }) : super(key: key);

  @override
  _ResumeEditState createState() => _ResumeEditState();
}

class _ResumeEditState extends State<ResumeEdit> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late ResumeItem resumeItem;
  final TextEditingController _selfIntroductionController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchResumeData();
    _selfIntroductionController.text = resumeItem.selfIntroduction;
    _selfIntroductionController.addListener(() {
      setState(() {
        resumeItem.selfIntroduction = _selfIntroductionController.text;
      });
    });
  }

  //사용자 정보 불러오기
  Future<void> _fetchResumeData() async {
    final String name = widget.userInfo.getUserName();
    final String ageGroup = widget.userInfo.getUserAgeGroup();
    final String gender = widget.userInfo.getUserGender();
    final String address = widget.userInfo.getUserAddress();
    final String phone = widget.userInfo.gerUserPhone();
    final List<Career> careers = widget.userPromptFactor.getCareers();
    final String selfIntroduction = widget.userSelfIntroduction;

    setState(() {
      resumeItem = ResumeItem(
        name: name,
        gender: gender,
        ageGroup: ageGroup,
        address: address,
        phone: phone,
        careers: careers,
        selfIntroduction: selfIntroduction,
      );
    });
  }

  // 이력서 저장
  Future<void> _saveResume(String title) async {
    // Update selfIntroduction before saving
    resumeItem.selfIntroduction = _selfIntroductionController.text;

    final QuerySnapshot result = await _firestore
        .collection('user')
        .where('id', isEqualTo: widget.userInfo.userId)
        .get();
    final List<DocumentSnapshot> documents = result.docs;

    if (documents.isNotEmpty) {
      final String docId = documents.first.id;

      try {
        final CollectionReference resumesCollection =
            _firestore.collection('user').doc(docId).collection('resumes');

        final DocumentReference newResume = resumesCollection.doc();

        await newResume.set({
          'title': title,
          'resumeItem': resumeItem.toMap(),
          'createdAt': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Resume saved successfully")),
        );
      } catch (error) {
        print("Failed to save resume data: $error");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to save resume data: $error")),
        );
      }
    }
    for (int i = 0; i < 8; i++) {
      Navigator.of(context).pop();
    }
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ResumeManage(userInfo: widget.userInfo)));
  }

  // 앱 바 뒤로가기 버튼
  Future<bool> _goBack() async {
    return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('이력서 작성을 취소하시겠습니까?'),
              content: Text('지금까지 작성한 이력서는 저장되지 않습니다.'),
              actions: <Widget>[
                TextButton(
                  child: Text('취소'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                ElevatedButton(
                  child: Text('확인'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        ) ??
        false;
  }

  //안드로이드 뒤로가기 버튼
  Future<bool> _onWillPop() async {
    return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text(
                '이력서 작성을 취소하시겠습니까?',
                style: TextStyle(
                  fontFamily: 'NanumGothicFamily',
                ),
              ),
              content: const Text(
                '지금까지 작성한 이력서는 저장되지 않습니다.',
                style: TextStyle(
                  fontFamily: 'NanumGothicFamily',
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text(
                    '취소',
                    style: TextStyle(
                      fontFamily: 'NanumGothicFamily',
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                ElevatedButton(
                  child: Text(
                    '확인',
                    style: TextStyle(
                      fontFamily: 'NanumGothicFamily',
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        ) ??
        false;
  }

  // 이력서 제목 입력받는 팝업창
  Future<void> _showSaveDialog() async {
    TextEditingController _titleController = TextEditingController();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            '이력서 제목을 입력하세요',
            style: TextStyle(
              fontFamily: 'NanumGothicFamily',
            ),
          ),
          content: TextField(
            style: TextStyle(
              fontFamily: 'NanumGothicFamily',
            ),
            controller: _titleController,
            decoration: InputDecoration(
              hintText: '이력서 제목',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                '취소',
                style: TextStyle(
                  fontFamily: 'NanumGothicFamily',
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text(
                '확인',
                style: TextStyle(
                  fontFamily: 'NanumGothicFamily',
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _saveResume(_titleController.text);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Theme(
          data: Theme.of(context).copyWith(
            textTheme: Theme.of(context).textTheme.apply(
                  fontFamily: 'NanumGothicFamily',
                ),
          ),
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: const Color.fromARGB(250, 51, 51, 255),
              automaticallyImplyLeading: false,
              title: const Text('이력서 작성'),
              centerTitle: true,
              elevation: 1.0,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: _goBack,
              ),
            ),
            body: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                  child: ListView(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      // 개인정보란
                      Row(
                        children: [
                          const SizedBox(
                            width: 5,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                resumeItem.name,
                                style: TextStyle(
                                  fontSize: 30,
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                resumeItem.gender,
                                style: TextStyle(
                                  fontSize: 25,
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                resumeItem.ageGroup,
                                style: TextStyle(
                                  fontSize: 25,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      // 주소, 전화번호란
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '주소',
                                style: TextStyle(fontSize: 20),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                '전화번호',
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                resumeItem.address,
                                style: TextStyle(fontSize: 20),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                resumeItem.phone,
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(),

                      // 경력란
                      resumeItem.careers.length == 0
                          ? Container()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                const Text(
                                  '경력 사항',
                                  style: TextStyle(fontSize: 20),
                                ),
                                
                                //추후에 수정
                                const SizedBox(height: 10),
                                Column(
                                  children: resumeItem.careers.map((experience) {
                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10.0),
                                      padding: const EdgeInsets.all(15.0),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            '${experience.workPlace}',
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            '근무 기간   ${experience.workDuration}${experience.workUnit}',
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                                Divider(),
                              ],
                            ),

                      // 자기소개서
                      const SizedBox(height: 10),
                      const Text(
                        '자기소개서',
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _selfIntroductionController,
                        maxLines: 15,
                        style: TextStyle(
                          fontSize: 20,
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: '자기소개서를 입력하세요',
                        ),
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 15,
                  left: 15,
                  child:ElevatedButton(
                    onPressed: _showSaveDialog,
                    child: const Text('저장하기',
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(250, 51, 51, 255),
                      minimumSize: const Size(360, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
