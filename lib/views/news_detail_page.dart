// lib/views/news_detail_page.dart
import 'package:bbc_news/models/news_article.dart';
import 'package:flutter/material.dart';
import '../models/article_model.dart';

class NewsDetailPage extends StatelessWidget {
  final NewsArticle article;

  const NewsDetailPage({super.key, required this.article});

  String _formatDateManually(DateTime date) {
    const List<String> monthsNames = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    if (date.month < 1 || date.month > 12) {
      return "${date.day} BulanTidakValid ${date.year}";
    }
    String monthName = monthsNames[date.month - 1];
    return "${date.day} $monthName ${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    const Color appBarBackgroundColor = Color(0xFFF9A825); // Oranye-kuning
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
            fontWeight: FontWeight.w900,
            fontStyle: FontStyle.italic,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Judul Artikel
              Text(
                article.title,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 12),

              // Gambar Header Artikel
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  '$article.featuredImageUrl!',
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 220,
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
              SizedBox(height: 12),

              // Info Penulis, Tanggal, Kategori & Tombol Bookmark
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      "Author: ${article.author!} - 19 June 2025 - ${article.category}",
                      style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // IconButton(
                  //   icon: Icon(
                  //     article.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  //     color: article.isBookmarked
                  //         ? Theme.of(context).colorScheme.primary
                  //         : Colors.grey[700],
                  //     size: 26,
                  //   ),
                  //   onPressed: () => onToggleBookmark(article.id),
                  //   tooltip: article.isBookmarked ? 'Hapus Bookmark' : 'Tambah Bookmark',
                  // ),
                ],
              ),
              SizedBox(height: 16),
              Divider(),
              SizedBox(height: 16),

              // Isi Artikel
              Text(
                article.content!,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.6,
                  color: Colors.black.withOpacity(0.8),
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
