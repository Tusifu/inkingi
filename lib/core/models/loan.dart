class Loan {
  final String title;
  final String description;
  final double amount;
  final double apr;
  final String duration;
  bool isEligible;

  Loan({
    required this.title,
    required this.description,
    required this.amount,
    required this.apr,
    required this.duration,
    required this.isEligible,
  });
}
