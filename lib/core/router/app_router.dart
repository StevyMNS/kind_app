import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kind_app/presentation/screens/history_screen.dart';
import 'package:kind_app/presentation/screens/home_screen.dart';
import 'package:kind_app/presentation/screens/onboarding_screen.dart';
import 'package:kind_app/presentation/screens/receive_screen.dart';
import 'package:kind_app/presentation/screens/settings_screen.dart';
import 'package:kind_app/presentation/screens/splash_screen.dart';
import 'package:kind_app/presentation/screens/write_screen.dart';
import 'package:kind_app/presentation/widgets/scaffold_with_bottom_nav.dart';

/// Configuration du routeur GoRouter avec BottomNav.
final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // Splash
    GoRoute(
      path: '/',
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),

    // Onboarding
    GoRoute(
      path: '/onboarding',
      name: 'onboarding',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const OnboardingScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    ),

    // Shell avec BottomNav pour les 4 onglets principaux
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithBottomNav(navigationShell: navigationShell);
      },
      branches: [
        // Branche 0 — Accueil
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              name: 'home',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: HomeScreen(),
              ),
            ),
          ],
        ),

        // Branche 1 — Écrire
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/write',
              name: 'write',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: WriteScreen(),
              ),
            ),
          ],
        ),

        // Branche 2 — Recevoir
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/receive',
              name: 'receive',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: ReceiveScreen(),
              ),
            ),
          ],
        ),

        // Branche 3 — Historique
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/history',
              name: 'history',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: HistoryScreen(),
              ),
            ),
          ],
        ),
      ],
    ),

    // Settings — hors du shell (écran modal)
    GoRoute(
      path: '/settings',
      name: 'settings',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const SettingsScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          final tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: Curves.easeOutCubic),
          );
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    ),
  ],
);
