import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:halmoney/AI_pages/AI_recomm_page.dart';
import 'package:halmoney/AI_pages/select_conditions_page.dart';
import 'package:halmoney/AI_pages/search_engine.dart';
import 'package:halmoney/screens/map/mapPage.dart';
import 'package:halmoney/screens/resume/step1_hello.dart';
import 'package:intl/intl.dart';
import 'package:halmoney/PublicJobs_pages/PublicJobsDescribe.main.dart';
import 'package:halmoney/FirestoreData/user_Info.dart';
import 'dart:core';
import 'package:halmoney/FirestoreData/PublicJobsData.dart';
import '../../PublicJobs_pages/PublicJobsDetail.main.dart';

class MyHomePage extends StatefulWidget {
  final UserInfo userInfo;

  const MyHomePage({super.key, required this.userInfo});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PublicJobsData publicJobsData = PublicJobsData();
  List<Map<String, dynamic>> publicJobs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    //_fetchUserInfo();
    _fetchJobs();
  }

  // //사용자 정보 불러오기
  // Future<void> _fetchUserInfo() async {
  //   UserInfo fetchedUserInfo = await UserInfo.create(widget.id);
  //   setState(() {
  //     userInfo = fetchedUserInfo;
  //   });
  // }

  //공공일자리 데이터 불러오기
  Future<void> _fetchJobs() async {
    List<Map<String, dynamic>> fetchedJobs = await publicJobsData.fetchPublicJobs();
    setState(() {
      publicJobs = fetchedJobs;
      isLoading = false;
    });
    print('update publicjobs list: $publicJobs');
  }


  @override
  Widget build(BuildContext context) {
    print("Public Jobs length: ${publicJobs.length}");
    List<String> mainUrls = [
      "assets/images/homeimages/public_work_page.png",
      "assets/images/homeimages/recommendation_page.png",
      "assets/images/homeimages/resume_create_page.png",
      "assets/images/homeimages/search_engine_page.png",
    ];
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'NanumGothicBold',
      ),
      home: SafeArea(
        top: true,
        left: false,
        bottom: true,
        right: false,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            //elevation: 1.0,
            title: Row(
              children: [
                Image.asset(
                  'assets/images/img_logo.png',
                  fit: BoxFit.contain,
                  height: 40,
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: const Text(
                    '할MONEY',
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
          body: ListView(children: [
            // 광고 이미지 위젯
            CarouselSlider.builder(
              itemCount: mainUrls.length,
              options: CarouselOptions(
                viewportFraction: 1.0,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 5),
                autoPlayAnimationDuration:
                const Duration(milliseconds: 3000), // 애니메이션 시간
                autoPlayCurve: Curves.fastOutSlowIn, // 슬라이드 애니메이션 곡선
              ),
              itemBuilder: (context, itemIndex, realIndex) {
                return GestureDetector(
                  onTap: () {
                    String imageUrl = mainUrls[itemIndex];
                    if ( imageUrl== "assets/images/homeimages/resume_create_page.png") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                StepHelloPage(userInfo: widget.userInfo)),
                      );
                    } else if (imageUrl =="assets/images/homeimages/recommendation_page.png") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                AIRecommPage(userInfo: widget.userInfo,)),
                      );
                    } else if (imageUrl == "assets/images/homeimages/search_engine_page.png") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SearchEngine(userInfo: widget.userInfo,)),
                      );
                    } else if (imageUrl == "assets/images/homeimages/public_work_page.png") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                PublicJobsDescribe(id: widget.userInfo.userId, userInfo: widget.userInfo)),
                      );
                    }
                  },
                  child: Image.asset(
                    mainUrls[itemIndex],
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width,
                  ),
                );
              },
            ),

            // 검색 기능
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SearchEngine(userInfo: widget.userInfo,)),
                );
              },
              child: Container(
                transform: Matrix4.translationValues(0, -10, 0),
                width: 360,
                height: 90,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      spreadRadius: 0.7,
                      blurRadius: 8.0,
                      offset: Offset(0, -2),
                      blurStyle: BlurStyle.inner,
                    ),
                  ],
                ),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    width: 360,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      border: Border.all(
                        color: const Color.fromARGB(250, 51, 51, 255),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              '원하는 일자리를 검색해보세요!',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 8.0), // Adjust the padding as needed
                          child: Icon(
                            Icons.search,
                            size: 30,
                            color: Color.fromARGB(250, 51, 51, 255),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // 이력서 생성 버튼
            Container(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              height: 370,
              color: const Color.fromARGB(50, 173, 216, 230),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  const Text(
                    '자소서를 어떻게 작성할지 모르겠다면?\n'
                        '자동으로 자소서를 만들어드려요!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StepHelloPage(userInfo: widget.userInfo)),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20.0),
                      height: 220,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Image(
                            image: AssetImage('assets/images/resume.png'),
                            width: 60,
                            height: 60,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(width: 30),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'AI가 만들어주는 자기소개서',
                                  style: TextStyle(
                                      fontSize: 17, color: Colors.black54),
                                ),
                                const SizedBox(height: 5),
                                const Text(
                                  '내가 원하는 일자리와 관련있는\n'
                                      '역량과 경험을 쉽게 작성해보아요',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  width: 230,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25.0),
                                    border: Border.all(
                                      color: const Color.fromARGB(250, 51, 51, 255),
                                    ),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      '자기소개서 작성하기',
                                      style: TextStyle(
                                          color: Color.fromARGB(250, 51, 51, 255),
                                          fontSize:18,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ]),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),

            // AI 추천 시스템
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 20.0, top: 40, bottom: 60),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  Text(
                    widget.userInfo != null && widget.userInfo!.userName.isNotEmpty
                        ? '${widget.userInfo?.getUserName()}님에게 딱맞는 일자리'
                        : '사용자 정보를 불러오는 중...',
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                AIRecommPage(userInfo: widget.userInfo,)),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20.0),
                      height: 100,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            spreadRadius: 1.0,
                            blurRadius: 10.0,
                            offset: Offset(2, 2),
                            blurStyle: BlurStyle.inner,
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '딱맞는 일자리',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          Spacer(),
                          Image(
                            image: AssetImage('assets/images/search.png'),
                            width: 60,
                            height: 60,
                            fit: BoxFit.contain,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),

            //공공일자리
            Container(
              padding: const EdgeInsets.only(left: 25.0, right: 20.0, top: 20, bottom:20),
              color: Color.fromARGB(80, 211, 211, 211),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '공공 일자리',
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextButton(
                        onPressed: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context)=> PublicJobsDescribe(id: widget.userInfo.userId, userInfo: widget.userInfo,))
                          );
                        },
                        child: Text('전체보기', style: TextStyle(color:Colors.black, fontSize: 17),),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Container(
                      height: 320,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: publicJobs.length,
                          itemBuilder:(context, index){
                            final job = publicJobs[index];

                            Timestamp? endTimestamp = job['endday'] as Timestamp?;
                            String formattedEndDate = endTimestamp != null
                                ? DateFormat('yyyy-MM-dd').format(endTimestamp.toDate())
                                : '상시모집';

                            return Padding(
                                padding: const EdgeInsets.only(right:16.0),
                                child: JobCard(
                                  image : job['image_path'] ?? 'assets/images/img_logo.png',
                                  title : job['title'] ?? '할MONEY',
                                  description: job['company'] ?? '할MONEY',
                                  region : job['region'] ?? '미정',
                                  endday: formattedEndDate,
                                  id : widget.userInfo.userId,
                                  url: job['url'] ?? '없음',
                                  person: job['person'] ?? '미정',
                                  person2: job['person2'] ?? '미정',
                                  personcareer: job['personcareer'] ?? '미정',
                                  personedu: job['personedu'] ?? '미정',
                                  applystep: job['applystep'] ?? '미정',
                                  userInfo: widget.userInfo,

                                )
                            );
                          }
                      )
                  )
                ],
              ),
            ),


            // 맞춤 검색
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 20.0, top: 40, bottom:40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    '원하는 조건 고르기',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SelectConditionsPage(userInfo: widget.userInfo,)),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Image(
                                image: AssetImage('assets/images/check.png'),
                                width: 60,
                                height: 60,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(width: 30),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height:20),
                                    const Text(
                                      '나는 이런 일을 원해요!\n'
                                          '조건을 정해 일자리를 알아보아요',
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      width: 230,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25.0),
                                        border: Border.all(
                                          color: const Color.fromARGB(250, 51, 51, 255),
                                        ),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          '조건 검색하기',
                                          style: TextStyle(
                                              color: Color.fromARGB(250, 51, 51, 255),
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                  ]),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),

            // 지역 검색 위젯
            Container(
              padding: const EdgeInsets.only(left: 25.0, right: 20.0, top: 10, bottom: 40),
              //color: Color.fromARGB(80, 211, 211, 211),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  const Text(
                    '원하는 지역 고르기',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MapScreen(userInfo: widget.userInfo,)),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Image(
                                image: AssetImage('assets/images/location.png'),
                                width: 60,
                                height: 60,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(width: 30),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height:20),
                                    const Text(
                                      '어느 곳에서 일하고 싶으신가요?\n'
                                          '원하는 지역을 골라보세요!',
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      width: 230,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25.0),
                                        border: Border.all(
                                          color: const Color.fromARGB(250, 51, 51, 255),
                                        ),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          '지역 검색하기',
                                          style: TextStyle(
                                              color: Color.fromARGB(250, 51, 51, 255),
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                  ]),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),


          ]),
        ),
      ),
    );
  }
}

