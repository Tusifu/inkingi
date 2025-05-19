import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inkingi/constants/colors.dart';

class ProfileAvatar extends StatelessWidget {
  final String initial; // User's initial (e.g., first letter of name)
  final double size; // Size of the avatar (default to 40 for small size)
  final VoidCallback? onTap; // Optional tap callback

  const ProfileAvatar({
    Key? key,
    required this.initial,
    this.size = 40.0,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              AppColors.primaryColorLight,
              AppColors.primaryColor,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: Colors.white,
            width: 2.0,
          ),
        ),
        child: Center(
          child: Text(
            initial.toUpperCase(),
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: size * 0.5,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
