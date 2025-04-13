import 'package:flutter/material.dart';
import 'package:inkingi/routes/app_routes.dart';

class AppTransitions {
  static const Duration _defaultDuration = Duration(milliseconds: 100);

  static Route fade(Widget page, {Duration? duration}) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (context, animation, _, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      transitionDuration: duration ?? _defaultDuration,
    );
  }

  static Route fadeNamed(String routeName, {Duration? duration}) {
    return fade(
      AppRoutes.getPageFromRouteName(routeName),
      duration: duration,
    );
  }

  static Route slide(Widget page, {Duration? duration}) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (context, animation, _, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        final tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: duration ?? _defaultDuration,
    );
  }

  static Route fadeReplacementNamed(String routeName, {Duration? duration}) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => AppRoutes.getPageFromRouteName(routeName),
      transitionsBuilder: (context, animation, _, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      transitionDuration: duration ?? _defaultDuration,
      maintainState: false,
    );
  }

  static Route slideNamed(String routeName, {Duration? duration}) {
    return slide(
      AppRoutes.getPageFromRouteName(routeName),
      duration: duration,
    );
  }

  static void fadePop(BuildContext context, {Duration? duration}) {
    if (Navigator.of(context).canPop()) {
      final navigator = Navigator.of(context);
      final pages = navigator.widget.pages;

      if (pages.length < 2) {
        navigator.pop();
        return;
      }

      // Get the previous page's widget
      final previousPage = pages[pages.length - 2];
      late Widget previousWidget;
      if (previousPage is MaterialPage) {
        previousWidget = previousPage.child;
      } else {
        navigator.pop(); // Fallback to default pop
        return;
      }

      // Replace the current route with the previous one using fade
      navigator.pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, _, __) => previousWidget,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final fadeAnimation =
                Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(
              parent: secondaryAnimation,
              curve: Curves.easeInOut,
            ));
            return FadeTransition(
              opacity: fadeAnimation,
              child: child,
            );
          },
          transitionDuration: duration ?? _defaultDuration,
        ),
      );
    } else {
      Navigator.of(context).pop();
    }
  }
}
