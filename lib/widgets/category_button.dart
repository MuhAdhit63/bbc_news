import 'package:bbc_news/utils/helper.dart';
import 'package:bbc_news/views/all_categories_screen.dart';
import 'package:bbc_news/views/criminal_screen.dart';
import 'package:bbc_news/views/hiburan_screen.dart';
import 'package:bbc_news/views/politic_screen.dart';
import 'package:bbc_news/views/sport_screen.dart';
import 'package:flutter/material.dart';
import '../views/detail_page.dart';

class CategoryButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color iconColor;
  final String navigationPageName;

  const CategoryButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.backgroundColor,
    this.iconColor = Colors.white,
    required this.navigationPageName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (navigationPageName == "politics"){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PoliticScreen()
            )
          );
        } else if (navigationPageName == "entertainment") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HiburanScreen()
            )
          );
        } else if (navigationPageName == "sports") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SportScreen()
            )
          );
        } else if (navigationPageName == "criminal") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CriminalScreen()
            )
          );
        } else if (navigationPageName == "all") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AllCategoriesScreen()
            )
          );
        }
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => DetailPage(pageTitle: navigationPageName),)
        // );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: Offset(0, 2),
                )
              ]
            ),
            child: Icon(icon, color: iconColor, size: 28.0),
          ),
          if(label.isNotEmpty) AppSpacing.vertical(6.0),
          if(label.isNotEmpty)
            Text(
              label,
              style: TextStyle(fontSize: 10.0, color: Colors.black54),
              textAlign: TextAlign.center,
            )
        ],
      ),
    );
  }
}
