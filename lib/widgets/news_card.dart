// lib/widgets/news_card.dart
import 'package:bbc_news/views/news_detail_page.dart';
import 'package:flutter/material.dart';
import '../models/article_model.dart';
import '../views/detail_page.dart';

class NewsCard extends StatelessWidget {
  final Article article;
  final Function(String articleId) onToggleBookmark;
  final VoidCallback onCardTap;

  const NewsCard({
    Key? key,
    required this.article,
    required this.onToggleBookmark,
    required this.onCardTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onCardTap();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => NewsDetailPage(
                  article: article,
                  onToggleBookmark: onToggleBookmark,
                ),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: Image.asset(
                article.imageUrl, // Pastikan path gambar benar
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    // Placeholder jika gambar error
                    height: 180,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: Icon(
                      Icons.broken_image,
                      color: Colors.grey[600],
                      size: 50,
                    ),
                  );
                },
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Material(
                color: Colors.transparent,
                child: IconButton(
                  icon: Icon(
                    article.isBookmarked
                        ? Icons.bookmark
                        : Icons.bookmark_border,
                    color:
                        article.isBookmarked
                            ? Theme.of(context).colorScheme.primary
                            : Colors.black,
                    size: 28,
                  ),
                  onPressed: () => onToggleBookmark(article.id),
                  tooltip:
                      article.isBookmarked
                          ? 'Hapus Bookmark'
                          : 'Tambahkan Bookmark',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6),
                  Text(
                    article.summary,
                    style: TextStyle(fontSize: 13, color: Colors.grey[700]),
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
}
