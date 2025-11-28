import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'providers/game_provider.dart';
import 'models/enums.dart';
import 'screens/start_screen.dart';
import 'screens/game_screen.dart';
import 'screens/loading_screen.dart';
import 'widgets/custom_button.dart';
import 'utils/localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // API key is now provided at build time via --dart-define
  // No need to load .env file
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameProvider(),
      child: MaterialApp(
        title: 'Билим Саякатчысы',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF0F172A),
          textTheme: GoogleFonts.interTextTheme(
            ThemeData.dark().textTheme,
          ),
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF4F46E5),
            secondary: Color(0xFF818CF8),
            surface: Color(0xFF1E293B),
            background: Color(0xFF0F172A),
            error: Color(0xFFEF4444),
          ),
        ),
        home: const GameApp(),
      ),
    );
  }
}

class GameApp extends StatelessWidget {
  const GameApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        final state = gameProvider.state;

        // Check game status on state change
        WidgetsBinding.instance.addPostFrameCallback((_) {
          gameProvider.checkGameStatus();
        });

        return Scaffold(
          body: Stack(
            children: [
              // Background Gradient Effects
              Positioned(
                top: -100,
                left: -100,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF312E81).withOpacity(0.3),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -100,
                right: -100,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF581C87).withOpacity(0.3),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              // Main Content
              SafeArea(
                child: Column(
                  children: [
                    // Error Banner
                    if (state.error != null)
                      Container(
                        margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF4444).withOpacity(0.1),
                          border: Border.all(color: const Color(0xFFEF4444)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                state.error!,
                                style: const TextStyle(color: Color(0xFFFCA5A5)),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Color(0xFFFCA5A5)),
                              onPressed: () => gameProvider.clearError(),
                            ),
                          ],
                        ),
                      ),
                    // Content based on game status
                    Expanded(
                      child: _buildContent(context, state, gameProvider),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, state, GameProvider gameProvider) {
    switch (state.status) {
      case GameStatus.idle:
        return StartScreen(
          initialLanguage: gameProvider.hasPlayed ? state.language : null,
          initialGrade: gameProvider.hasPlayed ? gameProvider.lastGrade : null,
          onStart: (grade, theme, language) {
            gameProvider.startGame(grade, theme, language);
          },
        );

      case GameStatus.loading:
        return LoadingScreen(
          message: state.turnCount == 1
              ? UIText.get('loadingStart', state.language)
              : UIText.get('loadingLevel', state.language),
        );

      case GameStatus.gameOver:
        return _buildEndScreen(
          context,
          UIText.get('gameOverTitle', state.language),
          UIText.get('gameOverDesc', state.language),
          UIText.get('restart', state.language),
          gameProvider.resetGame,
          Colors.red,
        );

      case GameStatus.victory:
        return _buildEndScreen(
          context,
          UIText.get('victoryTitle', state.language),
          UIText.get('victoryDesc', state.language),
          UIText.get('mainMenu', state.language),
          gameProvider.resetGame,
          Colors.green,
        );

      case GameStatus.playing:
        if (state.currentTurnData == null) return Container();
        return GameScreen(
          turnData: state.currentTurnData!,
          language: state.language,
          grade: state.grade,
          energy: state.energy,
          selectedChoiceId: state.selectedChoiceId,
          lastResult: state.lastResult,
          onChoiceSelected: (choiceId, choiceText) {
            gameProvider.handleChoice(choiceId, choiceText);
          },
          onProceedToNext: () {
            gameProvider.proceedToNextTurn();
          },
          onExit: gameProvider.resetGame,
        );

      default:
        return Container();
    }
  }

  Widget _buildEndScreen(
    BuildContext context,
    String title,
    String description,
    String buttonText,
    VoidCallback onPressed,
    Color accentColor,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: accentColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: accentColor.withOpacity(0.5)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                accentColor == Colors.red ? Icons.sentiment_dissatisfied : Icons.emoji_events,
                size: 80,
                color: accentColor,
              ),
              const SizedBox(height: 24),
              Text(
                title,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: accentColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 18,
                  color: Color(0xFFCBD5E1),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: buttonText,
                onPressed: onPressed,
                fullWidth: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

