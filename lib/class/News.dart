class News {
  String url;
  String source;
  String imageUrl;
  String shortText;
  String time;
  News({this.url, this.shortText, this.source, this.imageUrl, this.time});
}

class ListNews {
  List<News> listNews;
  ListNews({this.listNews});
  factory ListNews.fromJson(List<dynamic> json) {
    List<News> _listNews = [];
    try {
      json.forEach((e) {
        _listNews.add(News(
            source: e['source'],
            shortText: e['article_short'],
            imageUrl: e['article_image'],
            url: e['article_url'],
            time: DateTime.now().difference(DateTime.parse(e['article_time'])).inDays.toString()));
      });
    } catch (e) {
      return ListNews(listNews: []);
    }
    return ListNews(listNews: _listNews);
  }
}
