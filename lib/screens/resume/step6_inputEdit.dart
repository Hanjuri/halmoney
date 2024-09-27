// 사용자 입력값 수정하는 페이지
// 나중에 추가할 기능
// 우선 기능 생략한 채로 사용

// import 'package:flutter/material.dart';
// import 'package:halmoney/get_user_info/user_Info.dart';
// import 'package:halmoney/get_user_info/career.dart';
// import 'package:halmoney/screens/resume/step2_field.dart';
// import 'package:halmoney/screens/resume/step3_stren.dart';
// import 'package:halmoney/screens/resume/step4_career.dart';
// import 'package:halmoney/screens/resume/step5_quantity.dart';
//
// class StepInputEditPage extends StatefulWidget{
//   final UserInfo userInput;
//
//   StepInputEditPage({
//     super.key,
//     required this.userInput,
//
//   });
//
//   @override
//   State<StepInputEditPage> createState() => _StepInputEditPageState();
// }
//
// class _StepInputEditPageState extends State<StepInputEditPage> {
//   //사용자 입력 값 임시 저장 변수
//   List<String> selectedFields = [];
//   List<String> selectedStrens = [];
//   List<Career> careers = [];
//   int quantity = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     // userInput으로부터 현재 사용자 입력값 받아오기
//     selectedFields = List.from(widget.userInput.selectedFields);
//     selectedStrens = List.from(widget.userInput.selectedStrens);
//     careers = List.from(widget.userInput.careers);
//     //quantity = widget.userInput.quantity;
//   }
//
//   void saveChanges() {
//     // 수정된 값 저장하기
//     widget.userInput.editSelectedFields(selectedFields);
//     widget.userInput.editSelectedStrens(selectedStrens);
//     widget.userInput.editCareers(careers);
//     //widget.userInput.editQuantity(quantity);
//
//     Navigator.pop(context);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 1.0,
//         title: Row(
//           children: [
//             Image.asset(
//               'assets/images/img_logo.png',
//               fit: BoxFit.contain,
//               height: 40,
//             ),
//             Container(
//                 padding: const EdgeInsets.all(8.0),
//                 child: const Text(
//                   '할MONEY',
//                   style: TextStyle(
//                     fontFamily: 'NanumGothicFamily',
//                     fontWeight: FontWeight.w600,
//                     fontSize: 18.0,
//                     color: Colors.black,
//                   ),
//                 )),
//           ],
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.only(
//             left: 25.0, right: 25.0, top: 25.0, bottom: 15.0),
//         child: Column(
//           children: [
//             // 페이지 이동 영역
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 // 이전 페이지로 이동
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.pop(context);
//                   },
//                   child: const Row(
//                     children: [
//                       Icon(
//                         Icons.chevron_left,
//                         size: 30,
//                       ),
//                       Text('이전',
//                           style: TextStyle(
//                             fontFamily: 'NanumGothicFamily',
//                             fontSize: 20.0,
//                             color: Colors.black,
//                           )),
//                     ],
//                   ),
//                 ),
//
//                 //다음 페이지로 이동
//                 GestureDetector(
//                   onTap: () {
//                     saveChanges();
//                     /*
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => StepCareerPage(
//                               userInput : widget.userInput
//                           )),
//                     );*/
//                   },
//                   child: const Row(
//                     children: [
//                       Text('생성하기',
//                           style: TextStyle(
//                             fontFamily: 'NanumGothicFamily',
//                             fontSize: 20.0,
//                             color: Colors.black,
//                           )),
//                       Icon(
//                         Icons.chevron_right,
//                         size: 30,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//
//             const SizedBox(
//               height: 20,
//             ),
//
//             Expanded(
//               child: Column(
//                 children: [
//                   const Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Text('입력한 정보를 확인해 주세요',
//                           style: TextStyle(
//                             fontFamily: 'NanumGothicFamily',
//                             fontWeight: FontWeight.w500,
//                             fontSize: 28.0,
//                             color: Colors.black,
//                           )),
//                     ],
//                   ),
//                   const SizedBox(height: 5),
//                   const Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Flexible(
//                         child: Text('아래의 정보를 바탕으로 자기소개서가 생성됩니다',
//                             softWrap: true,
//                             style: TextStyle(
//                               fontFamily: 'NanumGothicFamily',
//                               fontWeight: FontWeight.w500,
//                               fontSize: 20.0,
//                               color: Colors.black,
//                             )),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 15),
//
//                   //수정기능
//                   Expanded(
//                     child: ListView(
//                       children: [
//                         // Selected Fields
//                         ListTile(
//                           title: Text('희망 직무'),
//                           subtitle: Text(selectedFields.join(', ')),
//                           trailing: Icon(Icons.edit),
//                           // onTap: () async {
//                           //   final fields = await Navigator.push(
//                           //     context,
//                           //     MaterialPageRoute(
//                           //       builder: (context) => StepFieldPage(
//                           //           userPromptFactor: widget.userInput),
//                           //     ),
//                           //   );
//                           //   if (fields != null) {
//                           //     setState(() {
//                           //       selectedFields = fields;
//                           //     });
//                           //   }
//                           // },
//                         ),
//                         Divider(),
//
//                         // Selected Strengths
//                         ListTile(
//                           title: Text('장점'),
//                           subtitle: Text(selectedStrens.join(', ')),
//                           trailing: Icon(Icons.edit),
//                           onTap: () async {
//                             final strens = await Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => StepStrenPage(
//                                     userInfo: widget.userInput),
//                               ),
//                             );
//                             if (strens != null) {
//                               setState(() {
//                                 selectedStrens = strens;
//                               });
//                             }
//                           },
//                         ),
//                         Divider(),
//
//                         // Careers
//                         ListTile(
//                           title: Text('경력'),
//                           subtitle: Text(careers
//                               .map((career) => career.toString())
//                               .join(', ')),
//                           trailing: Icon(Icons.edit),
//                           onTap: () async {
//                             final updatedCareers = await Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) =>
//                                     StepCareerPage(userInfo: widget.userInput),
//                               ),
//                             );
//                             if (updatedCareers != null) {
//                               setState(() {
//                                 careers = updatedCareers;
//                               });
//                             }
//                           },
//                         ),
//                         Divider(),
//
//                         // Quantity
//                         ListTile(
//                           title: Text('자기소개서 분량'),
//                           subtitle: Text(quantity.toString()),
//                           trailing: Icon(Icons.edit),
//                           onTap: () async {
//                             final updatedQuantity = await Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) =>
//                                     StepQuantityPage(userInfo: widget.userInput),
//                               ),
//                             );
//                             if (updatedQuantity != null) {
//                               setState(() {
//                                 quantity = updatedQuantity;
//                               });
//                             }
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
