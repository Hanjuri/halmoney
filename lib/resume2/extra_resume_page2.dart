// import 'package:flutter/material.dart';
// import 'package:halmoney/resume2/resumeEdit2.dart';
//
// class ExtraResumePage extends StatefulWidget {
//   final String id;
//   final String title;
//   final List<String> selectedSkills;
//   final List<String> selectedStrens;
//
//   const ExtraResumePage(
//       {super.key, required this.id, required this.selectedSkills, required this.selectedStrens, required this.title});
//
//   @override
//   State<ExtraResumePage> createState() => _ExtraResumePageState();
// }
//
// class _ExtraResumePageState extends State<ExtraResumePage> {
//   List<WorkExperience> workExperiences = [];
//
//   void addWorkExperience() {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return WorkExperienceDialog(
//           onSave: (newExperience) {
//             setState(() {
//               workExperiences.add(newExperience);
//             });
//           },
//         );
//       },
//     );
//   }
//
//   void editWorkExperience(int index) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return WorkExperienceDialog(
//           experience: workExperiences[index],
//           onSave: (updatedExperience) {
//             setState(() {
//               workExperiences[index] = updatedExperience;
//             });
//           },
//         );
//       },
//     );
//   }
//
//   void removeWorkExperience(int index) {
//     setState(() {
//       workExperiences.removeAt(index);
//     });
//   }
//
//   bool areAllFieldsFilled() {
//     for (var experience in workExperiences) {
//       if (experience.startYear.isEmpty ||
//           experience.startMonth.isEmpty ||
//           experience.endYear.isEmpty ||
//           experience.endMonth.isEmpty ||
//           experience.place.isEmpty ||
//           experience.description.isEmpty) {
//         return false;
//       }
//     }
//     return true;
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
//               padding: const EdgeInsets.all(8.0),
//               child: const Text(
//                 '할MONEY',
//                 style: TextStyle(
//                   fontFamily: 'NanumGothicFamily',
//                   fontWeight: FontWeight.w600,
//                   fontSize: 18.0,
//                   color: Colors.black,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.only(left: 25.0, right: 30.0, top: 50.0),
//         child: Column(
//           children: [
//             const Text(
//               '이력사항을 입력해주세요!',
//               style: TextStyle(
//                 fontSize: 18.0,
//                 fontFamily: 'NanumGothic',
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             const SizedBox(height: 15),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: workExperiences.length + 1,
//                 itemBuilder: (context, index) {
//                   if (index == workExperiences.length) {
//                     return Padding(
//                       padding: const EdgeInsets.only(bottom: 10.0),
//                       child: Center(
//                         child: GestureDetector(
//                           onTap: addWorkExperience,
//                           child: Container(
//                             height: 80,
//                             width: double.infinity,
//                             alignment: Alignment.center,
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               border: Border.all(color: Colors.grey),
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Icon(Icons.add, color: Colors.blue),
//                                 SizedBox(width: 10),
//                                 Text('경력 추가', style: TextStyle(color: Colors.blue)),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   } else {
//                     return Padding(
//                       padding: const EdgeInsets.only(bottom: 10.0),
//                       child: WorkExperienceDisplay(
//                         experience: workExperiences[index],
//                         onEdit: () => editWorkExperience(index),
//                         onRemove: () => removeWorkExperience(index),
//                       ),
//                     );
//                   }
//                 },
//               ),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: areAllFieldsFilled()
//                   ? () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => ResumeEdit(
//                       id: widget.id,
//                       title: widget.title,
//                       selectedSkills: widget.selectedSkills,
//                       selectedStrens: widget.selectedStrens,
//                       workExperiences: workExperiences,
//                     ),
//                   ),
//                 );
//               }
//                   : null,
//               child: const Text('다음 페이지로 이동', style: TextStyle(color: Colors.white)),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: areAllFieldsFilled() ? const Color.fromARGB(250, 51, 51, 255) : Colors.grey,
//                 minimumSize: const Size(360, 50),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class WorkExperience {
//   String startYear = '';
//   String startMonth = '';
//   String endYear = '';
//   String endMonth = '';
//   String place = '';
//   String description = '';
//
//   Map<String, dynamic> toMap() {
//     return {
//       'place': place,
//       'startYear': startYear,
//       'startMonth': startMonth,
//       'endYear': endYear,
//       'endMonth': endMonth,
//       'description': description,
//     };
//   }
// }
//
// class WorkExperienceDisplay extends StatelessWidget {
//   final WorkExperience experience;
//   final VoidCallback onEdit;
//   final VoidCallback onRemove;
//
//   const WorkExperienceDisplay({
//     Key? key,
//     required this.experience,
//     required this.onEdit,
//     required this.onRemove,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(top: 15.0),
//       padding: const EdgeInsets.only(top: 5.0, bottom: 20.0, left: 20, right: 10),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         border: Border.all(color: Colors.grey),
//         borderRadius: const BorderRadius.all(
//           Radius.circular(20),
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 '${experience.place}',
//                 style: TextStyle(fontSize: 18),
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   TextButton(
//                     onPressed: onEdit,
//                     child: const Text('편집', style: TextStyle(color: Colors.blue)),
//                   ),
//                   TextButton(
//                     onPressed: onRemove,
//                     child: const Text('삭제', style: TextStyle(color: Colors.red)),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//           Row(
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     '근무 기간     ',
//                     style: TextStyle(fontSize: 14),
//                   ),
//                   const SizedBox(height: 10),
//                   Text(
//                     '근무 내용      ',
//                     style: TextStyle(fontSize: 14),
//                   ),
//                 ],
//               ),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     '${experience.startYear}년 ${experience.startMonth}월 ~ ${experience.endYear}년 ${experience.endMonth}월',
//                     style: TextStyle(fontSize: 14),
//                   ),
//                   const SizedBox(height: 10),
//                   Text(
//                     '${experience.description}',
//                     style: TextStyle(fontSize: 14),
//                   ),
//                 ],
//               ),
//             ],
//           )
//
//         ],
//       ),
//     );
//   }
// }
//
// class WorkExperienceDialog extends StatefulWidget {
//   final WorkExperience? experience;
//   final void Function(WorkExperience) onSave;
//
//   const WorkExperienceDialog({
//     Key? key,
//     this.experience,
//     required this.onSave,
//   }) : super(key: key);
//
//   @override
//   _WorkExperienceDialogState createState() => _WorkExperienceDialogState();
// }
//
// class _WorkExperienceDialogState extends State<WorkExperienceDialog> {
//   final List<String> years = List<String>.generate(60, (i) => (1965 + i).toString());
//   final List<String> months = List<String>.generate(12, (i) => (i + 1).toString());
//
//   late TextEditingController startYearController;
//   late TextEditingController startMonthController;
//   late TextEditingController endYearController;
//   late TextEditingController endMonthController;
//   late TextEditingController placeController;
//   late TextEditingController descriptionController;
//
//   bool isSaveEnabled = false;
//
//   @override
//   void initState() {
//     super.initState();
//
//     final experience = widget.experience ?? WorkExperience();
//     startYearController = TextEditingController(text: experience.startYear);
//     startMonthController = TextEditingController(text: experience.startMonth);
//     endYearController = TextEditingController(text: experience.endYear);
//     endMonthController = TextEditingController(text: experience.endMonth);
//     placeController = TextEditingController(text: experience.place);
//     descriptionController = TextEditingController(text: experience.description);
//
//     startYearController.addListener(_checkIfAllFieldsFilled);
//     startMonthController.addListener(_checkIfAllFieldsFilled);
//     endYearController.addListener(_checkIfAllFieldsFilled);
//     endMonthController.addListener(_checkIfAllFieldsFilled);
//     placeController.addListener(_checkIfAllFieldsFilled);
//     descriptionController.addListener(_checkIfAllFieldsFilled);
//   }
//
//   @override
//   void dispose() {
//     startYearController.dispose();
//     startMonthController.dispose();
//     endYearController.dispose();
//     endMonthController.dispose();
//     placeController.dispose();
//     descriptionController.dispose();
//     super.dispose();
//   }
//
//   void _checkIfAllFieldsFilled() {
//     setState(() {
//       isSaveEnabled = startYearController.text.isNotEmpty &&
//           startMonthController.text.isNotEmpty &&
//           endYearController.text.isNotEmpty &&
//           endMonthController.text.isNotEmpty &&
//           placeController.text.isNotEmpty &&
//           descriptionController.text.isNotEmpty;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: const Text('경력 추가'),
//       content: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             DropdownButtonFormField<String>(
//               decoration: const InputDecoration(labelText: '근무 시작 (년)'),
//               value: startYearController.text.isNotEmpty ? startYearController.text : null,
//               items: years.map((String value) {
//                 return DropdownMenuItem<String>(
//                   value: value,
//                   child: Text(value),
//                 );
//               }).toList(),
//               onChanged: (newValue) {
//                 startYearController.text = newValue ?? '';
//               },
//             ),
//             DropdownButtonFormField<String>(
//               decoration: const InputDecoration(labelText: '근무 시작 (월)'),
//               value: startMonthController.text.isNotEmpty ? startMonthController.text : null,
//               items: months.map((String value) {
//                 return DropdownMenuItem<String>(
//                   value: value,
//                   child: Text(value),
//                 );
//               }).toList(),
//               onChanged: (newValue) {
//                 startMonthController.text = newValue ?? '';
//               },
//             ),
//             DropdownButtonFormField<String>(
//               decoration: const InputDecoration(labelText: '근무 종료 (년)'),
//               value: endYearController.text.isNotEmpty ? endYearController.text : null,
//               items: years.map((String value) {
//                 return DropdownMenuItem<String>(
//                   value: value,
//                   child: Text(value),
//                 );
//               }).toList(),
//               onChanged: (newValue) {
//                 endYearController.text = newValue ?? '';
//               },
//             ),
//             DropdownButtonFormField<String>(
//               decoration: const InputDecoration(labelText: '근무 종료 (월)'),
//               value: endMonthController.text.isNotEmpty ? endMonthController.text : null,
//               items: months.map((String value) {
//                 return DropdownMenuItem<String>(
//                   value: value,
//                   child: Text(value),
//                 );
//               }).toList(),
//               onChanged: (newValue) {
//                 endMonthController.text = newValue ?? '';
//               },
//             ),
//             TextField(
//               decoration: const InputDecoration(labelText: '근무지'),
//               controller: placeController,
//             ),
//             TextField(
//               decoration: const InputDecoration(labelText: '근무 내용'),
//               controller: descriptionController,
//             ),
//           ],
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//           child: const Text('취소'),
//         ),
//         TextButton(
//           onPressed: isSaveEnabled
//               ? () {
//             final newExperience = WorkExperience()
//               ..startYear = startYearController.text
//               ..startMonth = startMonthController.text
//               ..endYear = endYearController.text
//               ..endMonth = endMonthController.text
//               ..place = placeController.text
//               ..description = descriptionController.text;
//             widget.onSave(newExperience);
//             Navigator.of(context).pop();
//           }
//               : null,
//           child: const Text('완료'),
//         ),
//       ],
//     );
//   }
// }
//
// /*
// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:desktop_drop/desktop_drop.dart';
// import 'dart:typed_data';
//
// import 'package:halmoney/screens/resume/resumeEdit2.dart';
//
// class ExtraResumePage extends StatelessWidget {
//   final String id;
//   final List<String> selectedSkills;
//   final List<String> selectedStrens;
//
//   const ExtraResumePage({super.key, required this.id, required this.selectedSkills, required this.selectedStrens});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.white,
//           elevation: 1.0,
//           title: Row(
//             //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               Image.asset(
//                 'assets/images/img_logo.png',
//                 fit: BoxFit.contain,
//                 height: 40,
//               ),
//               Container(
//                   padding: const EdgeInsets.all(8.0),
//                   child: const Text(
//                     '할MONEY',
//                     style : TextStyle(
//                       fontFamily: 'NanumGothicFamily',
//                       fontWeight: FontWeight.w600,
//                       fontSize: 18.0,
//                       color: Colors.black,
//                       //Color.fromARGB(250, 51, 51, 255),
//                     ),)
//               ),
//             ],
//           ),
//         ),
//         body: Padding (
//             padding: const EdgeInsets.only(left: 35.0, right: 35.0, top:50.0),
//             child: Column(
//               //왼쪽 맞춤 정렬
//               crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     '추가할 이력사항이 있다면 첨부해주세요!',
//                     style: TextStyle(
//                         fontSize: 18.0,
//                         fontFamily: 'NanumGothic',
//                         fontWeight: FontWeight.w600),
//                   ),
//
//                   const SizedBox(height: 30),
//
//                   Container(child: const FilePickerTest()),
//
//                   const SizedBox(height: 50),
//
//                   const Text(
//                     '추가하고 싶은 내용이 있다면 작성해주세요!',
//                     style: TextStyle(
//                         fontSize: 18.0,
//                         fontFamily: 'NanumGothic',
//                         fontWeight: FontWeight.w600),
//                   ),
//
//                   const SizedBox(height: 20),
//
//                   Container(child: const TextField(
//                     decoration: InputDecoration(
//                         labelText: '(선택사항)'
//                     ),
//                   ),
//                   ),
//
//                   const SizedBox(height: 70),
//
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       //backgroundColor: _buttonActive ? const Color.fromARGB(250, 51, 51, 255) : Colors.grey,
//                         backgroundColor: const Color.fromARGB(250, 51, 51, 255),
//                         minimumSize: const Size(360,50),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         )
//                     ),
//                     onPressed: () {
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (context) => ResumeEdit(id: id))
//                       );
//                     },
//                     child: const Text('AI로 이력서 만들기',style: TextStyle(color: Colors.white),),
//                   ),
//                 ]
//             )
//         )
//     );
//   }
// }
//
// class FilePickerTest extends StatefulWidget{
//   const FilePickerTest({super.key});
//
//   @override
//   FilePickerTestState createState() => FilePickerTestState();
// }
//
// class FilePickerTestState extends State<FilePickerTest> {
//   //final List<XFile> _list = [];
//
//   String showFileName = "";
//   bool _dragging = false;
//
//   Color defaultColor = Colors.black38;
//   Color uploadingColor = Colors.blue[100]!;
//
//   Container makeFilePicker(){
//     Color color = _dragging ? uploadingColor : defaultColor;
//     return Container(
//       height: 200,
//       width: 340,
//       decoration: BoxDecoration(
//         border: Border.all(width: 5, color: color,),
//         borderRadius: const BorderRadius.all(Radius.circular(20)),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           //drag and drop 부분
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Text("드래그하여 파일 업로드\n", style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 20))
//             ],
//           ),
//           //picker 부분
//           InkWell(
//             onTap: () async {
//               FilePickerResult? result = await FilePicker.platform.pickFiles(
//                 type: FileType.custom,
//                 allowedExtensions: ['pdf', 'png', 'jpg', 'csv'],
//               );
//               if( result != null && result.files.isNotEmpty ){
//                 String fileName = result.files.first.name;
//                 Uint8List fileBytes = result.files.first.bytes!;
//                 debugPrint(fileName);
//                 setState(() {
//                   showFileName = "Now File Name: $fileName";
//                 });
//                 /*
//                 do jobs
//                  */
//               }
//             },
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.end,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text("or ", style: TextStyle(fontWeight: FontWeight.bold,color:defaultColor, fontSize:20 ),),
//                 Text("파일을 찾아 업로드하기", style: TextStyle(fontWeight: FontWeight.bold, color: defaultColor, fontSize: 20,),),
//                 Icon(Icons.upload_rounded, color: defaultColor,),
//               ],
//             ),
//           ),
//           Text("(*.pdf/png/jpg/csv)", style: TextStyle(color: defaultColor,),),
//           const SizedBox(height: 10,),
//           Text(showFileName, style: TextStyle(color: defaultColor,),),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     //makeFilePicker -> makedropzone
//     return DropTarget(
//       onDragDone: (detail) async {
//         debugPrint('onDragDone');
//         if (detail.files.isNotEmpty) {
//           String fileName = detail.files.first.name;
//           Uint8List fileBytes = await detail.files.first.readAsBytes();
//           debugPrint(fileName);
//           setState(() {
//             showFileName = "Now File Name: $fileName";
//           });
//         }
//       },
//       onDragEntered: (detail){
//         setState(() {
//           debugPrint('onDragEntered');
//           _dragging=true;
//         });
//       },
//       onDragExited: (detail){
//         debugPrint('onDragExited');
//         setState(() {
//           _dragging=false;
//         });
//       },
//       child: makeFilePicker(),
//     );
//   }
// }
// */