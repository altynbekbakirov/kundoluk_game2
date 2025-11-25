import 'package:flutter/material.dart';
import '../models/enums.dart';
import '../widgets/custom_button.dart';
import '../utils/localization.dart';

class StartScreen extends StatefulWidget {
  final Function(GradeLevel, ScenarioTheme, Language) onStart;

  const StartScreen({Key? key, required this.onStart}) : super(key: key);

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  String _step = 'language';
  Language _language = Language.kyrgyz;
  GradeLevel _grade = GradeLevel.grade8;
  ScenarioTheme _theme = ScenarioTheme.timeTravelFuture;

  void _handleLanguageSelect(Language lang) {
    setState(() {
      _language = lang;
      _step = 'setup';
    });
  }

  String _getThemeLabel(ScenarioTheme theme) {
    return _language == Language.russian ? theme.getRussianLabel() : theme.label;
  }

  Widget _buildLanguageSelection() {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Билим Саякатчысы',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  foreground: Paint()
                    ..shader = const LinearGradient(
                      colors: [Color(0xFF818CF8), Color(0xFFA78BFA), Color(0xFFF472B6)],
                    ).createShader(const Rect.fromLTWH(0, 0, 300, 70)),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Путешественник Знаний',
                style: TextStyle(
                  fontSize: 24,
                  color: Color(0xFF94A3B8),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              const Text(
                'Тилди тандаңыз / Выберите язык',
                style: TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: _buildLanguageCard(
                      '🇰🇬',
                      'Кыргызча',
                      'Оюн кыргыз тилинде',
                      () => _handleLanguageSelect(Language.kyrgyz),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildLanguageCard(
                      '🇷🇺',
                      'Русский',
                      'Игра на русском языке',
                      () => _handleLanguageSelect(Language.russian),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageCard(String flag, String title, String subtitle, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B).withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF334155)),
        ),
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: const Color(0xFF312E81).withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  flag,
                  style: const TextStyle(fontSize: 30),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF94A3B8),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSetupScreen() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Text(
              UIText.get('title', _language),
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                foreground: Paint()
                  ..shader = const LinearGradient(
                    colors: [Color(0xFF818CF8), Color(0xFFA78BFA), Color(0xFFF472B6)],
                  ).createShader(const Rect.fromLTWH(0, 0, 300, 70)),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              UIText.get('subtitle', _language),
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF94A3B8),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B).withOpacity(0.5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.school, color: Color(0xFF818CF8), size: 20),
                      const SizedBox(width: 8),
                      Text(
                        UIText.get('selectGrade', _language),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF818CF8),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: GradeLevel.values.map((grade) {
                      return InkWell(
                        onTap: () => setState(() => _grade = grade),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            color: _grade == grade
                                ? const Color(0xFF4F46E5)
                                : const Color(0xFF0F172A),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _grade == grade
                                  ? const Color(0xFF6366F1)
                                  : const Color(0xFF334155),
                            ),
                          ),
                          child: Text(
                            grade.label,
                            style: TextStyle(
                              color: _grade == grade ? Colors.white : const Color(0xFF94A3B8),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      const Icon(Icons.explore, color: Color(0xFF818CF8), size: 20),
                      const SizedBox(width: 8),
                      Text(
                        UIText.get('selectTheme', _language),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF818CF8),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildThemeCard(
                    ScenarioTheme.timeTravelFuture,
                    Icons.rocket_launch,
                    const Color(0xFF4F46E5),
                  ),
                  const SizedBox(height: 12),
                  _buildThemeCard(
                    ScenarioTheme.ancientKyrgyzstan,
                    Icons.museum,
                    const Color(0xFFF59E0B),
                  ),
                  const SizedBox(height: 12),
                  _buildThemeCard(
                    ScenarioTheme.survivalIsland,
                    Icons.terrain,
                    const Color(0xFF10B981),
                  ),
                  const SizedBox(height: 32),
                  CustomButton(
                    text: UIText.get('startBtn', _language),
                    onPressed: () => widget.onStart(_grade, _theme, _language),
                    fullWidth: true,
                    icon: const Icon(Icons.play_arrow, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: TextButton.icon(
                      onPressed: () => setState(() => _step = 'language'),
                      icon: const Icon(Icons.language, size: 16, color: Color(0xFF64748B)),
                      label: Text(
                        UIText.get('changeLanguage', _language),
                        style: const TextStyle(color: Color(0xFF64748B), fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeCard(ScenarioTheme theme, IconData icon, Color color) {
    final isSelected = _theme == theme;
    return InkWell(
      onTap: () => setState(() => _theme = theme),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.2) : const Color(0xFF0F172A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : const Color(0xFF334155),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? color : const Color(0xFF64748B),
              size: 32,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                _getThemeLabel(theme),
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF94A3B8),
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _step == 'language' ? _buildLanguageSelection() : _buildSetupScreen();
  }
}

