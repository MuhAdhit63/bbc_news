import 'package:bbc_news/routes/route_names.dart';
import 'package:bbc_news/utils/helper.dart';
import 'package:bbc_news/views/detail_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex; // Tanda
  final Function(int)? onTap; // Callback untuk menangani perubahan indeks

  const CustomBottomNavigationBar({
    Key? key,
    this.currentIndex = 0,
    this.onTap,
  }) : super(key: key); 

  void _navigateToPage(BuildContext context, String pageName) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailPage(pageTitle: pageName),)
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color activeColor = Colors.orangeAccent;
    const Color inactiveColor = Colors.grey;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        boxShadow:  [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, -2), 
          ),
        ]
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap ?? (index) {
            if (index == 0) context.goNamed(RouteNames.home);
            if (index == 1) _navigateToPage(context, 'Semua Kategori');
            if (index == 2) context.goNamed(RouteNames.profile);
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: activeColor,
          unselectedItemColor: inactiveColor,
          showUnselectedLabels: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_outlined),
              activeIcon: Icon(Icons.grid_view_rounded),
              label: 'Kategori',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profil',
            ),

          ],
        ),
      ),
    );
  }
}