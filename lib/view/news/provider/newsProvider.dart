import 'dart:convert';

import 'package:gamming_community/class/News.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:http/http.dart' as http;

class NewsProvider extends StatesRebuilder {
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
      rebuildStates();
    } catch (e) {
      this.isError = true;
      rebuildStates();
    }
  }

  void setLoading(bool loading) {
    this.isLoading = loading;
    rebuildStates();
  }

  void init() async {
    await fetchNews();
    rebuildStates();
  }
}
