// import 'package:flutter/material.dart';
// import 'package:halmoney/resume2/select_stren_page2.dart';
//
// class SelectSkillPage extends StatefulWidget {
//   final String id;
//   final String title;
//
//   const SelectSkillPage({
//     required this.id,
//     required this.title,
//     super.key,
//   });
//
//   @override
//   State<SelectSkillPage> createState() => _SelectSkillPageState();
// }
//
// class _SelectSkillPageState extends State<SelectSkillPage>{
//   final List<String> selectedSkills=[];
//
//   void updateSelectedSkills(List<String> skills) {
//     setState(() {
//       selectedSkills.clear();
//       selectedSkills.addAll(skills);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 1.0,
//         title: Row(
//           //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
//                   style : TextStyle(
//                     fontFamily: 'NanumGothicFamily',
//                     fontWeight: FontWeight.w600,
//                     fontSize: 18.0,
//                     color: Colors.black,
//                     //Color.fromARGB(250, 51, 51, 255),
//                 ),)
//             ),
//           ],
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.only(left:25.0, right:30.0, top:50.0),
//         child: Column(
//           children: [
//             const Text(
//               '이력서에 추가할 본인의 스킬을 선택해주세요!',
//               style: TextStyle(
//                 fontSize: 18.0,
//                 fontFamily: 'NanumGothic',
//                 fontWeight: FontWeight.w600),
//             ),
//
//             const SizedBox(height: 30),
//
//             Expanded(
//               child: SkillChooseButton(
//                 selectedSkills: selectedSkills,
//                 onSelectedSkillsChanged: updateSelectedSkills,
//               ),
//             ),
//
//             const SizedBox(height: 30),
//
//             const TextField(
//               decoration: InputDecoration(
//                 labelText: '기타 스킬을 작성해주세요'
//               ),
//             ),
//
//             const SizedBox(height:30),
//
//             ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   //backgroundColor: _buttonActive ? const Color.fromARGB(250, 51, 51, 255) : Colors.grey,
//                     backgroundColor: const Color.fromARGB(250, 51, 51, 255),
//                     minimumSize: const Size(360,50),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     )
//                 ),
//                 onPressed: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => SelectStrenPage(
//                           id : widget.id,
//                           title:widget.title,
//                           selectedSkills: selectedSkills
//                         ),
//                       )
//                   );
//                 },
//                 child: const Text('다음 페이지로 이동',style: TextStyle(color: Colors.white),),
//               ),
//
//             const SizedBox(height:20),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class SkillChooseButton extends StatefulWidget{
//   final List<String> selectedSkills;
//   final ValueChanged<List<String>> onSelectedSkillsChanged;
//
//   const SkillChooseButton({
//     super.key,
//     required this.selectedSkills,
//     required this.onSelectedSkillsChanged,
//   });
//
//   @override
//   State<SkillChooseButton> createState() => _SkillChooseButtonState();
// }
//
// class _SkillChooseButtonState extends State<SkillChooseButton>{
//   //출력할 스킬 목록
//   var skills =['IT업무', '학생관리','고객상담','주방보조','빵 포장','식사 지도','사무보조',
//   '사업경영','청소','자격증보유','커피제조','요리','건축/건설','디자인업무','교육','요양/사회복지',
//   '배달/포장','서빙','생산직','용접','기타'];
//   //선택한 스킬을 담을 LIST
//   //List<String> skillList = List<String>();
//
//   void toggleSkill(String skill){
//     setState(() {
//       if(widget.selectedSkills.contains(skill)){
//         widget.selectedSkills.remove(skill);
//       }else{
//         widget.selectedSkills.add(skill);
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context){
//     var size = MediaQuery.of(context).size;
//     const double itemHeight = 100;
//     final double itemWidth = size.width/2;
//
//     return GridView.builder(
//
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount : 3,
//         crossAxisSpacing : 16.0,
//         mainAxisSpacing : 16.0,
//         childAspectRatio: (itemWidth/itemHeight)
//       ),
//         itemCount: skills.length,
//         itemBuilder: (context, index){
//           final skill = skills[index];
//           final isSelected = widget.selectedSkills.contains(skill);
//
//           return ButtonTheme(
//               minWidth: 100.0,
//               height: 50.0,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                     backgroundColor: isSelected ? Colors.blue : Colors.white70,
//                     foregroundColor: Colors.black54,
//                     shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12))
//             ),
//                 onPressed: () => toggleSkill(skill),
//                 child: Text(skill, style: const TextStyle(fontWeight: FontWeight.w600),),
//           )
//           );
//         },
//     );
//   }
// }
// //void main(){
// //  runApp(const MaterialApp(home:SelectSkillPage()));
// //}
//
