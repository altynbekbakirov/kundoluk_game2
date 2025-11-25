import 'package:flutter/material.dart';

class EnergyBar extends StatelessWidget {
  final int current;
  final int max;
  final String label;

  const EnergyBar({
    Key? key,
    required this.current,
    this.max = 100,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final percentage = (current / max * 100).clamp(0.0, 100.0);
    
    Color barColor = Colors.green;
    if (percentage < 50) barColor = Colors.amber;
    if (percentage < 20) barColor = Colors.red;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.bolt,
                    color: Colors.yellow[600],
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: const TextStyle(
                      color: Color(0xFF818CF8),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Text(
                '$current/$max',
                style: const TextStyle(
                  color: Color(0xFFE2E8F0),
                  fontFamily: 'monospace',
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 16,
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Stack(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 1000),
                    width: MediaQuery.of(context).size.width * (percentage / 100),
                    decoration: BoxDecoration(
                      color: barColor,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.2),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

