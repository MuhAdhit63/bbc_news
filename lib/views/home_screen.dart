import 'package:bbc_news/services/auth_service.dart';
import 'package:bbc_news/services/bookmark_service.dart';
import 'package:bbc_news/services/news_service.dart';
import 'package:bbc_news/views/bookmark_articles_page.dart';
import 'package:bbc_news/views/my_news_page.dart';
import 'package:bbc_news/views/news_detail_page.dart';
import 'package:bbc_news/views/profil_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../widgets/category_button.dart';
import 'detail_page.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentBottomNavIndex = 0;

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

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthService>(context, listen: false).user;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[200],
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
                    _buildHeader(context, screenWidth),

                    Container(
                      margin: EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 16,
                        bottom: 20,
                      ),
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
                            ),
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
                            Icons.newspaper_outlined,
                            "Berita",
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

                    _buildCategoriesSection(context),

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
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: newsList.length,
                      itemBuilder: (context, index) {
                        final article = newsList[index];
                        if (index < 3) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          NewsDetailPage(article: article),
                                ),
                              );
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
          if (index == 0) {
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BookmarkedArticlesPage()),
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
        Container(
          height: 220,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/article2.png'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
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
                Spacer(),
                Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
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
                SizedBox(height: 25),
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
            MaterialPageRoute(builder: (context) => BookmarkedArticlesPage()),
          );
        } else if (pageName == "Berita") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyNewsPage()),
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
          color: Colors.grey[200],
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
