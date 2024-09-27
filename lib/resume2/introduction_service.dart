import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class IntroductionService {
  Future<String> generateRevisedIntroduction(String paragraph, String modification) async {
    final apiKey = dotenv.get('GPT_API_KEY');
    const endpoint = 'https://api.openai.com/v1/chat/completions';

    String prompt = '''다음 자기소개서를 바탕으로 아래 수정사항을 적용하여 새로운 자기소개서를 작성:
기존 문단: $paragraph
수정사항: $modification

요구 사항:
1. 기존 문장의 스타일과 톤을 유지한다.
2. 수정사항은 반드시 명확히 반영한다.
3. 기존 문단을 완전히 바꾸지 말고, 적절하게 수정한다.
4. 문단의 핵심 내용을 유지한다.''';

    final response = await http.post(
      Uri.parse(endpoint),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: json.encode({
        'model': 'gpt-4o-mini',
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
        return responseBody['choices'][0]['message']['content'];
      } else {
        throw Exception('Invalid response format');
      }
    } else {
      throw Exception('Error: ${response.statusCode} - ${response.body}');
    }
  }
}