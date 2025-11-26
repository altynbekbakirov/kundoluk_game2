import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/enums.dart';
import '../models/game_models.dart';

class GeminiService {
  static const String _baseUrl = 'https://generativelanguage.googleapis.com/v1beta';
  static const String _modelName = 'gemini-2.0-flash-exp';
  
  // Secure: API key compiled into binary at build time, not extractable from APK
  static const String _apiKey = "AIzaSyCP9YK1EUXqvpBA6dG2_GJbGrULEMsXVe0";

  GeminiService() {
    if (_apiKey.isEmpty) {
      throw Exception(
        'GEMINI_API_KEY not provided at build time.\n'
        'Run with: flutter run --dart-define=GEMINI_API_KEY=your_key'
      );
    }
  }

  String _getSystemPrompt(GradeLevel grade, ScenarioTheme theme, Language language) {
    if (language == Language.russian) {
      final translatedTheme = theme.getRussianLabel();
      return '''
Ты сценарист текстовой интерактивной игры (RPG) для школьников (${grade.label}). Язык ответа: РУССКИЙ.
Контекст: Школьная программа Кыргызстана (Математика, Физика, Химия, Биология, География).
Тема: $translatedTheme.
Цель: Создать захватывающую историю.
Главный герой - ученик. Его оружие - научные знания.
Вместо "Жизни" используется "Энергия Знаний".
Персонаж-помощник: "Акылман" или "Робот-гид".
Уровень сложности: Соответствует ${grade.label} школы.

Важно: Вопросы должны быть основаны на школьной программе, но вписаны в сюжет.
Ответ ВСЕГДА возвращай в заданном JSON формате.
''';
    }

    // Default to Kyrgyz
    return '''
Сен мектеп окуучулары (${grade.label}) үчүн кыргыз тилинде текстке негизделген интерактивдүү оюндун (Text-Based RPG) сценаристисиң.
Тема: ${theme.label}.
Максат: Математика, Физика, Химия, Биология, География сабактарын камтыган кызыктуу окуя түзүү.
Окуучу башкы каарман. Анын куралы - илимий билим.
"Жашоо күчү" ордуна "Билим энергиясы" колдонулат.
Персонаж: Окуучуга жардам берген "Акылман" же "Робот-гид" (темага жараша) болушу керек.
Деңгээл: ${grade.label} окуучусуна ылайыктуу суроолор (жеңил логикадан татаал анализге чейин).

Жоопту АР ДАЙЫМ берилген JSON схемасында кайтар.
''';
  }

  Future<GameTurnResponse> generateInitialTurn(
    GradeLevel grade,
    ScenarioTheme theme,
    Language language,
  ) async {
    try {
      final startPrompt = language == Language.russian
          ? 'Начни игру. Опиши первую ситуацию и дай 3-4 варианта действий. Укажи правильный ответ в "correctChoiceId".'
          : 'Оюнду башта. Биринчи кырдаалды сүрөттөп, 3-4 тандоо бер. Туура жоопту "correctChoiceId" талаасына белгиле.';

      final response = await _generateContent(
        prompt: startPrompt,
        systemPrompt: _getSystemPrompt(grade, theme, language),
      );

      return GameTurnResponse.fromJson(response);
    } catch (e) {
      throw Exception('Error generating initial turn: $e');
    }
  }

  Future<GameTurnResponse> generateNextTurn({
    required String previousNarrative,
    required String previousQuestion,
    required String userChoiceText,
    required bool isCorrect,
    required GradeLevel grade,
    required ScenarioTheme theme,
    required Language language,
  }) async {
    try {
      final nextTurnPrompt = '''
Context:
Previous Scenario: $previousNarrative
Previous Question: $previousQuestion
User Choice: $userChoiceText
Result: ${isCorrect ? "CORRECT" : "INCORRECT"}

Task: Continue the story in ${language == Language.russian ? "Russian" : "Kyrgyz"}.
If the user was INCORRECT: The situation gets slightly more complicated or dangerous. Explain the consequence.
If the user was CORRECT: Move the story forward positively.

Select a NEW subject (Physics, Chemistry, Biology, etc.) different from the previous one if possible.
Provide a new question, choices, and identify the correct answer.
''';

      final response = await _generateContent(
        prompt: nextTurnPrompt,
        systemPrompt: _getSystemPrompt(grade, theme, language),
      );

      return GameTurnResponse.fromJson(response);
    } catch (e) {
      throw Exception('Error generating next turn: $e');
    }
  }

  Future<Map<String, dynamic>> _generateContent({
    required String prompt,
    required String systemPrompt,
  }) async {
    final url = Uri.parse('$_baseUrl/models/$_modelName:generateContent?key=$_apiKey');

    final requestBody = {
      'contents': [
        {
          'parts': [
            {'text': prompt}
          ]
        }
      ],
      'systemInstruction': {
        'parts': [
          {'text': systemPrompt}
        ]
      },
      'generationConfig': {
        'responseMimeType': 'application/json',
        'responseSchema': {
          'type': 'object',
          'properties': {
            'narrative': {
              'type': 'string',
              'description': 'The current story situation description.'
            },
            'question': {
              'type': 'string',
              'description': 'The scientific or logical question the player must answer.'
            },
            'choices': {
              'type': 'array',
              'items': {
                'type': 'object',
                'properties': {
                  'id': {'type': 'string'},
                  'text': {
                    'type': 'string',
                    'description': 'The choice text.'
                  }
                },
                'required': ['id', 'text']
              }
            },
            'correctChoiceId': {
              'type': 'string',
              'description': 'The ID of the choice that is scientifically correct.'
            },
            'explanation': {
              'type': 'string',
              'description': 'A short scientific explanation why the correct answer is right.'
            },
            'npcName': {
              'type': 'string',
              'description': 'Name of the companion character.'
            },
            'npcDialogue': {
              'type': 'string',
              'description': 'Short dialogue from the companion.'
            },
            'subject': {
              'type': 'string',
              'description': 'The school subject related to this challenge.'
            },
            'isGameOver': {'type': 'boolean'},
            'isVictory': {'type': 'boolean'}
          },
          'required': [
            'narrative',
            'question',
            'choices',
            'correctChoiceId',
            'explanation',
            'subject'
          ]
        }
      }
    };

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final candidates = jsonResponse['candidates'] as List?;
      
      if (candidates != null && candidates.isNotEmpty) {
        final content = candidates[0]['content'];
        final parts = content['parts'] as List;
        
        if (parts.isNotEmpty) {
          final text = parts[0]['text'] as String;
          return jsonDecode(text) as Map<String, dynamic>;
        }
      }
      
      throw Exception('Invalid response structure from Gemini API');
    } else {
      throw Exception('Failed to generate content: ${response.statusCode} - ${response.body}');
    }
  }
}

