class News {
  String url;
  String imageUrl;
  String shortText;
  String time;
  News({this.url, this.shortText, this.imageUrl, this.time});
}

class ListNews {
  List<News> listNews;
  ListNews({this.listNews});
  factory ListNews.fromJson(List<dynamic> json) {
    List<News> _listNews = [];
    try {
      json.forEach((e) {
        _listNews.add(News(
            shortText: e['article_short'],
            imageUrl: e['article_image'],
            url: e['article_url'],
            time: DateTime.now().difference(DateTime.parse(e['release_date'])).inDays.toString()));
      });
    } catch (e) {
      return ListNews(listNews: []);
    }
    return ListNews(listNews: _listNews);
  }
}
