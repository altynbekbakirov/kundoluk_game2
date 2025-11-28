import 'package:flutter/material.dart';
import '../models/game_models.dart';
import '../models/enums.dart';
import '../utils/localization.dart';
import '../widgets/energy_bar.dart';
import '../widgets/custom_button.dart';

class GameScreen extends StatelessWidget {
  final GameTurnResponse turnData;
  final Language language;
  final GradeLevel grade;
  final int energy;
  final String? selectedChoiceId;
  final TurnResult? lastResult;
  final Function(String, String) onChoiceSelected;
  final VoidCallback onProceedToNext;
  final VoidCallback onExit;

  const GameScreen({
    Key? key,
    required this.turnData,
    required this.language,
    required this.grade,
    required this.energy,
    this.selectedChoiceId,
    this.lastResult,
    required this.onChoiceSelected,
    required this.onProceedToNext,
    required this.onExit,
  }) : super(key: key);

  void _showExitConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFF334155)),
        ),
        title: Text(
          UIText.get('exitGameTitle', language) == 'exitGameTitle' 
              ? (language == Language.kyrgyz ? 'Оюндан чыгуу' : 'Выход из игры')
              : UIText.get('exitGameTitle', language),
          style: const TextStyle(color: Colors.white),
        ),
        content: Text(
          UIText.get('exitGameConfirm', language) == 'exitGameConfirm'
              ? (language == Language.kyrgyz ? 'Чын эле оюндан чыккыңыз келеби?' : 'Вы действительно хотите выйти из игры?')
              : UIText.get('exitGameConfirm', language),
          style: const TextStyle(color: Color(0xFFCBD5E1)),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: Text(
              UIText.get('cancel', language) == 'cancel'
                  ? (language == Language.kyrgyz ? 'Жок' : 'Нет')
                  : UIText.get('cancel', language),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onExit();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(
              UIText.get('exit', language) == 'exit'
                  ? (language == Language.kyrgyz ? 'Ооба' : 'Да')
                  : UIText.get('exit', language),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasAnswered = selectedChoiceId != null;
    final choiceLabels = ['A', 'B', 'C', 'D'];

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        _showExitConfirmation(context);
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // Energy Bar and NPC Section
              Row(
                children: [
                  Expanded(
                    child: EnergyBar(
                      current: energy,
                      label: UIText.get('energy', language),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4444).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFEF4444).withOpacity(0.5)),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.logout, color: Color(0xFFEF4444)),
                      onPressed: () => _showExitConfirmation(context),
                      tooltip: language == Language.kyrgyz ? 'Чыгуу' : 'Выход',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // NPC Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF334155)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF312E81).withOpacity(0.5),
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF6366F1).withOpacity(0.3)),
                      ),
                      child: const Icon(
                        Icons.psychology,
                        color: Color(0xFF818CF8),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                turnData.npcName ?? UIText.get('helper', language),
                                style: const TextStyle(
                                  color: Color(0xFF818CF8),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF334155).withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: const Color(0xFF475569)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.lightbulb_outline, size: 12, color: Color(0xFF94A3B8)),
                                    const SizedBox(width: 4),
                                    Text(
                                      UIText.get('guide', language),
                                      style: const TextStyle(
                                        color: Color(0xFF94A3B8),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '"${turnData.npcDialogue ?? UIText.get('defaultHelperQuote', language)}"',
                            style: const TextStyle(
                              color: Color(0xFFCBD5E1),
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 24),
            // Story Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF334155)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 4,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF6366F1), Color(0xFFA855F7), Color(0xFFEC4899)],
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(2)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF312E81).withOpacity(0.5),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFF6366F1).withOpacity(0.3)),
                        ),
                        child: Text(
                          turnData.subject,
                          style: const TextStyle(
                            color: Color(0xFF818CF8),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF334155),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${UIText.get('level', language)} ${grade.label}',
                          style: const TextStyle(
                            color: Color(0xFFCBD5E1),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    turnData.narrative,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Color(0xFFE2E8F0),
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A).withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: const Border(
                        left: BorderSide(color: Color(0xFF6366F1), width: 4),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.assignment, color: Color(0xFF818CF8), size: 20),
                            const SizedBox(width: 8),
                            Text(
                              UIText.get('task', language),
                              style: const TextStyle(
                                color: Color(0xFF818CF8),
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          turnData.question,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Choices
            ...turnData.choices.asMap().entries.map((entry) {
              final index = entry.key;
              final choice = entry.value;
              final label = index < choiceLabels.length ? choiceLabels[index] : choice.id;
              final isSelected = selectedChoiceId == choice.id;
              final isCorrectChoice = choice.id == turnData.correctChoiceId;

              Color backgroundColor = const Color(0xFF1E293B);
              Color borderColor = const Color(0xFF334155);
              Color labelColor = const Color(0xFF334155);
              Color textColor = const Color(0xFFE2E8F0);
              Widget? statusIcon;

              if (hasAnswered) {
                if (isCorrectChoice) {
                  backgroundColor = const Color(0xFF064E3B).withOpacity(0.3);
                  borderColor = const Color(0xFF10B981);
                  labelColor = const Color(0xFF10B981);
                  textColor = Colors.white;
                  statusIcon = const Icon(Icons.check, color: Colors.white, size: 24);
                } else if (isSelected) {
                  backgroundColor = const Color(0xFF7F1D1D).withOpacity(0.3);
                  borderColor = const Color(0xFFEF4444);
                  labelColor = const Color(0xFFEF4444);
                  textColor = Colors.white;
                  statusIcon = const Icon(Icons.close, color: Colors.white, size: 24);
                } else {
                  backgroundColor = const Color(0xFF1E293B).withOpacity(0.5);
                  borderColor = const Color(0xFF1E293B);
                  textColor = const Color(0xFF64748B);
                }
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: InkWell(
                  onTap: hasAnswered ? null : () => onChoiceSelected(choice.id, choice.text),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor, width: hasAnswered && (isCorrectChoice || isSelected) ? 2 : 1),
                      boxShadow: hasAnswered && (isCorrectChoice || isSelected)
                          ? [
                              BoxShadow(
                                color: borderColor.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: labelColor,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: statusIcon ??
                                Text(
                                  label,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            choice.text,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: textColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
            // Feedback Panel
            if (hasAnswered && lastResult != null) ...[
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: lastResult!.success
                      ? const Color(0xFF064E3B).withOpacity(0.3)
                      : const Color(0xFF7F1D1D).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: lastResult!.success ? const Color(0xFF10B981).withOpacity(0.5) : const Color(0xFFEF4444).withOpacity(0.5),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          lastResult!.success ? Icons.check_circle : Icons.cancel,
                          color: lastResult!.success ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          lastResult!.success ? UIText.get('correct', language) : UIText.get('incorrect', language),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: lastResult!.success ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: lastResult!.success ? const Color(0xFF10B981).withOpacity(0.2) : const Color(0xFFEF4444).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${lastResult!.energyChange > 0 ? '+' : ''}${lastResult!.energyChange} ${UIText.get('energyChange', language)}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: lastResult!.success ? const Color(0xFF34D399) : const Color(0xFFF87171),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      lastResult!.feedback,
                      style: const TextStyle(
                        color: Color(0xFFE2E8F0),
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: UIText.get('nextLevel', language),
                onPressed: onProceedToNext,
                fullWidth: true,
                icon: const Icon(Icons.arrow_forward, color: Colors.white),
              ),
            ],
            const SizedBox(height: 24),
          ],
        ),
      ),
    ));
  }
}

