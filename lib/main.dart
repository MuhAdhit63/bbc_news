import 'package:flutter/material.dart';
import 'package:bbc_news/routes/app_route.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:intl/intl.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // await initializeDateFormatting('id_ID', '');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: "BBC News",
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
            fontFamily: 'Poppins',
            visualDensity: VisualDensity.adaptivePlatformDensity,
            useMaterial3: true,
          ),
          routerConfig: AppRouter().goRouter,
        );
      },
      // title: 'Flutter Demo',
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      // ),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
