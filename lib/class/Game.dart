class Game {
  final String id;
  final String name;
  final List<dynamic> platforms;
  final String coverImage;
  final String logo,trailerUrl;
  final String summary;
  final List<dynamic> images;
  Game({this.id, this.name, this.platforms, this.coverImage,this.logo,this.trailerUrl,this.summary,this.images});
  factory Game.fromJson(Map<String,dynamic> json){
    try{

      return Game(logo: json.values.last['logo']['imageUrl'],id: json.values.last['_id'],name: json.values.last["name"]);
    }catch(err){
      print(err);
      return null;
    }
    
  }
}

class ListGame {
  final List<Game> games;
  ListGame({this.games}); 
  factory ListGame.fromJson(List<dynamic> parsedJson) {
    var _games = <Game>[];
    try {
      for(var item in parsedJson){
        //print(item['video']['trailer']);
        _games.add(Game(
          id: item['_id'],
          name: item['name'],
          platforms: item['platforms'] as List<dynamic>,
          coverImage: item['coverImage']['imageUrl'],
          trailerUrl: item['video']['trailer'],
          logo: item['logo']['imageUrl'],
          summary:item['summary'],
          images:item['images']
          ));
      }
    } catch (e) {
      print(e);
      return ListGame(games: []);
    }
    /*for (var item in parsedJson) {
      var platforms = item["platforms"];
      List<String> listPlatform = List<String>.from(platforms);
      
      
      
    }*/
    return ListGame(games: _games);
  }
}
