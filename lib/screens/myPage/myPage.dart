import 'package:flutter/material.dart';
import 'package:halmoney/screens/resume/resumeManage.dart';
import 'package:halmoney/screens/scrap/UserLikes.dart';
import 'package:halmoney/screens/scrap/UserViewedJobs.dart';
import '../../FirestoreData/user_Info.dart';

class MyPageScreen extends StatefulWidget {
  final UserInfo userInfo;
  const MyPageScreen({super.key, required this.userInfo});

  @override
  _MyPageScreenState createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  late String name;

  @override
  void initState() {
    super.initState();
    name = widget.userInfo.userName;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'NanumGothicBold'),
      home: SafeArea(
        top: true,
        left: false,
        bottom: true,
        right: false,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 1.0,
            title: Row(
              children: [
                Image.asset(
                  'assets/images/img_logo.png',
                  fit: BoxFit.contain,
                  height: 40,
                ),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  child: const Text(
                    '마이페이지',
                    style: TextStyle(
                      fontFamily: 'NanumGothicFamily',
                      fontWeight: FontWeight.w600,
                      fontSize: 18.0,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: ListView(
            children: [
              const Divider(),
              const SizedBox(height: 50),
              // 개인정보란
              Row(
                children: [
                  const SizedBox(width: 30),
                  Text(
                    '$name 님 안녕하세요',
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 60),
              // 마이페이지 메뉴
              GridView.count(
                shrinkWrap: true,
                primary: false,
                crossAxisCount: 2,
                childAspectRatio: 4 / 3,
                children: <Widget>[
                  // 이력서 관리
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ResumeManage(userInfo: widget.userInfo)),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(left: 20),
                      padding: const EdgeInsets.all(20),
                      height: 50,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          bottom: BorderSide(color: Colors.grey),
                          top: BorderSide(color: Colors.grey),
                          right: BorderSide(color: Colors.grey),
                        ),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.edit_note,
                            size: 50,
                          ),
                          SizedBox(height: 10),
                          Text(
                            '이력서 관리',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 지원현황
                  GestureDetector(
                    onTap: () {

                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 20),
                      padding: const EdgeInsets.all(20),
                      height: 50,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          bottom: BorderSide(color: Colors.grey),
                          top: BorderSide(color: Colors.grey),
                        ),
                      ),
                      child:  Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/img_logo.png',
                            fit: BoxFit.contain,
                            height: 100,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 찜 목록
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UserLikesScreen(id: widget.userInfo.userId)),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(left: 20),
                      padding: const EdgeInsets.all(20),
                      height: 50,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          bottom: BorderSide(color: Colors.grey),
                          right: BorderSide(color: Colors.grey),
                        ),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.favorite_border_rounded,
                            size: 50,
                          ),
                          SizedBox(height: 10),
                          Text(
                            '찜 목록',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 최근 본 공고
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UserViewedJobsPage(userId: widget.userInfo.userId)),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 20),
                      padding: const EdgeInsets.all(20),
                      height: 50,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          bottom: BorderSide(color: Colors.grey),
                        ),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 50,
                          ),
                          SizedBox(height: 10),
                          Text(
                            '최근 본 공고',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
