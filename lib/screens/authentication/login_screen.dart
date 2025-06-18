import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:inkingi/services/auth_service.dart';

import 'package:inkingi/constants/colors.dart';
import 'package:inkingi/routes/app_routes.dart';
import 'package:inkingi/utils/Transition/transitionUtils.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  // final _authService = AuthService();
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    Navigator.of(context).push(
      AppTransitions.fadeReplacementNamed(
        AppRoutes.dashboard,
        duration: const Duration(milliseconds: 400),
      ),
    );

    // if (_isLoading) return;

    // setState(() {
    //   _isLoading = true;
    // });

    // try {
    //   final request = LoginRequest(
    //     username: _usernameController.text,
    //     password: _passwordController.text,
    //   );
    //   final response = await _authService.login(request);
    //   Provider.of<AuthProvider>(context, listen: false).setAuthData(
    //     userId: response.userId,
    //     token: response.token,
    //   );
    //   Navigator.of(context).push(
    //     AppTransitions.fadeReplacementNamed(
    //       AppRoutes.dashboard,
    //       duration: const Duration(milliseconds: 400),
    //     ),
    //   );
    // } catch (e) {
    //   TToast.show(
    //     context: context,
    //     message: e.toString(),
    //     isSuccess: false,
    //   );
    // } finally {
    //   setState(() {
    //     _isLoading = false;
    //   });
    // }
  }

  void _navigateToRegister() {
    Navigator.of(context).push(
      AppTransitions.fadeReplacementNamed(
        AppRoutes.register,
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
                    Transform.translate(
                      offset: const Offset(0, -145),
                      child: SvgPicture.asset(
                        'assets/svgs/bk_logo.svg',
                        height: 118,
                        width: 88,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 40),
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
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isLoading
                            ? AppColors.greyColor500
                            : AppColors.primaryColorLight,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 150,
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
                              'Login',
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: _navigateToRegister,
                      child: Text(
                        'Don’t have an account? Register',
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
