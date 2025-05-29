// lib/widgets/history_article_card.dart
import 'package:flutter/material.dart';
import '../models/article_model.dart';

class HistoryArticleCard extends StatelessWidget {
  final Article article;
  final VoidCallback onTap; // Callback saat kartu ditekan

  const HistoryArticleCard({
    Key? key,
    required this.article,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell( // Menggunakan InkWell untuk efek ripple saat ditekan
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gambar Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(6.0),
                child: Image.asset(
                  article.imageUrl,
                  width: 100, // Lebar gambar lebih kecil
                  height: 80, // Tinggi gambar
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 100,
                      height: 80,
                      color: Colors.grey[200],
                      child: Icon(Icons.broken_image, color: Colors.grey, size: 40),
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
                      article.summary,
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
            ],
          ),
        ),
      ),
    );
  }
}