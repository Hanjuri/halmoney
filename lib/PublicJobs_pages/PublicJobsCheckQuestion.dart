import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class QuestionGeneratorService {
  Future<List<String>> generateQuestionsFromText({
    required String title,
    required String hireregion,
    required String applypersoncareer,
    required String text,
  }) async {
    final apiKey = dotenv.get('GPT_API_KEY');
    const endpoint = 'https://api.openai.com/v1/chat/completions';

    // Define the prompt for generating questions, including title, hireregion, and applypersoncareer
    String prompt = '''다음 채용 정보를 기반으로 필요한 조건을 확인하는 질문 목록을 작성하세요:
    
채용 제목: $title
근무 지역: $hireregion
경력 요구사항: $applypersoncareer

추가 정보:
$text

요구 사항:
1. 채용 제목, 근무 지역, 경력 요구사항을 포함한 조건에 해당하는지 확인하는 질문을 5개 이상 작성하세요.
2. '당신은 ~에 해당하나요?','당신은~에 부합하나요?'  와 같은 형식으로 작성해주세요.
3. 질문은 명확하고 구체적으로 조건을 확인하는 방식으로 작성하세요.
4. 응답은 각 질문이 한 줄에 하나씩 포함된 목록 형식이어야 합니다.
5. 질문만 나오게 작성해주세요.''';

    // Make the API call to OpenAI's chat endpoint
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

    // Process the API response
    if (response.statusCode == 200) {
      final responseBody = json.decode(utf8.decode(response.bodyBytes));
      if (responseBody.containsKey('choices') &&
          responseBody['choices'] is List &&
          responseBody['choices'].isNotEmpty) {
        // Split the response into a list of questions
        String content = responseBody['choices'][0]['message']['content'];
        List<String> questions = content.split('\n').where((q) => q.trim().isNotEmpty).toList();
        return questions;
      } else {
        throw Exception('Invalid response format');
      }
    } else {
      throw Exception('Error: ${response.statusCode} - ${response.body}');
    }
  }
}