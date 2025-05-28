import 'package:bbc_news/utils/helper.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final String pageTitle;

  const DetailPage({Key? key, required this.pageTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitle),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Center(
        child: Text(
          'Ini adlah halaman $pageTitle',
          style: TextStyle(fontSize: AppFontSize.large),
        ),
      ),
    );
  }
}
