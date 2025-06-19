import 'package:flutter/foundation.dart';
import 'package:bbc_news/models/news_article.dart';
import 'package:bbc_news/services/api_service.dart';

class NewsService with ChangeNotifier {
  List<NewsArticle> _allNews = [];
  bool _isLoading = false;

  List<NewsArticle> get allNews => _allNews;
  bool get isLoading => _isLoading;

  Future<void> fetchAllNews(String? token) async {
    if (_allNews.isEmpty) {
      _isLoading = true;
      notifyListeners();

      try {
        _allNews = await ApiService(token).getNews();
      } catch (e) {
        print("Error fetching all news: $e");
      }

      _isLoading = false;
      notifyListeners();
    }
  }
}
