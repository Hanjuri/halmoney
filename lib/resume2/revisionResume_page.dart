import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class SelfIntroductionRevisionPage extends StatefulWidget {
  final String existingIntroduction;

  const SelfIntroductionRevisionPage({
    Key? key,
    required this.existingIntroduction,
  }) : super(key: key);

  @override
  _SelfIntroductionRevisionPageState createState() =>
      _SelfIntroductionRevisionPageState();
}

class _SelfIntroductionRevisionPageState
    extends State<SelfIntroductionRevisionPage> {
  final TextEditingController _modificationController = TextEditingController();
  String revisedIntroduction = '';
  bool _isLoading = false;
  List<String> paragraphs = [];
  String firstParagraph = '';
  String secondParagraph = '';
  String thirdParagraph = '';
  String selectedParagraph = ''; // 선택된 문단 저장
  int selectedParagraphIndex = -1;

  @override
  void initState() {
    super.initState();
    print(widget.existingIntroduction);
    List<String> paragraphs = widget.existingIntroduction.split('\n\n');
    firstParagraph = paragraphs.isNotEmpty ? paragraphs[0] : '';
    secondParagraph = paragraphs.length > 1 ? paragraphs[1] : '';
    thirdParagraph = paragraphs.length > 2 ? paragraphs[2] : '';
    print('first $firstParagraph');
  }

  // 팝업창을 통해 수정사항 입력
  Future<void> _showModificationDialog(String paragraph, int index) async {
    TextEditingController _popupController = TextEditingController();
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('수정사항 입력'),
          content: TextField(
            controller: _popupController,
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: '수정사항을 입력하세요',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.of(context).pop(); // 팝업창 닫기
              },
            ),
            ElevatedButton(
              child: Text('확인'),
              onPressed: () {
                setState(() {
                  _modificationController.text = _popupController.text;
                  selectedParagraphIndex = index;
                  selectedParagraph = paragraph;
                });
                print('선택문단! ${selectedParagraph}');
                _generateRevisedIntroduction(); // 수정된 문단과 수정사항을 처리
                Navigator.of(context).pop(); // 팝업창 닫기
              },
            ),
          ],
        );
      },
    );
  }

  // GPT-3를 사용하여 수정된 자기소개서를 생성하는 함수
  Future<void> _generateRevisedIntroduction() async {
    final apiKey = dotenv.get('GPT_API_KEY');
    const endpoint = 'https://api.openai.com/v1/chat/completions';
    print('선택문단내용 $selectedParagraph');

    String prompt = '''다음 자기소개서를 바탕으로 아래 수정사항을 적용하여 새로운 자기소개서를 작성:
기존 문단: $selectedParagraph
수정사항: ${_modificationController.text}

요구 사항:
1. 기존 문장의 스타일과 톤을 유지한다.
2. 수정사항은 반드시 명확히 반영한다.
3. 기존 문단을 완전히 바꾸지 말고, 적절하게 수정한다.
4. 문단의 핵심 내용을 유지한다.''';

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: json.encode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {'role': 'system', 'content': prompt},
          ],
          'max_tokens': 500,
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(utf8.decode(response.bodyBytes));

        if (responseBody.containsKey('choices') &&
            responseBody['choices'] is List &&
            responseBody['choices'].isNotEmpty) {
          final text = responseBody['choices'][0]['message']['content'];
          setState(() {
            revisedIntroduction = text;
            _isLoading = false;
          });
        } else {
          _showErrorSnackBar('Invalid response format');
        }
      } else {
        _showErrorSnackBar(
            'Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      _showErrorSnackBar('Failed to fetch response: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('자기소개서 수정'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(250, 51, 51, 255),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Scrollbar(
          thumbVisibility: false,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '수정할 문단을 선택해 주세요!',
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 10),
                // 첫번째 문단 클릭 가능하도록 설정
                GestureDetector(
                  onTap: () => _showModificationDialog(firstParagraph, 0),
                  child: _buildParagraphContainer(firstParagraph, 0),
                ),
                _buildRevisedContainer(0), // 첫번째 문단 아래 컨테이너 추가
                const SizedBox(height: 10),
                // 두번째 문단 클릭 가능하도록 설정
                GestureDetector(
                  onTap: () => _showModificationDialog(secondParagraph, 1),
                  child: _buildParagraphContainer(secondParagraph, 1),
                ),
                _buildRevisedContainer(1), // 두번째 문단 아래 컨테이너 추가
                const SizedBox(height: 10),
                // 세번째 문단 클릭 가능하도록 설정
                GestureDetector(
                  onTap: () => _showModificationDialog(thirdParagraph, 2),
                  child: _buildParagraphContainer(thirdParagraph, 2),
                ),
                _buildRevisedContainer(2), // 세번째 문단 아래 컨테이너 추가
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 수정된 자기소개서를 표시하는 컨테이너
  Widget _buildRevisedContainer(int index) {
    return revisedIntroduction.isNotEmpty && selectedParagraphIndex == index
        ? Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        revisedIntroduction,
        style: const TextStyle(fontSize: 16),
      ),
    )
        : const SizedBox.shrink();
  }

  // 문단을 표시하는 컨테이너를 구성하는 함수
  Widget _buildParagraphContainer(String paragraph, int index) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: selectedParagraphIndex == index ? Colors.blue : Colors.white,
        border: Border.all(
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Scrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          child: Text(
            paragraph,
            textAlign: TextAlign.left,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}