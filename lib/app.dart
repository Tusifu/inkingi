import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inkingi/routes/app_routes.dart';
import 'package:inkingi/providers/dashboard_provider.dart';
import 'package:inkingi/screens/dashboard_screen.dart';
import 'package:provider/provider.dart';

class InkingiApp extends StatelessWidget {
  const InkingiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
      ],
      child: MaterialApp(
        title: 'Inkingi',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: GoogleFonts.outfitTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        initialRoute: DashboardScreen.routeName,
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}
