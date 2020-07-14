import 'dart:convert';

import 'package:gamming_community/class/News.dart';
import 'package:http/http.dart' as http;

class NewsProvider {
  var newsAPI = "https://gaming-news.glitch.me/fetchNews";
  var news = <News>[];

  Future fetchNews() async {
    try {
      var response = await http.get(newsAPI);
      var result = ListNews.fromJson(json.decode(response.body)).listNews;
      news.addAll(result);
      news.sort((a, b) => DateTime.parse(a.time).difference(DateTime.parse(a.time)).inMinutes);
    } catch (e) {}
  }

  Future init() async {
    await fetchNews();
  }
}
