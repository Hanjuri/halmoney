import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class QuestionGeneratorService {
  Future<List<String>> generateQuestionsFromText({
    required String applystep,
  }) async {
    final apiKey = dotenv.get('GPT_API_KEY');
    const endpoint = 'https://api.openai.com/v1/chat/completions';

    
    String prompt = '''다음 주어진 텍스트에서 **채용절차**만을 단계별로 추출해 주세요. 각 단계를 간단히 표현으로 리스트로 정리해 주세요.
      
      채용절차:
      $applystep
      
      요청사항:
    1. 각 절차는 순서대로 나열해 주세요.
    2. 간단하고 명확하게 추려 주세요.
    3. 리스트 형식으로 작성해 주세요 (예: ['서류접수', '서류전형', '면접전형']).
    4. 날짜나 세부정보는 첫번째에 알려주고, 핵심적인 절차 단계만 추려 주세요.
''';

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