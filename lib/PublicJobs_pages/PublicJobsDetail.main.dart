import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:halmoney/resume2/resumeManage2.dart';
import 'PublicJobsCheck_page.dart';
import 'package:halmoney/FirestoreData/user_Info.dart';

class PublicJobsDetail extends StatelessWidget {
  final String id;
  final String title;
  final String company;
  final String region;
  final String url;
  final String person;
  final String person2;
  final String personcareer;
  final String personedu;
  final String applystep;
  final String image_path;
  final String endday;
  final UserInfo userInfo;

  PublicJobsDetail({
    required this.id,
    required this.title,
    required this.company,
    required this.region,
    required this.url,
    required this.person,
    required this.person2,
    required this.personcareer,
    required this.personedu,
    required this.applystep,
    required this.image_path,
    required this.endday,
    required this.userInfo,
    super.key,
  });

  Future<void> _launchURL() async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 5.0,
          title: Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back_ios_rounded),
                color: Colors.grey,
              ),
              Image.asset(
                'assets/images/img_logo.png',
                fit: BoxFit.contain,
                height: 40,
              ),
              Container(
                padding: const EdgeInsets.all(10.0),
                child: const Text(
                  '채용정보',
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
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 30.0, right: 25.0, top: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.asset(
                            image_path,
                            height: 185,
                            width: 350,
                            fit: BoxFit.cover,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          '주관 업체',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          company,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Divider(thickness: 1, height: 1, color: Colors.grey),
                    const SizedBox(height: 20),
                    const Text(
                      '근무조건',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Text(
                          '근무 지역',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(width: 25),
                        Text(
                          region,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text(
                          '근무 내용',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(width: 25),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,  // Enable horizontal scrolling
                            child: Text(
                              title,
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Divider(thickness: 1, height: 1, color: Colors.grey),
                    const SizedBox(height: 20),
                    const Text(
                      '상세요강',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      applystep,
                      style: const TextStyle(
                        height: 1.8,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 40),
                    const Divider(thickness: 1, height: 1, color: Colors.grey),
                    const SizedBox(height: 20),
                    const Text(
                      '필요조건',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '응시자격',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height:10.0),
                        Text(
                          person,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 30),

                        const Text(
                          '결격사유',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height:10.0),
                        Text(
                          person2,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 30),

                        const Text(
                          '경력',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height:10.0),
                        Text(
                          personcareer,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 30),

                        const Text(
                          '학력',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height:10.0),
                        Text(
                          personedu,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 15,
              left: 15,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ElevatedButton(
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: const Color.fromARGB(250, 51, 51, 255),
                  //     padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 13),
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(8),
                  //     ),
                  //   ),
                  //   onPressed: _launchURL, // Open the provided URL
                  //   child: const Text(
                  //     '지원하기',
                  //     style: TextStyle(
                  //       fontSize: 15,
                  //       color: Colors.white,
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 100, 100, 255),
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PublicJobsCheckPage(
                            id: id,
                            title: title,
                            region: region,
                            career: personcareer,
                            requirementsText: person,
                            applystep:applystep,
                            userInfo: userInfo,// Text for question generation
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      '자격요건 간편확인 및 이력서 생성',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
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