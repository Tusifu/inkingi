import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:inkingi/constants/colors.dart';
import 'package:inkingi/routes/app_routes.dart';
import 'package:inkingi/utils/Transition/transitionUtils.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = '/splashScreen';

  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateAfterDelay();
  }

  Future<void> _navigateAfterDelay() async {
    await Future.delayed(
      const Duration(seconds: 3),
    );

    if (!mounted) return;

// first navigate to signin after to dashboard

    Navigator.of(context).push(
      AppTransitions.fadeReplacementNamed(
        AppRoutes.login,
        duration: const Duration(milliseconds: 400),
      ),
    );

    // if (hasSeenOnboarding) {
    //   if (isLoggedIn) {
    //     // Navigate to HomePage if user is logged in
    //     Navigator.of(context).push(
    //       AppTransitions.fadeReplacementNamed(
    //         AppRoutes.home, // Assuming '/homePage' is the route for HomePage
    //         duration: const Duration(milliseconds: 400),
    //       ),
    //     );
    //   } else {
    //     // Navigate to SignInPage if user is not logged in
    //     Navigator.of(context).push(
    //       AppTransitions.fadeReplacementNamed(
    //         AppRoutes.dashboard,
    //         duration: const Duration(milliseconds: 400),
    //       ),
    //     );
    //   }
    // }
    // else {
    //   // Navigate to OnboardingPage if user hasn't seen onboarding
    //   Navigator.of(context).push(
    //     AppTransitions.fadeReplacementNamed(
    //       AppRoutes.onboarding,
    //       duration: const Duration(milliseconds: 400),
    //     ),
    //   );
    // }
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
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 50),
                SvgPicture.asset(
                  height: 118,
                  width: 88,
                  "assets/svgs/bk_logo.svg",
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
