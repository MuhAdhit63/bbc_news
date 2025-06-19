// lib/views/main_page.dart
import 'package:bbc_news/routes/route_names.dart';
import 'package:bbc_news/services/auth_service.dart';
import 'package:bbc_news/services/bookmark_service.dart';
import 'package:bbc_news/services/news_service.dart';
import 'package:bbc_news/views/bookmark_articles_page.dart';
import 'package:bbc_news/views/news_detail_page.dart';
import 'package:bbc_news/views/profil_screen.dart';
import 'package:bbc_news/views/reading_history_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
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
  int _currentBottomNavIndex = 0;
  late List<Article> _articles;
  List<Article> _readHistoryArticles = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final token = Provider.of<AuthService>(context, listen: false).token;
      Provider.of<NewsService>(context, listen: false).fetchAllNews(token);
      Provider.of<BookmarkService>(context, listen: false).loadBookmarks();
    });
  }

  void _navigateToDetail(String pageName) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailPage(pageTitle: pageName)),
    );
  }

  void _toggleBookmark(String articleId) {
    setState(() {
      final articleIndex = _articles.indexWhere(
        (article) => article.id == articleId,
      );
      if (articleIndex != -1) {
        _articles[articleIndex].isBookmarked =
            !_articles[articleIndex].isBookmarked;
      }
      final historyIndex = _readHistoryArticles.indexWhere(
        (article) => article.id == articleId,
      );
      if (historyIndex != -1) {
        _readHistoryArticles[historyIndex].isBookmarked =
            _articles[articleIndex].isBookmarked;
      }
    });
  }

  void _addArticleToHistory(Article article) {
    setState(() {
      _readHistoryArticles.removeWhere((a) => a.id == article.id);
      _readHistoryArticles.insert(0, article);

      if (_readHistoryArticles.length > 10) {
        _readHistoryArticles = _readHistoryArticles.sublist(0, 10);
      }
    });
  }

  void _navigateToNewsDetail(Article article) {
    _addArticleToHistory(article);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => NewsDetailPage(
              article: article,
              onToggleBookmark: _toggleBookmark,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthService>(context, listen: false).user;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[200], // Latar belakang utama halaman
      body: Consumer<NewsService>(
        builder: (context, newsService, child) {
          if (newsService.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (newsService.allNews.isEmpty) {
            return const Center(
              child: Text('Tidak ada berita yang ditemukan.'),
            );
          }

          final newsList = newsService.allNews;
          return RefreshIndicator(
            onRefresh: () async {
              final token =
                  Provider.of<AuthService>(context, listen: false).token;
              await newsService.fetchAllNews(token);
            },
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Section (Search Bar and Image)
                    _buildHeader(context, screenWidth),

                    // User Info Card
                    Container(
                      margin: EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 16,
                        bottom: 20,
                      ), // Geser ke atas sedikit
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromARGB(255, 253, 203, 138),
                          width: 1,
                        ),
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
                            backgroundImage: AssetImage(
                              'assets/images/logo.png',
                            ), // GANTI INI
                            backgroundColor: Colors.grey[200],
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              user!.fullName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          _buildIconButton(
                            context,
                            Icons.history,
                            "Riwayat Baca",
                          ),
                          SizedBox(width: 8),
                          _buildIconButton(
                            context,
                            Icons.bookmark_border,
                            "Bookmark",
                          ),
                        ],
                      ),
                    ),

                    // Categories Section
                    _buildCategoriesSection(context),

                    // News Articles Section
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Latest News",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () => _navigateToDetail("Semua Berita"),
                            child: Text(
                              "see more >>",
                              style: TextStyle(
                                color: Colors.orangeAccent,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics:
                          NeverScrollableScrollPhysics(), // Agar bisa di-scroll di dalam SingleChildScrollView
                      itemCount: newsList.length,
                      itemBuilder: (context, index) {
                        final article = newsList[index];
                        if (index < 3) {
                          return GestureDetector(
                            onTap: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder:
                              //         (context) => NewsDetailPage(
                              //           article: article,
                              //           onToggleBookmark: onToggleBookmark,
                              //         ),
                              //   ),
                              // );
                            },
                            child: Card(
                              margin: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12),
                                    ),
                                    child: Image.network(
                                      '$article.featuredImageUrl!',
                                      height: 180,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (
                                        context,
                                        error,
                                        stackTrace,
                                      ) {
                                        return Container(
                                          height: 180,
                                          width: double.infinity,
                                          color: Colors.grey[300],
                                          child: Image.asset(
                                            'assets/images/article3.png',
                                            height: 180,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  Consumer<BookmarkService>(
                                    builder:
                                        (
                                          ctx,
                                          bookmarkService,
                                          child,
                                        ) => Positioned(
                                          top: 8,
                                          right: 8,
                                          child: Material(
                                            color: Colors.transparent,
                                            child: IconButton(
                                              icon: Icon(
                                                bookmarkService.isBookmarked(
                                                      article.id!,
                                                    )
                                                    ? Icons.bookmark
                                                    : Icons.bookmark_border,
                                                color:
                                                    bookmarkService
                                                            .isBookmarked(
                                                              article.id!,
                                                            )
                                                        ? Theme.of(
                                                          context,
                                                        ).primaryColor
                                                        : Colors.grey,
                                                size: 28,
                                              ),
                                              onPressed: () {
                                                bookmarkService.toggleBookmark(
                                                  article.id!,
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          article.title!,
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 6),
                                        Text(
                                          'By: ${article.author!}',
                                          style: TextStyle(
                                            color: Colors.orange,
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 6),
                                        Text(
                                          article.content!,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey[700],
                                          ),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 8),
                                        // Text(
                                        //   'By ${article.author} in ${article.category}',
                                        //   style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey[600]),
                                        // ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      },
                    ),
                    SizedBox(height: 20), // Spacer di bawah
                  ],
                ),
              ),
            ),
          );
        },
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
            context.goNamed(
              RouteNames.bookmark,
              extra: BookmarkedArticlesPageArgs(
                allArticles: _articles,
                onToggleBookmark: _toggleBookmark,
              ),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
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
              colorFilter: ColorFilter.mode(
                // Efek gelap pada gambar
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
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 10.0,
            ),
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
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Find news articles...',
                      icon: Icon(Icons.search, color: Colors.grey),
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey[600]),
                    ),
                    onSubmitted:
                        (value) => _navigateToDetail("Hasil Pencarian: $value"),
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
                      Shadow(
                        blurRadius: 5.0,
                        color: Colors.black.withOpacity(0.5),
                        offset: Offset(1.0, 1.0),
                      ),
                    ],
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

  Widget _buildIconButton(
    BuildContext context,
    IconData icon,
    String pageName,
  ) {
    return InkWell(
      onTap: () {
        if (pageName == "Bookmark") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => BookmarkedArticlesPage(
                    allArticles: _articles,
                    onToggleBookmark: _toggleBookmark,
                  ),
            ),
          );
        } else if (pageName == "Riwayat Baca") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => ReadingHistoryPage(
                    readArticles: _readHistoryArticles,
                    onNavigateToDetail: _navigateToNewsDetail,
                    onToggleBookmark: _toggleBookmark,
                  ),
            ),
          );
        }
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color.fromARGB(255, 253, 190, 108),
            width: 1,
          ),
          color: Colors.grey[200], // Warna latar tombol ikon
          borderRadius: BorderRadius.circular(25),
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
              CategoryButton(
                icon: Icons.account_balance_outlined,
                label: 'Politics',
                backgroundColor: Color(0xFFFDE7E7),
                iconColor: Color(0xFFD9534F),
                navigationPageName: 'politics',
              ),
              CategoryButton(
                icon: Icons.movie_creation_outlined,
                label: 'Entertainment',
                backgroundColor: Color(0xFFE7F5FD),
                iconColor: Color(0xFF5BC0DE),
                navigationPageName: 'entertainment',
              ),
              CategoryButton(
                icon: Icons.sports_basketball_outlined,
                label: 'Sports',
                backgroundColor: Color(0xFFE8F5E9),
                iconColor: Color(0xFF5CB85C),
                navigationPageName: 'sports',
              ),
              CategoryButton(
                icon: Icons.local_police_outlined,
                label: 'Criminal',
                backgroundColor: Color(0xFFECEFF1),
                iconColor: Color(0xFF37474F),
                navigationPageName: 'criminal',
              ),
              CategoryButton(
                icon: Icons.apps_outlined,
                label: '',
                backgroundColor: Colors.grey.shade200,
                iconColor: Colors.black54,
                navigationPageName: 'all',
              ),
            ],
          ),
          SizedBox(height: 8),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
