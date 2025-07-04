import 'package:bbc_news/views/home_screen.dart';
import 'package:bbc_news/views/login_page.dart';
import 'package:bbc_news/views/profil_screen.dart';
import 'package:bbc_news/views/register_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../views/splash_screen.dart';
import 'package:bbc_news/routes/route_names.dart';

class AppRouter {
  AppRouter._();

  static final AppRouter _instance = AppRouter._();

  static AppRouter get instance => _instance;

  factory AppRouter() {
    return _instance;
  }

  late final GoRouter goRouter = _setupRouter();

  static GoRouter _setupRouter() {
    return GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          name: RouteNames.splash,
          pageBuilder: (context, state) => MaterialPage(child: SplashScreen()),
        ),
        GoRoute(
          path: '/home',
          name: RouteNames.home,
          pageBuilder: (context, state) => MaterialPage(child: HomeScreen()),
        ),
        GoRoute(
          path: '/login',
          name: RouteNames.login,
          pageBuilder: (context, state) => MaterialPage(child: LoginPage()),
        ),
        GoRoute(
          path: '/register',
          name: RouteNames.register,
          pageBuilder: (context, state) => MaterialPage(child: RegisterPage()),
        ),
        GoRoute(
          path: '/profile',
          name: RouteNames.profile,
          pageBuilder: (context, state) => MaterialPage(child: ProfilePage()),
        ),
      ],
    );
  }
}
