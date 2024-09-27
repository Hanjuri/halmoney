import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class CallButton extends StatelessWidget {
  final String callnumber;
  const CallButton({super.key, required this.callnumber});


  Widget build(BuildContext context){
    print(callnumber);

    return   ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(250, 51, 51, 255), // 버튼의 배경색을 파란색으로 설정
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),

      onPressed: _makePhoneCall,
      child: Text(
        '전화걸기',
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      ),
    );
  }
  void _makePhoneCall() async{
    final phoneNumber = 'tel:$callnumber';

    if (await canLaunch(phoneNumber)){
      await launch(phoneNumber);
    } else {
      throw '연결불가:$phoneNumber';
    }
  }
}