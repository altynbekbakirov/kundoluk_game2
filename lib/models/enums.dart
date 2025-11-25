enum GameStatus {
  idle,
  loading,
  playing,
  gameOver,
  victory,
}

enum Language {
  kyrgyz('ky'),
  russian('ru');

  final String code;
  const Language(this.code);
}

enum GradeLevel {
  grade6('6-класс'),
  grade7('7-класс'),
  grade8('8-класс'),
  grade9('9-класс'),
  grade10('10-класс'),
  grade11('11-класс');

  final String label;
  const GradeLevel(this.label);
}

enum ScenarioTheme {
  timeTravelFuture('Келечекке саякат'),
  ancientKyrgyzstan('Байыркы Кыргызстан'),
  survivalIsland('Ээн аралда аман калуу');

  final String label;
  const ScenarioTheme(this.label);

  String getRussianLabel() {
    switch (this) {
      case ScenarioTheme.timeTravelFuture:
        return 'Путешествие в будущее';
      case ScenarioTheme.ancientKyrgyzstan:
        return 'Древний Кыргызстан';
      case ScenarioTheme.survivalIsland:
        return 'Выживание на необитаемом острове';
    }
  }
}

