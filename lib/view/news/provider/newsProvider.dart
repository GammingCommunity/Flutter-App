import 'dart:convert';

import 'package:gamming_community/class/News.dart';
import 'package:http/http.dart' as http;

class NewsProvider {
  var newsAPI = "https://gaming-news.glitch.me/fetchNews";
  var news = <News>[];
  var isLoading = true;
  var isError = false;

  Future fetchNews() async {
    try {
      var response = await http.get(newsAPI);
      var result = ListNews.fromJson(json.decode(response.body)).listNews;
      setLoading(false);
      news.addAll(result);
    } catch (e) {
      this.isError = true;
    }
  }

  void setLoading(bool loading) {
    this.isLoading = loading;
  }

  void init() async {
    await fetchNews();
  }
}
