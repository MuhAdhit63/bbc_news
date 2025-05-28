// lib/views/main_page.dart
import 'package:bbc_news/routes/route_names.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/article_model.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../widgets/category_button.dart';
import '../widgets/news_card.dart';
import 'detail_page.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentBottomNavIndex = 0; // Untuk bottom nav jika ingin stateful

  void _navigateToDetail(String pageName) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => DetailPage(pageTitle: pageName)));
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[200], // Latar belakang utama halaman
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section (Search Bar and Image)
              _buildHeader(context, screenWidth),

              // User Info Card
              _buildUserInfoCard(context),

              // Categories Section
              _buildCategoriesSection(context),

              // News Articles Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Latest News",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () => _navigateToDetail("Semua Berita"),
                      child: Text(
                        "see more >>",
                        style: TextStyle(color: Colors.orangeAccent, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(), // Agar bisa di-scroll di dalam SingleChildScrollView
                itemCount: dummyArticles.length,
                itemBuilder: (context, index) {
                  return NewsCard(article: dummyArticles[index]);
                },
              ),
              SizedBox(height: 20), // Spacer di bawah
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentBottomNavIndex,
        onTap: (index) {
          // Logika untuk bottom navigation jika diperlukan state di HomeScreen
          // Contoh: setState(() => _currentBottomNavIndex = index);
          // Atau navigasi langsung seperti yang sudah diimplementasikan di widgetnya
          if (index == 0) {
            // Anda sudah di Beranda atau bisa refresh/kembali ke atas
          } else if (index == 1) {
            _navigateToDetail('Semua Kategori');
          } else if (index == 2) {
            context.goNamed(RouteNames.profile);
          }
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, double screenWidth) {
    return Stack(
      children: [
        // Background Image (Header)
        Container(
          height: 220, // Sesuaikan tinggi
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/article2.png'), // GANTI INI
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode( // Efek gelap pada gambar
                Colors.orange.withOpacity(0.4),
                BlendMode.darken,
              ),
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(80),
              bottomRight: Radius.circular(80),
            ),
          ),
        ),

        // Content on Header
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                 // Search Bar
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                     boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                          offset: Offset(0,2)
                        )
                      ]
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Find news articles...',
                      icon: Icon(Icons.search, color: Colors.grey),
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey[600])
                    ),
                    onSubmitted: (value) => _navigateToDetail("Hasil Pencarian: $value"),
                  ),
                ),
                Spacer(), // Mendorong teks ke bawah
                Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18, // Sesuaikan ukuran
                    fontWeight: FontWeight.w600,
                    shadows: [
                      Shadow(blurRadius: 5.0, color: Colors.black.withOpacity(0.5), offset: Offset(1.0, 1.0)),
                    ]
                  ),
                ),
                SizedBox(height: 25), // Jarak dari bawah header
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserInfoCard(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 20), // Geser ke atas sedikit
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(255, 253, 203, 138), width: 1),
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundImage: AssetImage('assets/images/logo.png'), // GANTI INI
            backgroundColor: Colors.grey[200],
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "Cepi Mulyadi",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
          _buildIconButton(context, Icons.history, "Riwayat Baca"),
          SizedBox(width: 8),
          _buildIconButton(context, Icons.bookmark_border, "Bookmark"),
        ],
      ),
    );
  }

  Widget _buildIconButton(BuildContext context, IconData icon, String pageName) {
    return InkWell(
      onTap: () => _navigateToDetail(pageName),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: EdgeInsets.all(8),
         decoration: BoxDecoration(
          border: Border.all(color: const Color.fromARGB(255, 253, 190, 108), width: 1),
          color: Colors.grey[200], // Warna latar tombol ikon
          borderRadius: BorderRadius.circular(25)
        ),
        child: Icon(icon, color: Colors.grey[700], size: 22),
      ),
    );
  }

  Widget _buildCategoriesSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Tombol Kategori
              CategoryButton(icon: Icons.account_balance_outlined, label: 'Politics', backgroundColor: Color(0xFFFDE7E7), iconColor: Color(0xFFD9534F), navigationPageName: 'Kategori Politik'),
              CategoryButton(icon: Icons.movie_creation_outlined, label: 'Entertainment', backgroundColor: Color(0xFFE7F5FD), iconColor: Color(0xFF5BC0DE), navigationPageName: 'Kategori Hiburan'),
              CategoryButton(icon: Icons.sports_basketball_outlined, label: 'Sports', backgroundColor: Color(0xFFE8F5E9), iconColor: Color(0xFF5CB85C), navigationPageName: 'Kategori Olahraga'),
              CategoryButton(icon: Icons.local_police_outlined, label: 'Criminal', backgroundColor: Color(0xFFECEFF1), iconColor: Color(0xFF37474F), navigationPageName: 'Kategori Kriminal'),
              CategoryButton(icon: Icons.apps_outlined, label: '', backgroundColor: Colors.grey.shade200, iconColor: Colors.black54, navigationPageName: 'Semua Kategori'),
            ],
          ),
          SizedBox(height: 8),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}