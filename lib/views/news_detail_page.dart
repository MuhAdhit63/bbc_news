// lib/views/news_detail_page.dart
import 'package:flutter/material.dart';
import '../models/article_model.dart';
// import 'package:intl/intl.dart';

class NewsDetailPage extends StatefulWidget {
  final Article article;
  final Function(String articleId) onToggleBookmark; // Fungsi dari MainPage

  const NewsDetailPage({
    Key? key,
    required this.article,
    required this.onToggleBookmark,
  }) : super(key: key);

  @override
  _NewsDetailPageState createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage> {
  late bool _isBookmarkedLocal;

  @override
  void initState() {
    super.initState();
    // Ambil status bookmark awal dari artikel yang diterima
    _isBookmarkedLocal = widget.article.isBookmarked;
  }

  void _handleToggleBookmark() {
    // Panggil fungsi toggle utama yang ada di MainPage
    widget.onToggleBookmark(widget.article.id);
    // Perbarui state lokal untuk ikon di halaman ini
    setState(() {
      _isBookmarkedLocal = !_isBookmarkedLocal;
    });
  }

  String _formatDateManually(DateTime date) {
    const List<String> monthsNames = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    if (date.month < 1 || date.month > 12) {
      return "${date.day} BulanTidakValdi ${date.year}";
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
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true, // Atau false jika ingin rata kiri
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Judul Artikel
              Text(
                widget.article.title,
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
                  widget.article.imageUrl,
                  width: double.infinity,
                  height: 220, // Sesuaikan tinggi gambar
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 220,
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: Icon(Icons.broken_image, color: Colors.grey[600], size: 50),
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
                      "Author: ${widget.article.author} - ${_formatDateManually(widget.article.publishedDate)} - ${widget.article.category}",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      _isBookmarkedLocal ? Icons.bookmark : Icons.bookmark_border,
                      color: _isBookmarkedLocal ? Theme.of(context).colorScheme.primary : Colors.grey[700],
                      size: 26,
                    ),
                    onPressed: _handleToggleBookmark,
                    tooltip: _isBookmarkedLocal ? 'Hapus Bookmark' : 'Tambah Bookmark',
                  ),
                ],
              ),
              SizedBox(height: 16),
              Divider(), // Pemisah
              SizedBox(height: 16),

              // Isi Artikel
              Text(
                widget.article.articleBody,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.6, // Jarak antar baris
                  color: Colors.black.withOpacity(0.8),
                ),
                textAlign: TextAlign.justify, // Rata kiri-kanan
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: CustomBottomNavigationBar(...),
    );
  }
}