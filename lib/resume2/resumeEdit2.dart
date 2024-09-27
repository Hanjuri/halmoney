// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:halmoney/resume2/extra_resume_page2.dart';
// import 'package:halmoney/resume2/resume_revision/first_revision.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'dart:convert';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'package:halmoney/resume2/revisionResume_page.dart';
// import 'resume_revision/first_revision.dart';
// // 면접 질문 데이터 class
// class InterviewQuestion {
//   late String question;
//
//   InterviewQuestion({required this.question});
//
//   // 면접 질문 데이터를 Map으로 변환하는 함수
//   Map<String, dynamic> toMap() {
//     return {
//       'question': question,
//     };
//   }
// }
//
// //이력서 데이터 class
// class ResumeItem {
//   late String name;
//   late String gender;
//   late String dob;
//   late String address;
//   late String phone;
//   late List<WorkExperience> workExperiences;
//   late List<String> selectedSkills;
//   late List<String> selectedStrens;
//   late String selfIntroduction;
//   File? image;
//
//   ResumeItem({
//     required this.name,
//     required this.gender,
//     required this.dob,
//     required this.address,
//     required this.phone,
//     required this.workExperiences,
//     required this.selectedSkills,
//     required this.selectedStrens,
//     required this.selfIntroduction,
//     this.image,
//   });
//
//   //이력서 데이터를 Map으로 변환하는 함수
//   Map<String, dynamic> toMap() {
//     return {
//       'name': name,
//       'gender': gender,
//       'dob': dob,
//       'address': address,
//       'phone': phone,
//       'workExperiences': workExperiences.map((e) => e.toMap()).toList(),
//       'selectedSkills': selectedSkills,
//       'selectedStrens': selectedStrens,
//       'selfIntroduction': selfIntroduction,
//       'image': image?.path, // 이미지 경로를 저장
//     };
//   }
// }
//
// class ResumeEdit extends StatefulWidget {
//   final String id;
//   final String title;
//   final List<String> selectedSkills;
//   final List<String> selectedStrens;
//   final List<WorkExperience> workExperiences;
//
//   const ResumeEdit({
//     Key? key,
//     required this.id,
//     required this.title,
//     required this.selectedSkills,
//     required this.selectedStrens,
//     required this.workExperiences,
//   }) : super(key: key);
//
//   @override
//   _ResumeEditState createState() => _ResumeEditState();
// }
//
// class _ResumeEditState extends State<ResumeEdit> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   late ResumeItem resumeItem;
//   bool _isLoading = true;
//   final TextEditingController _selfIntroductionController = TextEditingController();
//   List<InterviewQuestion> interviewQuestions = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchResumeData();
//   }
//
//   //사용자 정보 불러오기
//   Future<void> _fetchResumeData() async {
//     try {
//       final QuerySnapshot result = await _firestore
//           .collection('user')
//           .where('id', isEqualTo: widget.id)
//           .get();
//
//       final List<DocumentSnapshot> documents = result.docs;
//
//       if (documents.isNotEmpty) {
//         final String docId = documents.first.id;
//
//         final DocumentSnapshot ds =
//         await _firestore.collection('user').doc(docId).get();
//
//         final data = ds.data() as Map<String, dynamic>;
//
//         // Fetching user information
//         final String name = data['name'];
//         final String dob = data['dob'].substring(0, 4);
//         final String gender = data['gender'];
//         final String address = data['address'];
//         final String phone = data['phone'];
//
//         // Fetching work experiences
//         List<WorkExperience> workExperiences = [];
//         for (var experience in widget.workExperiences) {
//           workExperiences.add(experience);
//         }
//
//         // Fetching AI response
//         final response = await _fetchGPTResponse(
//           dob: dob,
//           gender: gender,
//           workExperiences: workExperiences,
//           selectedSkills: widget.selectedSkills,
//           selectedStrens: widget.selectedStrens,
//         );
//
//
//         setState(() {
//           resumeItem = ResumeItem(
//             name: name,
//             gender: gender,
//             dob: dob,
//             address: address,
//             phone: phone,
//             workExperiences: workExperiences,
//             selectedSkills: widget.selectedSkills,
//             selectedStrens: widget.selectedStrens,
//             selfIntroduction: response,
//           );
//           _selfIntroductionController.text = response;
//           _isLoading = false;
//         });
//
//         // Fetch interview questions after fetching resume data
//         /*await _fetchGPTInterviewQuestions(
//           dob: dob,
//           title: widget.title,
//           selectedSkills: widget.selectedSkills,
//           selectedStrens: widget.selectedStrens,
//         ); */
//       }
//     } catch (error) {
//       print("Failed to fetch resume data: $error");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Failed to fetch resume data: $error")),
//       );
//     }
//   }
//
//   //GPT 자기소개서 작성
//   Future<String> _fetchGPTResponse({
//     required String dob,
//     required String gender,
//     required List<WorkExperience> workExperiences,
//     required List<String> selectedSkills,
//     required List<String> selectedStrens,
//   }) async {
//     final apiKey = dotenv.get('GPT_API_KEY');
//     const endpoint = 'https://api.openai.com/v1/chat/completions';
//     const requestsTimeOut = const Duration(seconds: 60);
//     const supportfield = "보조교사";
//     const certificate ="컴퓨터 활용능력 2급";
//     const experience = "빨간펜 10년 근무, 구몬 15년 근무";
//     const experiencedetail = "빨간펜에서는 방문학습지교사로 일함. 국어, 영어, 한자 같은 과목들을 가르침. 구몬에서는 방문교사로 일하다가 지점 메니저로 승진해서 방문교사들을 관리함";
//     const stren = "의사소통, 책임감, 판단력";
//
//     String prompt = '''중장년층 사용자의 정보를 기반으로 자기소개서를 작성해주는 챗봇입니다.
// 다음 가이드에 따라 각 항목은 간결하게, '안녕하세요'는 빼고, 분량이 넘지 않도록 작성해주세요.
// 첫번째 문단 - 150 token 내외
// 사용자는 $supportfield 분야에 지원하고자 합니다. 이 분야에 지원하게 된 동기를 작성하세요. 사용자의 경력과 관심사를 바탕으로 자연스럽게 연결해 설명하세요.
// 두번째 문단 - 250 token 내외
// 사용자의 경력은 다음과 같습니다: $experience. 경력의 세부 사항은 $experiencedetail입니다. 이러한 경력이 어떻게 지원 분야($supportfield)와 연관되어 있는지 작성하고, 해당 분야에서 어떤 기여를 할 수 있을지 설명하세요.
// 사용자의 장점은 $stren이며, 자격증은 $certificate입니다. 사용자의 장점과 자격증이 지원 분야에서 어떻게 발휘될 수 있을지 설명하세요. 특히, 이러한 능력이 해당 직무에서 어떤 방식으로 도움이 될지 구체적으로 작성하세요.
// 세번째 문단 - 50 token 내외
// 지원하는 $supportfield 분야에서 사용자가 이루고자 하는 구체적인 목표와 다짐을 포함하여 작성하세요. 이 목표가 어떻게 조직에 기여할 수 있을지 설명하세요.
// 마지막으로 "감사합니다"로 마무리 인사를 추가하세요.
//
// 요청된 형식과 분량을  정확히 지켜 작성하세요.''';
//
//     print(prompt);
//
//     try {
//       final response = await http.post(
//         Uri.parse(endpoint),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $apiKey',
//         },
//         body: json.encode({
//           'model': 'gpt-3.5-turbo',
//           'messages': [
//             {'role': 'system', 'content': prompt},
//           ],
//           'max_tokens': 700,
//         }),
//       );
//
//       if (response.statusCode == 200) {
//         final responseBody = json.decode(utf8.decode(response.bodyBytes));
//
//         if (responseBody.containsKey('choices') &&
//             responseBody['choices'] is List &&
//             responseBody['choices'].isNotEmpty) {
//           final text = responseBody['choices'][0]['message']['content'];
//           return text;
//         } else {
//           return 'Failed to fetch response: Invalid response format';
//         }
//       } else {
//         print('Error: ${response.statusCode} - ${response.body}');
//         return 'Failed to fetch response: ${response.statusCode} - ${response.body}';
//       }
//     } catch (e) {
//       print('Exception: $e');
//       return 'Failed to fetch response: $e';
//     }
//   }
//
//   // 이미지 저장
//   Future<void> _pickImage() async {
//     final pickedFile =
//     await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         resumeItem.image = File(pickedFile.path);
//       });
//     }
//   }
//
//   // 이력서 저장
//   Future<void> _saveResume(String title) async {
//     try {
//       final CollectionReference resumesCollection = _firestore
//           .collection('user')
//           .doc(widget.id)
//           .collection('resumes');
//
//       final DocumentReference newResume = resumesCollection.doc();
//
//       await newResume.set({
//         'title': title,
//         'resumeItem': resumeItem.toMap(),
//         'createdAt': FieldValue.serverTimestamp(),
//       });
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Resume saved successfully")),
//       );
//     } catch (error) {
//       print("Failed to save resume data: $error");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Failed to save resume data: $error")),
//       );
//     }
//   }
//   //////////////////////////////////
//
//   // GPT 면접 질문 생성
//  /* Future<void> _fetchGPTInterviewQuestions({
//     required String dob,
//     required String title,
//     required List<String> selectedSkills,
//     required List<String> selectedStrens
// }) async {
//     final apiKey = dotenv.get('GPT_API_KEY');
//     const endpoint = 'https://api.openai.com/v1/chat/completions';
//     const requestsTimeOut = const Duration(seconds: 60);
//
//
//
//     String prompt = '''다음 특징을 갖는 사람의 면접 질문 작성 :
//     생년월일:$dob, 경력 :${resumeItem.workExperiences}, 기술:${selectedSkills}, 장점:$selectedStrens, 지원 직업:$title;
//     질문은 총 10개로 각 질문 끝에 물음표를 붙인다. 질문은 상세하고 명확하게 작성한다.''';
//
//     try {
//       final response = await http.post(
//         Uri.parse(endpoint),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $apiKey',
//         },
//         body: json.encode({
//           'model': 'gpt-3.5-turbo',
//           'messages': [
//             {'role': 'system', 'content': prompt},
//           ],
//           'max_tokens': 500,
//         }),
//       );
//
//       if (response.statusCode == 200) {
//         final responseBody = json.decode(utf8.decode(response.bodyBytes));
//
//         if (responseBody.containsKey('choices') &&
//             responseBody['choices'] is List &&
//             responseBody['choices'].isNotEmpty) {
//           final text = responseBody['choices'][0]['message']['content'];
//           List<String> questions = text.split('\n');
//           setState(() {
//             interviewQuestions = questions.map((q) => InterviewQuestion(question: q)).toList();
//           });
//           for (var question in interviewQuestions) {
//             print(question.question);
//           }
//
//         } else {
//           print('Failed to fetch response: Invalid response format');
//         }
//       } else {
//         print('Error: ${response.statusCode} - ${response.body}');
//       }
//     } catch (e) {
//       print('Exception: $e');
//     }
//   } */
// //////////////////////////////////////////////////////////
//   // 앱 바 뒤로가기 버튼
//   void _goBack() {
//     Navigator.pop(context);
//   }
//
//   //안드로이드 뒤로가기 버튼
//   Future<bool> _onWillPop() async {
//     int count = 0;
//     while (count < 4) {
//       Navigator.of(context).pop();
//       count++;
//     }
//     return true;
//   }
//
//   // 이력서 제목 입력받는 팝업창
//   Future<void> _showSaveDialog() async {
//     TextEditingController _titleController = TextEditingController();
//
//     return showDialog<void>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('이력서 제목을 입력하세요'),
//           content: TextField(
//             controller: _titleController,
//             decoration: InputDecoration(
//               hintText: '이력서 제목',
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: Text('취소'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             ElevatedButton(
//               child: Text('확인'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 _saveResume(_titleController.text);
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         home: SafeArea(
//           top: true,
//           left: false,
//           bottom: true,
//           right: false,
//           child: Scaffold(
//             appBar: AppBar(
//               title: const Text('이력서 작성'),
//               centerTitle: true,
//               elevation: 1.0,
//               backgroundColor: Colors.white,
//               leading: IconButton(
//                 icon: Icon(Icons.arrow_back),
//                 onPressed: _goBack,
//               ),
//             ),
//             body: _isLoading
//                 ? Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   CircularProgressIndicator(
//                     color: Color(0xff1044FC),
//                   ),
//                   SizedBox(height: 20),
//                   Text(
//                     'AI 이력서를 생성중입니다',
//                     style: TextStyle(fontSize: 16),
//                   ),
//                 ],
//               ),
//             )
//                 : Padding(
//               padding: const EdgeInsets.only(left: 30.0, right: 30.0),
//               child: ListView(
//                 children: [
//                   const SizedBox(
//                     height: 30,
//                   ),
//                   // 개인정보란
//                   Row(
//                     children: [
//                       const SizedBox(
//                         width: 5,
//                       ),
//                       GestureDetector(
//                         onTap: _pickImage,
//                         child: Container(
//                           height: 100,
//                           width: 100,
//                           alignment: Alignment.center,
//                           decoration: const BoxDecoration(
//                             color: Colors.white,
//                             shape: BoxShape.circle,
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.grey,
//                                 spreadRadius: 2.5,
//                                 blurRadius: 10.0,
//                                 blurStyle: BlurStyle.inner,
//                               ),
//                             ],
//                           ),
//                           child: resumeItem.image == null
//                               ? const Text(
//                             '사진\n등록',
//                             style: TextStyle(fontSize: 15),
//                           )
//                               : ClipOval(
//                             child: Image.file(
//                               resumeItem.image!,
//                               width: 100,
//                               height: 100,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(
//                         width: 35,
//                       ),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             resumeItem.name,
//                             style: TextStyle(
//                               fontSize: 25,
//                             ),
//                           ),
//                           SizedBox(
//                             height: 8,
//                           ),
//                           Text(
//                             resumeItem.gender,
//                             style: TextStyle(
//                               fontSize: 15,
//                             ),
//                           ),
//                           SizedBox(
//                             height: 8,
//                           ),
//                           Text(
//                             resumeItem.dob + '년생',
//                             style: TextStyle(
//                               fontSize: 15,
//                             ),
//                           )
//                         ],
//                       )
//                     ],
//                   ),
//                   const SizedBox(
//                     height: 40,
//                   ),
//                   // 주소, 전화번호란
//                   Row(
//                     children: [
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             '주소',
//                             style: TextStyle(fontSize: 18),
//                           ),
//                           SizedBox(
//                             height: 10,
//                           ),
//                           Text(
//                             '전화번호',
//                             style: TextStyle(fontSize: 18),
//                           ),
//                         ],
//                       ),
//                       SizedBox(
//                         width: 30,
//                       ),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             resumeItem.address,
//                             style: TextStyle(fontSize: 18),
//                           ),
//                           SizedBox(
//                             height: 10,
//                           ),
//                           Text(
//                             resumeItem.phone,
//                             style: TextStyle(fontSize: 18),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Divider(),
//
//                   // 경력란
//                   const SizedBox(height: 10),
//                   const Text(
//                     '경력 사항',
//                     style: TextStyle(fontSize: 18),
//                   ),
//                   const SizedBox(height: 10),
//                   Column(
//                     children: resumeItem.workExperiences.map((experience) {
//                       return Container(
//                         margin: const EdgeInsets.symmetric(vertical: 10.0),
//                         padding: const EdgeInsets.all(15.0),
//                         width: double.infinity,
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           border: Border.all(color: Colors.grey),
//                           borderRadius: BorderRadius.circular(10.0),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               '${experience.place}',
//                               style: TextStyle(fontSize: 18),
//                             ),
//                             SizedBox(height: 5),
//                             Text(
//                               '근무 기간: ${experience.startYear}년 ${experience.startMonth}월 ~ ${experience.endYear}년 ${experience.endMonth}월',
//                               style: TextStyle(fontSize: 14),
//                             ),
//                             SizedBox(height: 5),
//                             Text(
//                               '근무 내용: ${experience.description}',
//                               style: TextStyle(fontSize: 14),
//                             ),
//                           ],
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                   Divider(),
//
//                   // 자기소개서
//                   const SizedBox(height: 10),
//                   const Text(
//                     '자기소개서',
//                     style: TextStyle(fontSize: 18),
//                   ),
//                   const SizedBox(height: 10),
//                   TextField(
//                     controller: _selfIntroductionController,
//                     maxLines: 10,
//                     decoration: InputDecoration(
//                       border: OutlineInputBorder(),
//                       hintText: '자기소개서를 입력하세요',
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//
//                   ElevatedButton(
//                     onPressed: _showSaveDialog,
//                     child: const Text('저장하기', style: TextStyle(color: Colors.white)),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color.fromARGB(250, 51, 51, 255),
//                       minimumSize: const Size(150, 50),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 20,),
//                   ElevatedButton(
//                     onPressed: () {
//                       List<String> paragraphs = resumeItem.selfIntroduction.split('\n\n');
//                       String firstParagraph = paragraphs.isNotEmpty ? paragraphs[0] : '';
//                       String secondParagraph = paragraphs.length > 1 ? paragraphs[1] : '';
//                       String thirdParagraph = paragraphs.length > 2 ? paragraphs[2] : '';
//
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) =>  FirstParagraphPage(
//                             firstParagraph: firstParagraph,
//                             secondParagraph: secondParagraph,
//                             thirdParagraph: thirdParagraph,
//                             userInfo: widget.userInfo,
//                             userPromptFactor: widget.userPromptFactor,
//                           ),
//                         ),
//                       );
//                     },
//                     child: const Text('수정하기', style: TextStyle(color: Colors.white)),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color.fromARGB(250, 51, 51, 255),
//                       minimumSize: const Size(150, 50),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 20,),
//                  /* const Text('면접 질문',
//                     style: TextStyle(fontSize: 18),),
//                   const SizedBox(height: 10),
//                   ...interviewQuestions.map((question){
//                     return Container(
//                       margin: const EdgeInsets.symmetric(vertical: 5.0 ),
//                       padding: const EdgeInsets.all(10.0),
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         border: Border.all(color:Colors.grey),
//                         borderRadius: BorderRadius.circular(10.0),
//                       ),
//                       child: Text(
//                         question.question,
//                         style: TextStyle(fontSize:16),
//                       ),
//                     );
//                   }).toList(),*/
//                   const SizedBox(height: 20),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
