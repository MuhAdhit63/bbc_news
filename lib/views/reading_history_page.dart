// lib/views/reading_history_page.dart
import 'package:flutter/material.dart';
import '../models/article_model.dart';
import '../widgets/history_article_card.dart'; // Impor kartu riwayat
import '../widgets/bottom_navigation_bar.dart'; // Impor bottom nav jika perlu

// Opsional: Jika Anda menggunakan GoRouter dan ingin meneruskan argumen via kelas
class ReadingHistoryPageArgs {
  final List<Article> readArticles;
  final Function(Article article) onNavigateToDetail;
  final Function(String articleId) onToggleBookmark;
  ReadingHistoryPageArgs({
    required this.readArticles,
    required this.onNavigateToDetail,
    required this.onToggleBookmark,
  });
}

class ReadingHistoryPage extends StatelessWidget {
  final List<Article> readArticles;
  final Function(Article article)
  onNavigateToDetail; // Untuk membuka detail dari riwayat
  final Function(String articleId)
  onToggleBookmark; // Untuk sinkronisasi bookmark jika ditampilkan di HistoryCard

  const ReadingHistoryPage({
    Key? key,
    required this.readArticles,
    required this.onNavigateToDetail,
    required this.onToggleBookmark, // Meskipun HistoryCard tidak punya tombol bookmark, ini untuk konsistensi jika NewsCard dipakai
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          'BBCerita.com',
          style: TextStyle(
            color: appBarTextColor,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            fontFamily: 'Roboto',
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
            child: Text(
              "History", // Sesuai gambar
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child:
                readArticles.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.history_edu_outlined,
                            size: 80,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Riwayat baca masih kosong.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      itemCount: readArticles.length,
                      itemBuilder: (context, index) {
                        final article = readArticles[index];
                        return HistoryArticleCard(
                          article: article,
                          onTap:
                              () => onNavigateToDetail(
                                article,
                              ), // Buka detail saat item riwayat di-tap
                        );
                      },
                    ),
          ),
        ],
      ),
      // Halaman riwayat pada gambar tidak memiliki bottom navigation bar.
      // Jika Anda ingin menambahkannya, uncomment baris di bawah.
      // bottomNavigationBar: CustomBottomNavigationBar(
      //   currentIndex: -1, // Tidak ada yang aktif
      //   onTap: (idx) {
      //     // Logika navigasi jika bottom nav ditekan dari halaman ini
      //   },
      // ),
    );
  }
}
