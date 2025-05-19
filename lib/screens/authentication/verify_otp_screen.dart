import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inkingi/components/TToast.dart';
import 'package:inkingi/providers/auth_provider.dart';
import 'package:inkingi/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:inkingi/constants/colors.dart';
import 'package:inkingi/routes/app_routes.dart';
import 'package:inkingi/utils/Transition/transitionUtils.dart';

class VerifyOtpScreen extends StatefulWidget {
  static const String routeName = '/verifyOtp';

  const VerifyOtpScreen({Key? key}) : super(key: key);

  @override
  _VerifyOtpScreenState createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final _otpController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _handleVerifyOtp() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final userId = Provider.of<AuthProvider>(context, listen: false).userId;
      if (userId == null) {
        throw 'User ID not found. Please register again.';
      }
      final activationCode = _otpController.text.trim();
      if (activationCode.isEmpty) {
        throw 'Please enter the activation code.';
      }
      final response = await _authService.activateUser(userId, activationCode);
      TToast.show(
        context: context,
        message: response.message,
        isSuccess: true,
      );
      Navigator.of(context).push(
        AppTransitions.fadeReplacementNamed(
          AppRoutes.login,
          duration: const Duration(milliseconds: 400),
        ),
      );
    } catch (e) {
      TToast.show(
        context: context,
        message: e.toString(),
        isSuccess: false,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SvgPicture.asset(
              'assets/svgs/vector1.svg',
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                AppColors.primaryColorLight,
                BlendMode.srcIn,
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Transform.translate(
                      offset: const Offset(0, -20),
                      child: SvgPicture.asset(
                        'assets/svgs/bk_logo.svg',
                        height: 118,
                        width: 88,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Text(
                      'Verify Your Account',
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Enter the OTP sent to your email or phone',
                      style: GoogleFonts.outfit(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.outfit(color: Colors.white),
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        hintText: 'Enter OTP',
                        hintStyle: GoogleFonts.outfit(color: Colors.white70),
                        filled: true,
                        fillColor: Colors.grey[900],
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.greyColor500,
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.greyColor300,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _handleVerifyOtp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isLoading
                            ? AppColors.greyColor500
                            : AppColors.primaryColorLight,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'Verify OTP',
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
