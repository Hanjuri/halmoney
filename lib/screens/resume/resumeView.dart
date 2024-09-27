import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
import 'dart:io';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/rendering.dart';
//import 'package:printing/printing.dart';
import 'package:permission_handler/permission_handler.dart'; // 권한 요청 패키지

class ResumeView extends StatefulWidget {
  final String id;
  final String resumeId;

  const ResumeView({Key? key, required this.id, required this.resumeId})
      : super(key: key);

  @override
  _ResumeViewState createState() => _ResumeViewState();
}

class _ResumeViewState extends State<ResumeView> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic>? _resumeData;
  GlobalKey _repaintBoundaryKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchResumeData();
  }

  Future<void> _fetchResumeData() async {
    try {
      final QuerySnapshot result = await _firestore
          .collection('user')
          .where('id', isEqualTo: widget.id)
          .get();

      final List<DocumentSnapshot> documents = result.docs;

      if (documents.isNotEmpty) {
        final String docId = documents.first.id;

        DocumentSnapshot doc = await _firestore
            .collection('user')
            .doc(docId)
            .collection('resumes')
            .doc(widget.resumeId)
            .get();

        setState(() {
          _resumeData = doc.data() as Map<String, dynamic>;
        });
      }
    } catch (e) {
      print("Failed to fetch resume data: $e");
    }
  }

  Future<void> _deleteResume() async {
    try {
      final QuerySnapshot result = await _firestore
          .collection('user')
          .where('id', isEqualTo: widget.id)
          .get();

      final List<DocumentSnapshot> documents = result.docs;

      if (documents.isNotEmpty) {
        final String docId = documents.first.id;

        await _firestore
            .collection('user')
            .doc(docId)
            .collection('resumes')
            .doc(widget.resumeId)
            .delete();
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      print("Failed to delete resume: $e");
    }
  }

  void _copyTextToClipboard() {
    String resumeText = '';
    if (_resumeData != null) {
      resumeText += '이름 : ${_resumeData!['resumeItem']['name'] ?? '이름 없음'}\n';
      resumeText += '성별 : ${_resumeData!['resumeItem']['gender'] ?? '성별 없음'}\n';
      resumeText += '나이 : ${_resumeData!['resumeItem']['dob']}년생\n';
      resumeText += '주소 : ${_resumeData!['resumeItem']['address'] ?? '주소 없음'}\n';
      resumeText +=
      '전화번호: ${_resumeData!['resumeItem']['phone'] ?? '전화번호 없음'}\n';
      resumeText += '\n경력 사항:\n';
      for (var experience in _resumeData!['resumeItem']['workExperiences']) {
        resumeText += '[${experience['place']}]\n';
        resumeText +=
        '근무 기간: ${experience['startYear']}년 ${experience['startMonth']}월 ~ ${experience['endYear']}년 ${experience['endMonth']}월\n';
        resumeText += '근무 내용: ${experience['description']}\n';
      }
      resumeText +=
      '\n자기소개서:\n${_resumeData!['resumeItem']['selfIntroduction'] ?? '자기소개 없음'}\n';
    }
    Clipboard.setData(ClipboardData(text: resumeText));
  }

  //캡쳐, pdf파일을 로컬 저장소(Files)에 저장하기
  Future<void> _captureAndSaveAsPdf() async {
    try {
      // 저장소 권한 요청
      var status = await Permission.storage.request();
      if (!status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('저장소 접근 권한이 필요합니다.')),
        );
        return;
      }

      // 스크롤 가능한 전체 높이 계산
      double totalHeight = _scrollController.position.maxScrollExtent + MediaQuery.of(context).size.height;

      // RepaintBoundary 위젯의 RenderRepaintBoundary 가져오기
      RenderRepaintBoundary boundary = _repaintBoundaryKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

      // 전체 화면을 이미지로 변환
      ui.Image img = await boundary.toImage(
        pixelRatio: 3.0, // 고해상도 이미지를 위해 픽셀 비율 설정
      );
      ByteData? byteData  = await img.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null){
        throw Exception('이미지 데이터를 변환할 수 없습니다');
      }
      final imageBytes = byteData!.buffer.asUint8List();

      // pdf 생성
      final pdf = pw.Document();
      final pdfImage = pw.MemoryImage(imageBytes);

      // pdf에 이미지 추가
      pdf.addPage(pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Image(pdfImage),
          ); // 페이지에 이미지를 추가
        },
      ));

      // 외부 저장소의 경로 가져오기
      Directory directory = await getExternalStorageDirectory() ?? await getApplicationDocumentsDirectory();
      String path = "${directory.path}/resume.pdf";

      // pdf 저장
      File file = File(path);
      await file.writeAsBytes(await pdf.save());

      // 저장 완료 메시지 표시
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pdf가 파일 폴더에 저장되었습니다: $path')),
      );

      print('PDF 저장 경로: $path');

    } catch (e) {
      print("Error generating PDF: $e");
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('이력서 보기'),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios_rounded),
          color: Colors.grey,
        ),
      ),
      body: _resumeData == null
          ? Center(child: Text("이력서를 불러오는 중입니다."))
          : Padding(
        padding: const EdgeInsets.all(30.0),
        child: SingleChildScrollView(
          controller: _scrollController,

          child: RepaintBoundary(
            key: _repaintBoundaryKey,
            child: Column(
            children: [
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 5,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _resumeData!['resumeItem']['name'] ?? '이름 없음',
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '${_resumeData!['resumeItem']['gender'] ?? '성별 없음'}',
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(height: 8),
                      // Text(
                      //   '${_resumeData!['resumeItem']['dob']}년생',
                      //   style: TextStyle(fontSize: 15),
                      // ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 40),
              //주소, 전화번호란
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '주소',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        '전화번호',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_resumeData!['resumeItem']['address']}',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        '${_resumeData!['resumeItem']['phone']}',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10),
              Divider(),
              SizedBox(
                height: 10,
              ),
              //경력란
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    '경력 사항',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // ...(_resumeData!['resumeItem']['workExperiences']
              // as List<dynamic>)
              //     .map((experience) {
              //   return Container(
              //     margin: const EdgeInsets.symmetric(vertical: 10.0),
              //     padding: const EdgeInsets.all(15.0),
              //     width: double.infinity,
              //     decoration: BoxDecoration(
              //       color: Colors.white,
              //       border: Border.all(color: Colors.grey),
              //       borderRadius: BorderRadius.circular(10.0),
              //     ),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Text(
              //           '${experience['place']}',
              //           style: TextStyle(fontSize: 18),
              //         ),
              //         SizedBox(height: 5),
              //         Text(
              //           '근무 기간   ${experience['startYear']}년 ${experience['startMonth']}월 ~ ${experience['endYear']}년 ${experience['endMonth']}월',
              //           style: TextStyle(fontSize: 14),
              //         ),
              //         SizedBox(height: 5),
              //         Text(
              //           '근무 내용   ${experience['description']}',
              //           style: TextStyle(fontSize: 14),
              //         ),
              //       ],
              //     ),
              //   );
              // }).toList(),
              // Divider(),

              //자기소개서
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    '자기소개서',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  _resumeData!['resumeItem']['selfIntroduction'] ??
                      '자기소개 없음',
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  bool confirmDelete = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('삭제 확인'),
                        content: Text('해당 이력서를 삭제하시겠습니까?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: Text('취소'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                            child: Text('확인'),
                          ),
                        ],
                      );
                    },
                  );
                  if (confirmDelete == true) {
                    await _deleteResume();
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 51, 51, 255)),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.symmetric(vertical: 15.0)),
                ),
                child: Text(
                  '삭제하기',
                  style: TextStyle(fontSize: 16,color: Colors.white),
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  _copyTextToClipboard();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('텍스트가 복사되었습니다'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 51, 51, 255)),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.symmetric(vertical: 15.0)),
                ),
                child: Text(
                  '텍스트 복사하기',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child : ElevatedButton(
                onPressed: (){
                  _captureAndSaveAsPdf();
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 51, 51, 255)),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.symmetric(vertical: 15.0)),
                ),
                child: Text(
                  'PDF로 저장',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              )
            )
          ],
        ),
      ),
    );
  }
}
