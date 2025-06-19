import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bbc_news/views/home_screen.dart';
import 'package:bbc_news/views/login_page.dart';
import 'package:bbc_news/services/auth_service.dart';

class AuthCheckScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (ctx, auth, _) => auth.isAuth
          ? HomeScreen()
          : FutureBuilder(
              future: auth.tryAutoLogin(),
              builder: (ctx, authResultSnapshot) =>
                  authResultSnapshot.connectionState == ConnectionState.waiting
                      ? Scaffold(
                          body: Center(child: CircularProgressIndicator()),
                        )
                      : LoginPage(),
            ),
    );
  }
}