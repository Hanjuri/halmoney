import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:halmoney/FirestoreData/user_Info.dart';
import 'package:intl/intl.dart';
import 'PublicJobsDetail.main.dart';
import '../FirestoreData/PublicJobsData.dart';



class PublicJobList extends StatelessWidget {
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
  final bool isLiked;
  final String image_path;
  final String endday;
  final UserInfo userInfo;

  const PublicJobList({
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
    required this.isLiked,
    required this.image_path,
    required this.endday,
    required this.userInfo,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(  // GestureDetector로 클릭 이벤트 감지
      onTap: () {
        // 클릭했을 때 상세 페이지로 이동
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PublicJobsDetail(
              id: id,
              title: title,
              company: company,
              region: region,
              url: url,
              person: person,
              person2: person2,
              personcareer: personcareer,
              personedu: personedu,
              applystep: applystep,
              image_path: image_path,
              endday: endday,
              userInfo: userInfo,
            ),
          ),
        );
      },
      child: SizedBox(
        height: 150,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    image: AssetImage(image_path),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      company,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '마감일: $endday',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
