import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inkingi/routes/app_routes.dart';
import 'package:inkingi/providers/dashboard_provider.dart';
import 'package:inkingi/screens/SplashScreen.dart';
import 'package:inkingi/services/storage_service.dart';
import 'package:provider/provider.dart';

class InkingiApp extends StatelessWidget {
  const InkingiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Provide StorageService as a singleton
        Provider<StorageService>(
          create: (_) => StorageService(),
        ),
        // Provide DashboardProvider, injecting StorageService
        ChangeNotifierProvider<DashboardProvider>(
          create: (context) =>
              DashboardProvider(context.read<StorageService>()),
        ),
      ],
      child: MaterialApp(
        title: 'Inkingi',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: GoogleFonts.outfitTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        initialRoute: SplashScreen.routeName,
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}
