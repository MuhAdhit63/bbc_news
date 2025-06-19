import 'package:bbc_news/services/auth_service.dart';
import 'package:bbc_news/services/bookmark_service.dart';
import 'package:bbc_news/services/news_service.dart';
import 'package:bbc_news/views/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:bbc_news/routes/app_route.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => AuthService()),
        ChangeNotifierProvider(create: (ctx) => BookmarkService()),
        ChangeNotifierProvider(create: (ctx) => NewsService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "BBC News",
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
            fontFamily: 'Poppins',
            visualDensity: VisualDensity.adaptivePlatformDensity,
            useMaterial3: true,
          ),
          home: SplashScreen(),
          // routerConfig: AppRouter().goRouter,
        );
      },
    );
  }
}
