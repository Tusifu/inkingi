import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inkingi/components/TToast.dart';

import 'package:inkingi/constants/colors.dart';
import 'package:inkingi/models/register_models.dart';
import 'package:inkingi/routes/app_routes.dart';
import 'package:inkingi/services/auth_service.dart';
import 'package:inkingi/utils/Transition/transitionUtils.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = '/register';

  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _usernameController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _passwordController.dispose();
    _phoneNumberController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final request = RegisterRequest(
        email: _emailController.text,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        password: _passwordController.text,
        phoneNumber: _phoneNumberController.text,
        username: _usernameController.text,
      );
      await _authService.register(request);
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

  void _navigateToLogin() {
    Navigator.of(context).push(
      AppTransitions.fadeReplacementNamed(
        AppRoutes.login,
        duration: const Duration(milliseconds: 400),
      ),
    );
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
                    SvgPicture.asset(
                      'assets/svgs/bk_logo.svg',
                      height: 118,
                      width: 88,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 40),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: GoogleFonts.outfit(color: Colors.white),
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        hintText: 'Email',
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
                    const SizedBox(height: 16),
                    TextField(
                      controller: _firstNameController,
                      keyboardType: TextInputType.text,
                      style: GoogleFonts.outfit(color: Colors.white),
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        hintText: 'First Name',
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
                    const SizedBox(height: 16),
                    TextField(
                      controller: _lastNameController,
                      keyboardType: TextInputType.text,
                      style: GoogleFonts.outfit(color: Colors.white),
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        hintText: 'Last Name',
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
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      style: GoogleFonts.outfit(color: Colors.white),
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        hintText: 'Password',
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
                    const SizedBox(height: 16),
                    TextField(
                      controller: _phoneNumberController,
                      keyboardType: TextInputType.phone,
                      style: GoogleFonts.outfit(color: Colors.white),
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        hintText: 'Phone Number (e.g., 0726666939)',
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
                    const SizedBox(height: 16),
                    TextField(
                      controller: _usernameController,
                      keyboardType: TextInputType.text,
                      style: GoogleFonts.outfit(color: Colors.white),
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        hintText: 'Username',
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
                      onPressed: _isLoading ? null : _handleRegister,
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
                              'Register',
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: _navigateToLogin,
                      child: Text(
                        'Already have an account? Login',
                        style: GoogleFonts.outfit(
                          color: Colors.white70,
                          fontSize: 14,
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
