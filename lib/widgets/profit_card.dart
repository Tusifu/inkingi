import 'package:flutter/material.dart';

class ProfitCard extends StatelessWidget {
  final String title;
  final double amount;
  final double percentageChange;
  final bool isPositive;

  const ProfitCard({
    super.key,
    required this.title,
    required this.amount,
    required this.percentageChange,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: amount > 0
              ? [
                  Color.fromARGB(255, 28, 68, 115),
                  Color.fromARGB(255, 15, 60, 111),
                  Color.fromARGB(255, 8, 28, 51),
                ]
              : [
                  const Color.fromARGB(255, 126, 35, 35), // Dark red
                  const Color.fromARGB(255, 125, 40, 40),
                  const Color.fromARGB(255, 53, 25, 25), // Lighter red
                ],
        ),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} RWF',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 30, 45, 66),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.arrow_upward,
                      color: Colors.white,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$percentageChange%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Icon(
              Icons.trending_up,
              color: Colors.white.withOpacity(0.2),
              size: 30, // Reduced from 40 to 30
            ),
          ),
        ],
      ),
    );
  }
}