class JobCard extends StatelessWidget{
  final String image;
  final String title;
  final String description;
  final String region;
  final String endday;
  final String url;
  final String person;
  final String person2;
  final String personcareer;
  final String personedu;
  final String applystep;
  final String id;
  final UserInfo userInfo;

  const JobCard({
    required this.image,
    required this.title,
    required this.description,
    required this.region,
    required this.endday,
    required this.url,
    required this.person,
    required this.person2,
    required this.personcareer,
    required this.personedu,
    required this.applystep,
    required this.id,
    required this.userInfo,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //print('Navigating to details with:');
        //print('person: $person, person2: $person2, personcareer: $personcareer, personedu: $personedu');

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PublicJobsDetail(
              id: id,
              title: title,
              company: description,
              region: region,
              url: url,
              person: person,
              person2: person2,
              personcareer: personcareer,
              personedu: personedu,
              applystep: applystep,
              image_path: image,
              endday: endday,
              userInfo: userInfo,
            ),
          ),
        );
      },

      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        width: 250,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3), // Shadow position
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10.0), // 여백 추가
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: Center(child: Image.asset(image, height: 100)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(13.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description, // Could be company or another field
                    style: const TextStyle(fontSize: 17),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '지역: $region',
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '마감일: $endday',
                    style: const TextStyle(fontSize: 16, color: Color.fromARGB(250, 51, 51, 255)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}