import 'package:bbc_news/models/article_model.dart';
import 'package:bbc_news/routes/route_names.dart';
import 'package:bbc_news/services/auth_service.dart';
import 'package:bbc_news/views/bookmark_articles_page.dart';
import 'package:bbc_news/views/home_screen.dart';
import 'package:bbc_news/views/my_news_page.dart';
import 'package:bbc_news/views/splash_screen.dart';
import 'package:bbc_news/widgets/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _currentBottomNavIndex = 2;

  late List<Article> _articles;

  @override
  void initState() {
    super.initState();
    _articles =
        dummyArticles
            .map(
              (article) => Article(
                id: article.id,
                title: article.title,
                summary: article.summary,
                imageUrl: article.imageUrl,
                author: article.author,
                category: article.category,
                publishedDate: article.publishedDate,
                articleBody: article.articleBody,
                isBookmarked: article.isBookmarked,
              ),
            )
            .toList();
  }

  void _handleLogOut() async {
    await Provider.of<AuthService>(context, listen: false).logout();
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SplashScreen()),
      );
    }
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
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthService>(context, listen: false).user;
    final Color primaryColor = const Color(0xFFF59E0B); // Oranye terang
    final Color backgroundColor = const Color(0xFFFFFFFF); // Putih
    final Color textColor = const Color(0xFF000000); // Hitam
    final Color secondaryTextColor = const Color(0xFF6B7280); // Abu-abu gelap

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'User Profile',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            fontFamily: 'Roboto',
          ),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryColor.withOpacity(0.3), Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            primaryColor.withOpacity(0.2),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                    const CircleAvatar(
                      radius: 56,
                      backgroundImage: AssetImage('assets/images/logo.png'),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      user!.fullName,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.verified,
                      color: Colors.blueAccent,
                      size: 20,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${user!.email}',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                    SizedBox(width: 4),
                    Text(
                      'Bergabung sejak 2021',
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          const Divider(thickness: 1),
          _buildStats(),
          const Divider(thickness: 1),
          _buildFavorites(textColor),
          const Divider(thickness: 1),
          _buildAbout(textColor),
          const Divider(thickness: 1),
          _buildButtons(context, primaryColor),
          const SizedBox(height: 20),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentBottomNavIndex,
        onTap: (index) {
          setState(() {
            _currentBottomNavIndex = index;
          });
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BookmarkedArticlesPage()),
            );
          } else if (index == 2) {}
        },
      ),
    );
  }

  Widget _buildStats() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Activity',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              _StatItem(title: 'Read Articles', value: '122'),
              _StatItem(title: 'Followed Topics', value: '9'),
              _StatItem(title: 'Bookmark', value: '15'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFavorites(Color textColor) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Favorite Topics',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _TopicChip('sports'),
              _TopicChip('selebist'),
              _TopicChip('Politik'),
              _TopicChip('criminal'),
              _TopicChip('Internasional'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAbout(Color textColor) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About Me',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Saya adalah pembaca aktif yang tertarik pada berita teknologi, politik, dan isu global. '
            'Saya menggunakan aplikasi ini untuk mendapatkan informasi terpercaya dan up-to-date setiap hari.',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[800],
              height: 1.5,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  Widget _buildButtons(BuildContext context, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyNewsPage()),
              );
            },
            icon: const Icon(Icons.newspaper_outlined),
            label: const Text('My News'),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: _handleLogOut,
            icon: const Icon(Icons.logout_sharp),
            label: const Text('Logout'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: BorderSide(color: Colors.red!),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              textStyle: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToDetail(String category) {
    // Implementasi navigasi ke detail
  }
}

class _StatItem extends StatelessWidget {
  final String title;
  final String value;
  const _StatItem({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(title, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
      ],
    );
  }
}

class _TopicChip extends StatelessWidget {
  final String label;
  const _TopicChip(this.label);

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      backgroundColor: Colors.grey[200],
      labelStyle: const TextStyle(fontWeight: FontWeight.w500),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    );
  }
}
