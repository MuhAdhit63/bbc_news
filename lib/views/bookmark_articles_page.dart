// lib/views/bookmarked_articles_page.dart
import 'package:bbc_news/routes/route_names.dart';
import 'package:bbc_news/services/bookmark_service.dart';
import 'package:bbc_news/services/news_service.dart';
import 'package:bbc_news/views/home_screen.dart';
import 'package:bbc_news/views/news_detail_page.dart';
import 'package:bbc_news/views/profil_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/article_model.dart';
import '../widgets/news_card.dart';
import '../widgets/bottom_navigation_bar.dart';

class BookmarkedArticlesPage extends StatelessWidget {
  const BookmarkedArticlesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final bookmarkedArticles = _getBookmarkedArticles();

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
      ),
      body: Consumer<BookmarkService>(
        builder: (context, bookmarkService, child) {
          return Consumer<NewsService>(
            builder: (context, newsService, child) {
              final bookmarkedArticles =
                  newsService.allNews
                      .where(
                        (article) => bookmarkService.isBookmarked(article.id!),
                      )
                      .toList();
              return Column(
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
                  Divider(thickness: 1, color: Colors.grey[300]),
                  Expanded(
                    child:
                        bookmarkedArticles.isEmpty
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
                              itemCount: bookmarkedArticles.length,
                              itemBuilder: (context, index) {
                                final article = bookmarkedArticles[index];
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                      bookmarkService
                                                              .isBookmarked(
                                                                article.id!,
                                                              )
                                                          ? Icons.bookmark
                                                          : Icons
                                                              .bookmark_border,
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
                                                      bookmarkService
                                                          .toggleBookmark(
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
                              },
                            ),
                  ),
                ],
              );
            },
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
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
}
