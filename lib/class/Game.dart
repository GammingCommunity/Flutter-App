class Game {
  final String id;
  final String name;
  final List<String> platforms;
  final String coverImage;
  Game({this.id, this.name, this.platforms, this.coverImage});
}

class ListGame {
  final List<Game> games;
  ListGame({this.games});
  factory ListGame.fromJson(Map<String, dynamic> parsedJson) {
    List<Game> _games = List<Game>();

    for (var item in parsedJson.values.first) {
      var platforms = item["platforms"];
      List<String> listPlatform = List<String>.from(platforms);
      
      
      _games.add(Game(
          id: item['_id'],
          name: item['game_name'],
          platforms: listPlatform,
          coverImage: item["cover_image"]));
    }
    return ListGame(games: _games);
  }
}
