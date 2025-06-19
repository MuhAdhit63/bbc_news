// lib/views/login_page.dart
import 'package:bbc_news/routes/route_names.dart';
import 'package:bbc_news/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart'; // Asumsi MainPage ada di sini
import 'register_page.dart'; // Untuk navigasi ke halaman register

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController(text: 'news@itg.ac.id');
  final _passwordController = TextEditingController(text: 'ITG#news');
  bool _isLoading = false;

  Future<void> _login() async {

    setState(() {
      _isLoading = true;
    });


    try {
      await Provider.of<AuthService>(
        context,
        listen: false,
      ).login(_emailController.text, _passwordController.text);
    } catch (error, stackTrace) {

      showDialog(
        context: context,
        builder:
            (ctx) => AlertDialog(
              title: Text('Login Gagal'),
              content: Text(error.toString()),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () => Navigator.of(ctx).pop(),
                ),
              ],
            ),
      );
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Warna dari gambar
    const Color primaryTextColor = Color(0xFFD4AF37); // Emas untuk teks judul dan link
    const Color loginButtonColor = Color(0xFFFFD149); // Kuning untuk tombol login
    const Color textFieldBackgroundColor = Color(0xFFE0E0E0); // Abu-abu muda untuk field

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFF9C74F).withOpacity(0.8), // Oranye-kuning di atas
              Color(0xFF4D908E).withOpacity(0.7), // Biru-abu di bawah
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start, // Untuk "Login" title
              children: [
                Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(70.0),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/logo.png'), // Ganti dengan path logo Anda
                      fit: BoxFit.cover,
                      opacity: 0.5,
                    ),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(height: 5), // Kompensasi untuk logo

                      // Email Field
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'youremail@example.com',
                          filled: true,
                          fillColor: textFieldBackgroundColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                        ),
                      ),
                      SizedBox(height: 20),

                      // Password Field
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'password',
                          filled: true,
                          fillColor: textFieldBackgroundColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                        ),
                      ),
                      SizedBox(height: 25), // Jarak sebelum logo bawah
                      SizedBox(height: 25),

                      // Login Button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: loginButtonColor,
                          padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          foregroundColor: Colors.black87,
                        ),
                        onPressed: _login,
                        child: Text('Login'),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25),
                // Switch to Register
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Doesn't have account? ",
                      style: TextStyle(color: Colors.white70, fontSize: 15),
                    ),
                    GestureDetector(
                      onTap: () {
                        context.goNamed(RouteNames.register); 
                      },
                      child: Text(
                        'Register',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 57, 245, 229),
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20), // Padding bawah
              ],
            ),
          ),
        ),
      ),
    );
  }
}