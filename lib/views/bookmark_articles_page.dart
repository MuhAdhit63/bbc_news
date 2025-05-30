// lib/views/bookmarked_articles_page.dart
import 'package:bbc_news/routes/route_names.dart';
import 'package:bbc_news/utils/helper.dart';
import 'package:bbc_news/views/news_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/article_model.dart';
import '../widgets/news_card.dart';
import '../widgets/bottom_navigation_bar.dart'; // Asumsi path ini benar

class BookmarkedArticlesPageArgs {
  final List<Article> allArticles;
  final Function(String articleId) onToggleBookmark;

  BookmarkedArticlesPageArgs({
    required this.allArticles,
    required this.onToggleBookmark,
  });
}

class BookmarkedArticlesPage extends StatefulWidget {
  final List<Article> allArticles; // Menerima semua artikel
  final Function(String articleId)
  onToggleBookmark; // Fungsi untuk toggle bookmark dari MainPage

  const BookmarkedArticlesPage({
    Key? key,
    required this.allArticles,
    required this.onToggleBookmark,
  }) : super(key: key);

  @override
  _BookmarkedArticlesPageState createState() => _BookmarkedArticlesPageState();
}

class _BookmarkedArticlesPageState extends State<BookmarkedArticlesPage> {
  int _currentBottomNavIndex = 1;
  late List<Article> _bookmarkedArticles;
  List<Article> _readHistoryArticles = [];

  @override
  void initState() {
    super.initState();
    _filterBookmarkedArticles();
  }

  @override
  void didUpdateWidget(BookmarkedArticlesPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Jika daftar artikel utama berubah (misalnya dari shared_prefs di MainPage), filter ulang
    _filterBookmarkedArticles();
  }

  void _filterBookmarkedArticles() {
    // Filter artikel yang di-bookmark dari daftar semua artikel
    setState(() {
      _bookmarkedArticles =
          widget.allArticles.where((article) => article.isBookmarked).toList();
    });
  }

  void _handleToggleBookmarkOnThisPage(String articleId) {
    // Panggil fungsi toggle utama dari MainPage
    widget.onToggleBookmark(articleId);
    // Setelah status di MainPage (source of truth) diubah, filter ulang daftar di halaman ini
    // Perubahan pada widget.allArticles (karena isBookmarked diubah di MainPage) akan memicu didUpdateWidget
    // atau kita bisa langsung filter ulang di sini untuk efek instan jika MainPage tidak mengirim ulang widget tree
    _filterBookmarkedArticles();
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

  void _toggleBookmark(String articleId) {
    setState(() {
      final articleIndex = _bookmarkedArticles.indexWhere(
        (article) => article.id == articleId,
      );
      if (articleIndex != -1) {
        _bookmarkedArticles[articleIndex].isBookmarked =
            !_bookmarkedArticles[articleIndex].isBookmarked;
      }
      final historyIndex = _readHistoryArticles.indexWhere(
        (article) => article.id == articleId,
      );
      if (historyIndex != -1) {
        _readHistoryArticles[historyIndex].isBookmarked =
            _bookmarkedArticles[articleIndex].isBookmarked;
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
    // Warna AppBar seperti di gambar referensi (BBCerita.com)
    const Color appBarBackgroundColor = Color(0xFFF9A825); // Oranye-kuning
    const Color appBarTextColor = Colors.black87;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarBackgroundColor,
        elevation: 1,
        title: Text(
          'BBCerita.com', // Sesuai gambar referensi
          style: TextStyle(
            color: appBarTextColor,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: appBarTextColor,
        ), // Untuk tombol kembali
        actions: [
          // Anda bisa menambahkan ikon search atau filter di sini jika perlu
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "All Saved", // Sesuai gambar referensi
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Colors.black87,
              ),
            ),
          ),
          AppDivider.spaceDivider(thickness: 1, color: Colors.grey[300]!),
          Expanded(
            child:
                _bookmarkedArticles.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.bookmark_outline,
                            size: 80,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Belum ada artikel yang disimpan.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      itemCount: _bookmarkedArticles.length,
                      itemBuilder: (context, index) {
                        final article = _bookmarkedArticles[index];
                        return NewsCard(
                          article: article,
                          onToggleBookmark:
                              (id) =>
                                  _handleToggleBookmarkOnThisPage(article.id),
                          onCardTap: () => _navigateToNewsDetail(article),
                        );
                      },
                    ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentBottomNavIndex,
        onTap: (index) {
          // Logika navigasi untuk bottom nav bar dari halaman ini
          // Misalnya, kembali ke MainPage atau halaman lain
          if (index == 0) {
            // Contoh: Tombol Home
            // Cek apakah MainPage sudah ada di stack, jika ya pop until, jika tidak pushReplacement
            context.goNamed(RouteNames.home);
          } else if (index == 1) {
            // Contoh: Tombol Kategori
            // Navigasi ke halaman kategori
            // Sama seperti di atas, Anda mungkin ingin kembali ke MainPage dan pindah tab,
            // atau push halaman kategori baru jika logikanya berbeda.
          } else if (index == 2) {
            // Contoh: Tombol Profil
            context.goNamed(RouteNames.profile);
          }
        },
      ),
    );
  }
}
