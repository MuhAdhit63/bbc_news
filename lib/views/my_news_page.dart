// lib/views/reading_history_page.dart
import 'package:bbc_news/models/news_article.dart';
import 'package:bbc_news/services/api_service.dart';
import 'package:bbc_news/services/auth_service.dart';
import 'package:bbc_news/views/add_edit_news_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/article_model.dart';
import '../widgets/history_article_card.dart'; // Impor kartu riwayat
import '../widgets/bottom_navigation_bar.dart'; // Impor bottom nav jika perlu

class MyNewsPage extends StatefulWidget {
  const MyNewsPage({super.key});

  @override
  State<MyNewsPage> createState() => _MyNewsPageState();
}

class _MyNewsPageState extends State<MyNewsPage> {
  late Future<List<NewsArticle>> _myNewsFuture;

  @override
  void initState() {
    super.initState();
    _loadMyNews();
  }

  void _loadMyNews() {
    final token = Provider.of<AuthService>(context, listen: false).token;
    setState(() {
      _myNewsFuture = ApiService(token).getMyNews();
    });
  }

  void _editArticle(NewsArticle article) {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => AddEditNewsScreen(article: article),
          ),
        )
        .then((_) => _loadMyNews());
  }

  void _navigateToAddEditScreen([NewsArticle? article]) {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (ctx) => AddEditNewsScreen(article: article),
          ),
        )
        .then((_) => _loadMyNews());
  }

  Future<void> _deleteArticle(String articleId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Konfirmasi Hapus'),
            content: const Text(
              'Apakah Anda yakin ingin menghapus berita ini?',
            ),
            actions: [
              TextButton(
                child: const Text('Batal'),
                onPressed: () => Navigator.of(ctx).pop(false),
              ),
              TextButton(
                child: const Text('Hapus'),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                onPressed: () => Navigator.of(ctx).pop(true),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      try {
        final token = Provider.of<AuthService>(context, listen: false).token;
        await ApiService(token).deleteNews(articleId);
        _loadMyNews();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal menghapus berita: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    const Color appBarBackgroundColor = Color(0xFFF9A825);
    const Color appBarTextColor = Colors.black87;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarBackgroundColor,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: appBarTextColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'BBCerita.com | My News',
          style: TextStyle(
            color: appBarTextColor,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            fontFamily: 'Roboto',
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<NewsArticle>>(
        future: _myNewsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Text('Anda belum membuat berita apapun.'),
              ),
            );
          }
          final myNewsList = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            itemCount: myNewsList.length,
            itemBuilder: (context, index) {
              final article = myNewsList[index];
              return InkWell(
                child: Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Gambar Thumbnail
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6.0),
                          child: Image.network(
                            '$article.featuredImageUrl!',
                            width: 100, // Lebar gambar lebih kecil
                            height: 80, // Tinggi gambar
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 100,
                                height: 80,
                                color: Colors.grey[200],
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
                        SizedBox(width: 12),
                        // Judul dan Ringkasan
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                article.title,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
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
                                maxLines: 2, // Lebih pendek dari NewsCard utama
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.edit_outlined,
                            size: 16,
                          ),
                          onPressed: () => _editArticle(article),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.redAccent,
                            size: 16,
                          ),
                          onPressed: () => _deleteArticle(article.id!),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      // Halaman riwayat pada gambar tidak memiliki bottom navigation bar.
      // Jika Anda ingin menambahkannya, uncomment baris di bawah.
      // bottomNavigationBar: CustomBottomNavigationBar(
      //   currentIndex: -1, // Tidak ada yang aktif
      //   onTap: (idx) {
      //     // Logika navigasi jika bottom nav ditekan dari halaman ini
      //   },
      // ),
      floatingActionButton: FloatingActionButton(
        child: Text(
          'Add',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () => _navigateToAddEditScreen(),
      ),
    );
  }
}
