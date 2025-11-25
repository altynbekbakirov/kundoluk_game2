import 'enums.dart';

class Choice {
  final String id;
  final String text;

  Choice({
    required this.id,
    required this.text,
  });

  factory Choice.fromJson(Map<String, dynamic> json) {
    return Choice(
      id: json['id'] as String,
      text: json['text'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
    };
  }
}

class GameTurnResponse {
  final String narrative;
  final String question;
  final List<Choice> choices;
  final String correctChoiceId;
  final String explanation;
  final String? npcName;
  final String? npcDialogue;
  final String subject;
  final bool? isGameOver;
  final bool? isVictory;

  GameTurnResponse({
    required this.narrative,
    required this.question,
    required this.choices,
    required this.correctChoiceId,
    required this.explanation,
    this.npcName,
    this.npcDialogue,
    required this.subject,
    this.isGameOver,
    this.isVictory,
  });

  factory GameTurnResponse.fromJson(Map<String, dynamic> json) {
    return GameTurnResponse(
      narrative: json['narrative'] as String,
      question: json['question'] as String,
      choices: (json['choices'] as List)
          .map((choice) => Choice.fromJson(choice as Map<String, dynamic>))
          .toList(),
      correctChoiceId: json['correctChoiceId'] as String,
      explanation: json['explanation'] as String,
      npcName: json['npcName'] as String?,
      npcDialogue: json['npcDialogue'] as String?,
      subject: json['subject'] as String,
      isGameOver: json['isGameOver'] as bool?,
      isVictory: json['isVictory'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'narrative': narrative,
      'question': question,
      'choices': choices.map((c) => c.toJson()).toList(),
      'correctChoiceId': correctChoiceId,
      'explanation': explanation,
      'npcName': npcName,
      'npcDialogue': npcDialogue,
      'subject': subject,
      'isGameOver': isGameOver,
      'isVictory': isVictory,
    };
  }
}

class TurnResult {
  final bool success;
  final String feedback;
  final int energyChange;

  TurnResult({
    required this.success,
    required this.feedback,
    required this.energyChange,
  });
}

class GameState {
  final GameStatus status;
  final GradeLevel grade;
  final ScenarioTheme theme;
  final Language language;
  final int energy;
  final int turnCount;
  final List<String> history;
  final GameTurnResponse? currentTurnData;
  final TurnResult? lastResult;
  final String? selectedChoiceId;
  final String? error;

  GameState({
    required this.status,
    required this.grade,
    required this.theme,
    required this.language,
    required this.energy,
    required this.turnCount,
    required this.history,
    this.currentTurnData,
    this.lastResult,
    this.selectedChoiceId,
    this.error,
  });

  GameState copyWith({
    GameStatus? status,
    GradeLevel? grade,
    ScenarioTheme? theme,
    Language? language,
    int? energy,
    int? turnCount,
    List<String>? history,
    GameTurnResponse? currentTurnData,
    TurnResult? lastResult,
    String? selectedChoiceId,
    String? error,
    bool clearCurrentTurnData = false,
    bool clearLastResult = false,
    bool clearSelectedChoiceId = false,
    bool clearError = false,
  }) {
    return GameState(
      status: status ?? this.status,
      grade: grade ?? this.grade,
      theme: theme ?? this.theme,
      language: language ?? this.language,
      energy: energy ?? this.energy,
      turnCount: turnCount ?? this.turnCount,
      history: history ?? this.history,
      currentTurnData: clearCurrentTurnData ? null : (currentTurnData ?? this.currentTurnData),
      lastResult: clearLastResult ? null : (lastResult ?? this.lastResult),
      selectedChoiceId: clearSelectedChoiceId ? null : (selectedChoiceId ?? this.selectedChoiceId),
      error: clearError ? null : (error ?? this.error),
    );
  }
}

