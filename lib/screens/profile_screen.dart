import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inkingi/components/TProfileAvatar.dart';

import 'package:inkingi/constants/colors.dart';
import 'package:inkingi/routes/app_routes.dart';
import 'package:inkingi/screens/loans_screen.dart';
import 'package:inkingi/utils/Transition/transitionUtils.dart';
import 'package:inkingi/widgets/credit_profile.dart';

class ProfileScreen extends StatefulWidget {
  static const String routeName = '/profile';

  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // final _authProvider = AuthProvider();
  bool _isLoading = false;
  String _userName = "Tusifu Edison";
  String _companyName = "Inkingi Corp";
  List<String> _allowedPeople = [
    "Tom",
    "Jane",
    "Sarah",
    "Jan"
  ]; // Placeholder data
  List<Map<String, String>> _options = [
    {"title": "Hindura umwirondoro", "icon": "edit", "route": "/editProfile"},
    {"title": "Guhindura", "icon": "settings", "route": "/settings"},
    {"title": "Amatangazo", "icon": "notifications", "route": "/notifications"},
    {"title": "Add Product", "icon": "add", "route": "/addProduct"},
    {"title": "Gusohoka", "icon": "logout", "route": "/login"},
  ]; // Placeholder options

  @override
  void initState() {
    super.initState();
    // _loadProfileData();
  }

  // void _loadProfileData() async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   try {
  //     // Simulate API call to fetch profile data
  //     await Future.delayed(const Duration(seconds: 1));
  //     // In a real app, replace with actual data from AuthProvider or API
  //     final userId = _authProvider.userId;
  //     if (userId != null) {
  //       // Fetch actual user name, company name, and allowed people list here
  //     }
  //   } catch (e) {
  //     TToast.show(
  //       context: context,
  //       message: e.toString(),
  //       isSuccess: false,
  //     );
  //   } finally {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }
  // }

  void _navigateToRoute(String route) {
    if (route == "/login") {
      // _authProvider.clearAuthData();
    }
    Navigator.of(context).push(
      AppTransitions.fadeReplacementNamed(
        route,
        duration: const Duration(milliseconds: 400),
      ),
    );
  }

  void _navigateToAllowedPeople() {
    // Navigator.of(context).push(
    //   AppTransitions.fadeNamed(
    //     AppRoutes.allowedPeople,
    //     duration: const Duration(milliseconds: 400),
    //   ),
    // );
  }

  void _navigateToDashboard() {
    Navigator.of(context).push(
      AppTransitions.fadeReplacementNamed(
        AppRoutes.dashboard,
        duration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header with Back Button and Logo
            Container(
              padding: const EdgeInsets.only(left: 16.0, right: 16, top: 8),
              color: AppColors.primaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: _navigateToDashboard,
                  ),
                  SvgPicture.asset(
                    'assets/svgs/bk_logo.svg',
                    height: 40,
                    width: 60,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
                        ),
                      )
                    : ListView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                        ),
                        children: [
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                right: 5.0,
                                bottom: 5.0,
                              ),
                              child: ProfileAvatar(
                                initial: "T",
                                size: 100.0,
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed(AppRoutes.profile);
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Center(
                            child: Text(
                              _userName,
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Center(
                            child: Text(
                              _companyName,
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Options Tiles
                          ..._options.map((option) {
                            return Card(
                              color: AppColors.cardBackgroundColor,
                              elevation: 2,
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                leading: Icon(
                                  _getIconData(option['icon']!),
                                  color: AppColors.textSecondary,
                                ),
                                title: Text(
                                  option['title']!,
                                  style: GoogleFonts.outfit(
                                    color: AppColors.textSecondary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                trailing: const Icon(Icons.chevron_right,
                                    color: Colors.grey),
                                onTap: () => _navigateToRoute(option['route']!),
                              ),
                            );
                          }).toList(),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                AppTransitions.fadeNamed(
                                  LoansScreen.routeName,
                                ),
                              );
                            },
                            child: CreditProfile(),
                          ),
                          const SizedBox(height: 16),
                          // Allowed People Section
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.cardBackgroundColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Abakozi bajye',
                                  style: GoogleFonts.outfit(
                                    color: AppColors.textSecondary,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: _allowedPeople.map((name) {
                                    return CircleAvatar(
                                      radius: 25,
                                      backgroundColor: Colors.grey[800],
                                      child: Text(
                                        name[0],
                                        style: GoogleFonts.outfit(
                                          color: AppColors.textSecondary,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                                const SizedBox(height: 16),
                                Center(
                                  child: ElevatedButton(
                                    onPressed: _navigateToAllowedPeople,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          AppColors.primaryColorLight,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 32,
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Text(
                                      'Barebe bose',
                                      style: GoogleFonts.outfit(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'edit':
        return Icons.edit;
      case 'settings':
        return Icons.settings;
      case 'notifications':
        return Icons.notifications;
      case 'logout':
        return Icons.logout;
      default:
        return Icons.error;
    }
  }
}
