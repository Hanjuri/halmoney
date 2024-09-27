// 작성자 : 황제하
// 사용자 기본 정보를 불러오고 수정하는 클래스

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:halmoney/get_user_info/career.dart';

class UserInfo {
  late String userName;
  late String userId;
  late String userPhone;
  late String userGender;
  late String userAgeGroup;
  late String userAddress;
  late List<Career> careers;
  late List<String> selectedFields;
  late String preferredWorkTime;
  late String preferredWorkPlace;

  UserInfo._create(this.userId);

  static Future<UserInfo> create(String userId) async{
    UserInfo userInfo = UserInfo._create(userId);
    await userInfo._fetchUserInfo(userId);
    return userInfo;
  }

  //사용자 기본 정보 불러오기
  Future<void> _fetchUserInfo(String userId) async {
    try {
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('user')
          .where('id', isEqualTo: userId)
          .get();

      final List<DocumentSnapshot> documents = result.docs;

      if (documents.isNotEmpty) {
        final String docId = documents.first.id;

        final DocumentSnapshot ds =
        await FirebaseFirestore.instance.collection('user').doc(docId).get();

        final data = ds.data() as Map<String, dynamic>;

        userName = data['name'] ?? '';
        this.userId = userId;
        userPhone = data['phone'] ?? '';
        userGender = data['gender'] ?? '';
        userAgeGroup = data['ageGroup'] ?? '';
        userAddress = data['address'] ?? '';

        final DocumentSnapshot careerDoc = await FirebaseFirestore.instance
            .collection('user')
            .doc(docId)
            .collection('Career')
            .doc('career')
            .get();

        if (careerDoc.exists) {
          final careerData = careerDoc.data() as Map<String, dynamic>;
          if (careerData['careers'] != null && careerData['careers'] is List) {
            careers = (careerData['careers'] as List)
                .map((career) => Career.fromMap(career as Map<String, dynamic>))
                .toList();
          } else {
            careers = [];
          }
        } else {
          careers = [];
        }

        // Fetch interest information
        final DocumentSnapshot interestDoc = await FirebaseFirestore.instance
            .collection('user')
            .doc(docId)
            .collection('Interest')
            .doc('interest')
            .get();

        if (interestDoc.exists) {
          final interestData = interestDoc.data() as Map<String, dynamic>;
          selectedFields = interestData['selectedFields'] != null
              ? List<String>.from(interestData['selectedFields'])
              : [];
          preferredWorkTime = interestData['preferredWorkTime'] ?? '';
          preferredWorkPlace = interestData['preferredWorkPlace'] ?? '';
        } else {
          selectedFields = [];
          preferredWorkTime = '';
          preferredWorkPlace = '';
        }
      }
    } catch (error) {
      print('Failed to fetch user info: $error');
    }
  }

  // 회원가입 후 사용자 정보 조사 메소드
  Future<void> setUserInfo() async {
    try {
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('user')
          .where('id', isEqualTo: userId)
          .get();

      final List<DocumentSnapshot> documents = result.docs;

      if (documents.isNotEmpty) {
        final String docId = documents.first.id;

        // 경력 정보
        await FirebaseFirestore.instance
            .collection('user')
            .doc(docId)
            .collection('Career')
            .doc('career')
            .set({
          'careers': careers.map((career) => career.toMap()).toList(),
        });

        //관심 정보
        await FirebaseFirestore.instance
            .collection('user')
            .doc(docId)
            .collection('Interest')
            .doc('interest')
            .set({
          'inter_place': preferredWorkPlace, // 추천시스템에서 활용하는 정보일까봐
          'preferredWorkPlace': preferredWorkPlace, // inter_place와 같은 정보인데 우선 두 개 만듦
          'preferredWorkTime': preferredWorkTime,
          'selectedFields': selectedFields,
        });
      }
      print('User info updated successfully.');
    } catch (error) {
      print('Failed to update user info: $error');
    }
  }

  // 사용자 정보 수정할 수 있는 메소드 구현하기
  // 사용자 정보 업데이트 메소드
  // Future<void> updateUserInfo() async {
  //   try {
  //     final QuerySnapshot result = await FirebaseFirestore.instance
  //         .collection('user')
  //         .where('id', isEqualTo: userId)
  //         .get();
  //
  //     final List<DocumentSnapshot> documents = result.docs;
  //
  //     if (documents.isNotEmpty) {
  //       final String docId = documents.first.id;
  //
  //       // 기본 정보
  //       await FirebaseFirestore.instance
  //           .collection('user')
  //           .doc(docId)
  //           .update({
  //         'name': userName,
  //         'phone': userPhone,
  //         'gender': userGender,
  //         'ageGroup': userAgeGroup,
  //         'address': userAddress,
  //         'careers': careers.map((career) => career.toMap()).toList(),
  //       });
  //
  //       //관심 정보
  //       await FirebaseFirestore.instance
  //           .collection('user')
  //           .doc(docId)
  //           .collection('Interest')
  //           .doc('interest')
  //           .update({
  //         'inter_place': preferredWorkPlace,
  //         'preferredWorkTime': preferredWorkTime,
  //         'preferredWorkPlace': preferredWorkPlace,
  //         'selectedFields': selectedFields,
  //       });
  //       await FirebaseFirestore.instance
  //           .collection('user')
  //           .doc(docId)
  //           .collection('Interest')
  //           .doc('interest_place')
  //           .update({'inter_place': preferredWorkPlace
  //       });
  //     }
  //     print('User info updated successfully.');
  //   } catch (error) {
  //     print('Failed to update user info: $error');
  //   }
  // }

  String getId() {
    return userId;
  }
  String getUserName() {
    return userName;
  }
  String getUserAddress(){
    return userAddress;
  }
  String gerUserPhone(){
    return userPhone;
  }
  String getUserGender(){
    return userGender;
  }
  String getUserAgeGroup(){
    return userAgeGroup;
  }

  // 지원 분야 메소드
  void editSelectedFields(List<String> selectedFields) {
    this.selectedFields = selectedFields;
  }
  List<String> getSelectedFields() {
    return selectedFields;
  }

  // 경력 메소드
  void editCareers(List<Career> careers) {
    this.careers = careers;
  }
  List<Career> getCareers() {
    return careers;
  }

  //userInfo 디버깅
  void printUserInfo(){
    print("사용자 이름 : $userName");
    print("사용자 번호 : $userPhone");
    print("사용자 성별 : $userGender");
    print("사용자 나이 : $userAgeGroup");
    print("사용자 주소 : $userAddress");
    print("사용자 선호 근무 지역 : $preferredWorkPlace");
    print("사용자 선호 근무 시간 : $preferredWorkTime");
    print("사용자 관심 분야 : $selectedFields");
    print("사용자 경력 : ${careers[0].getStringCareer()}");
  }
}