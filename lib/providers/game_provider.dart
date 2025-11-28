import 'package:flutter/foundation.dart';
import '../models/enums.dart';
import '../models/game_models.dart';
import '../services/gemini_service.dart';
import '../utils/localization.dart';

class GameProvider with ChangeNotifier {
  static const int initialEnergy = 100;
  
  GameState _state = GameState(
    status: GameStatus.idle,
    grade: GradeLevel.grade8,
    theme: ScenarioTheme.timeTravelFuture,
    language: Language.kyrgyz,
    energy: initialEnergy,
    turnCount: 0,
    history: [],
  );

  GameState get state => _state;
  final GeminiService _geminiService = GeminiService();

  bool _hasPlayed = false;
  bool get hasPlayed => _hasPlayed;

  GradeLevel _lastGrade = GradeLevel.grade8;
  GradeLevel get lastGrade => _lastGrade;

  Future<void> startGame(GradeLevel grade, ScenarioTheme theme, Language language) async {
    _hasPlayed = true;
    _lastGrade = grade;
    _state = GameState(
      status: GameStatus.loading,
      grade: grade,
      theme: theme,
      language: language,
      energy: initialEnergy,
      turnCount: 1,
      history: [],
    );
    notifyListeners();

    try {
      final data = await _geminiService.generateInitialTurn(grade, theme, language);
      _state = _state.copyWith(
        status: GameStatus.playing,
        currentTurnData: data,
      );
      notifyListeners();
    } catch (err) {
      _state = _state.copyWith(
        status: GameStatus.idle,
        error: UIText.get('errorStart', language),
      );
      notifyListeners();
    }
  }

  void handleChoice(String choiceId, String choiceText) {
    if (_state.currentTurnData == null || _state.selectedChoiceId != null) {
      return;
    }

    final currentTurnData = _state.currentTurnData!;
    final isCorrect = choiceId == currentTurnData.correctChoiceId;

    final energyChange = isCorrect ? 5 : -20;
    final newEnergy = (_state.energy + energyChange).clamp(0, 100);

    final result = TurnResult(
      success: isCorrect,
      feedback: currentTurnData.explanation,
      energyChange: energyChange,
    );

    _state = _state.copyWith(
      energy: newEnergy,
      lastResult: result,
      selectedChoiceId: choiceId,
    );
    notifyListeners();
  }

  Future<void> proceedToNextTurn() async {
    if (_state.currentTurnData == null || _state.lastResult == null || _state.selectedChoiceId == null) {
      return;
    }

    if (_state.energy <= 0) {
      _state = _state.copyWith(status: GameStatus.gameOver);
      notifyListeners();
      return;
    }

    final currentTurnData = _state.currentTurnData!;
    final selectedChoice = currentTurnData.choices.firstWhere(
      (c) => c.id == _state.selectedChoiceId,
      orElse: () => Choice(id: '', text: ''),
    );

    _state = _state.copyWith(status: GameStatus.loading);
    notifyListeners();

    try {
      final nextTurn = await _geminiService.generateNextTurn(
        previousNarrative: currentTurnData.narrative,
        previousQuestion: currentTurnData.question,
        userChoiceText: selectedChoice.text,
        isCorrect: _state.lastResult!.success,
        grade: _state.grade,
        theme: _state.theme,
        language: _state.language,
      );

      final newHistory = [
        ..._state.history,
        'Turn ${_state.turnCount}: ${currentTurnData.narrative} | User: ${selectedChoice.text} | Result: ${_state.lastResult!.success ? "Correct" : "Incorrect"}'
      ];

      _state = _state.copyWith(
        status: GameStatus.playing,
        turnCount: _state.turnCount + 1,
        history: newHistory,
        currentTurnData: nextTurn,
        clearLastResult: true,
        clearSelectedChoiceId: true,
      );
      notifyListeners();
    } catch (err) {
      _state = _state.copyWith(
        status: GameStatus.playing,
        error: UIText.get('errorNext', _state.language),
      );
      notifyListeners();
    }
  }

  void resetGame() {
    _state = GameState(
      status: GameStatus.idle,
      grade: GradeLevel.grade8,
      theme: ScenarioTheme.timeTravelFuture,
      language: _state.language, // Preserve language
      energy: initialEnergy,
      turnCount: 0,
      history: [],
    );
    notifyListeners();
  }

  void clearError() {
    _state = _state.copyWith(clearError: true);
    notifyListeners();
  }

  void checkGameStatus() {
    if (_state.status == GameStatus.playing && _state.selectedChoiceId == null) {
      if (_state.currentTurnData?.isGameOver == true) {
        _state = _state.copyWith(status: GameStatus.gameOver);
        notifyListeners();
      } else if (_state.currentTurnData?.isVictory == true) {
        _state = _state.copyWith(status: GameStatus.victory);
        notifyListeners();
      }
    }
  }
}

