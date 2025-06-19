import 'package:bbc_news/views/bookmark_articles_page.dart';
import 'package:bbc_news/views/home_screen.dart';
import 'package:bbc_news/views/login_page.dart';
import 'package:bbc_news/views/profil_screen.dart';
import 'package:bbc_news/views/reading_history_page.dart';
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
    // _instance.goRouter = goRouterSetup();

    return _instance;
  }

  late final GoRouter goRouter = _setupRouter();

  static GoRouter _setupRouter() {
    // final args = BookmarkedArticlesPageArgs(
    //   allArticles: [],
    //   onToggleBookmark: (String articleId) {
    //     // Implement toggle bookmark logic here
    //   },
    // );
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
        // GoRoute(
        //   path: '/bookmark',
        //   name: RouteNames.bookmark,
        //   pageBuilder: (context, GoRouterState state) {
        //     final args = state.extra as BookmarkedArticlesPageArgs?;

        //     if (args != null) {
        //       return MaterialPage(
        //         child: BookmarkedArticlesPage(
        //           allArticles: args.allArticles,
        //           onToggleBookmark: args.onToggleBookmark,
        //         ),
        //       );
        //     } else {
        //       return MaterialPage(
        //         child: Scaffold(
        //           appBar: AppBar(title: Text("Error")),
        //           body: Center(child: Text("Argumen.....")),
        //         ),
        //       );
        //     }
        //   },
        // ),
        GoRoute(
          path: '/history',
          name: RouteNames.history,
          pageBuilder: (context, GoRouterState state) {
            final args = state.extra as ReadingHistoryPageArgs?;

            if (args != null) {
              return MaterialPage(
                child: ReadingHistoryPage(
                  readArticles: args.readArticles,
                  onNavigateToDetail: args.onNavigateToDetail,
                  onToggleBookmark: args.onToggleBookmark,
                ),
              );
            } else {
              return MaterialPage(
                child: Scaffold(
                  appBar: AppBar(title: Text("Error")),
                  body: Center(child: Text("Argumen.....")),
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
