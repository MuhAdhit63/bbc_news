import 'package:flutter/material.dart';
import 'criminal_screen.dart';
import 'politic_screen.dart';
import 'hiburan_screen.dart';
import 'sport_screen.dart';

class AllCategoriesScreen extends StatelessWidget {
  const AllCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFFFFA726),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0, 3),
                  blurRadius: 4,
                ),
              ],
            ),
            width: double.infinity,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  color: Colors.black,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const Text(
                  'BBC',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.black,
                  ),
                ),
                const Text(
                  'erita',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 24,
                    color: Colors.black,
                  ),
                ),
                const Text(
                  '.com',
                  style: TextStyle(fontSize: 24, color: Color(0xFF4A90E2)),
                ),
              ],
            ),
          ),

          // Konten
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  'Pilih Kategori Berita',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                _buildCategoryCard(
                  context,
                  title: 'Politik',
                  description:
                      'Berita terbaru tentang dunia politik, pemerintahan, dan kebijakan publik.',
                  imagePath: 'assets/images/logo.png',
                  screen: const PoliticScreen(),
                ),
                _buildCategoryCard(
                  context,
                  title: 'Hiburan',
                  description:
                      'Info artis, film, musik, dan dunia hiburan lainnya.',
                  imagePath: 'assets/images/logo.png',
                  screen: const HiburanScreen(),
                ),
                _buildCategoryCard(
                  context,
                  title: 'Olahraga',
                  description:
                      'Update seputar sepak bola, badminton, F1, dan olahraga dunia.',
                  imagePath: 'assets/images/logo.png',
                  screen: const SportScreen(),
                ),
                _buildCategoryCard(
                  context,
                  title: 'Kriminal',
                  description:
                      'Berita investigasi, kriminalitas, dan hukum terkini.',
                  imagePath: 'assets/images/logo.png',
                  screen: const CriminalScreen(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context, {
    required String title,
    required String description,
    required String imagePath,
    required Widget screen,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: Image.asset(
                imagePath,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Icon(Icons.arrow_forward_ios, size: 16),
            ),
          ],
        ),
      ),
    );
  }
}
