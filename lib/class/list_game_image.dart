class GameImage {
  String id, gameName, logo, coverImage, trailerUrl;
  List<dynamic> imageUrl;
  GameImage({this.id, this.gameName, this.coverImage,this.logo, this.imageUrl,this.trailerUrl});
}

class ListGameImage {
  List<GameImage> listGameImage; 
  ListGameImage({this.listGameImage});
  factory ListGameImage.fromJson(List<dynamic> json) {
    var _listgameImage = <GameImage>[];
    try {
       json.forEach((e) {
      _listgameImage.add(GameImage(
          id: e['_id'],
          gameName: e['name'],
          imageUrl : e['images'],
          logo: e['logo']['imageUrl'],
          ));
    });
      
    } catch (e) {
      print(e);
      return ListGameImage(listGameImage: []);
    }
    return ListGameImage(listGameImage: _listgameImage..shuffle());

    
  }
}
