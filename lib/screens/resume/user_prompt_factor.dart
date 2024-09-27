//작성자 : 황제하

import 'dart:async';
import 'package:halmoney/get_user_info/career.dart';
import 'package:halmoney/FirestoreData/user_Info.dart';

class UserPromptFactor {
  late UserInfo userInfo;
  late List<String> selectedFields;
  late List<Career> careers;
  List<String> selectedStrens = [];
  int quantity = 0;

  UserPromptFactor._create(this.userInfo);

  static Future<UserPromptFactor> create(UserInfo userInfo) async{
    UserPromptFactor userPromptFactor = UserPromptFactor._create(userInfo);
    await userPromptFactor._fetchUserPromptFactor(userInfo);
    return userPromptFactor;
  }

  Future<void> _fetchUserPromptFactor(UserInfo userInfo) async {
    try {
      this.userInfo = userInfo;
      selectedFields = userInfo.getSelectedFields();
      careers = userInfo.getCareers();
    } catch (error) {
      print('Failed to fetch user info: $error');
    }
  }

  // 지원 분야 메소드
  void editSelectedFields(List<String> selectedFields) {
    this.selectedFields = selectedFields;
  }
  List<String> getSelctedFields() {
    return selectedFields;
  }

  // 경력 메소드
  void editCareers(List<Career> careers) {
    this.careers = careers;
  }
  List<Career> getCareers() {
    return careers;
  }
  String getCareersString() {
    String result = '';
    for (Career career in careers) {
      result += career.getStringCareer()+'\n';
    }
    return result;
  }

  // 역량 메소드
  void editSelectedStrens(List<String> selectedStrens) {
    this.selectedStrens = selectedStrens;
  }
  List<String> getSelectedStrens() {
    return selectedStrens;
  }

  // 분량 메소드
  void editQuantity(int quantity) {
    this.quantity = quantity;
  }
  int getQuantity() {
    return quantity;
  }
}
