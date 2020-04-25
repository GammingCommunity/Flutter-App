class GameImage {
  String id, gameName, trailerUrl;
  GImage coverImage;
  GImage gameLogo;
  List<dynamic> imageUrl;
  GameImage({this.id, this.gameName, this.coverImage,this.gameLogo, this.imageUrl,this.trailerUrl});
  factory GameImage.fromJson(Map json){
    return GameImage(gameLogo: GImage(imageUrl:json['logo']['imageUrl'] ));
  }
}
class GImage{
  String imageUrl;
  GImage({this.imageUrl});
}

class GameImages {
  List<GameImage> listGameImage; 
  GameImages({this.listGameImage});
  factory GameImages.fromJson(List<dynamic> json) {
    var _listgameImage = <GameImage>[];
    try {
       json.forEach((e) {
      _listgameImage.add(GameImage(
          id: e['_id'],
          gameName: e['name'],
          imageUrl : e['images'],
          gameLogo: GImage(imageUrl: e['logo']['imageUrl']),
          
          ));
    });
      
    } catch (e) {
      print(e);
      return GameImages(listGameImage: []);
    }
    return GameImages(listGameImage: _listgameImage..shuffle());

    
  }
}
