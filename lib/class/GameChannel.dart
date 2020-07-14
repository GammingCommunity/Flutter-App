class GameChannelM{
  String id;
  String gameName;
  String banner;
  int count;
  GameChannelM({this.id,this.gameName,this.banner,this.count});

}
class GameChannelsM{
  List<GameChannelM> channels;
  GameChannelsM({this.channels});
  factory GameChannelsM.json(List<dynamic> json){
    List<GameChannelM> _channels= [];
    try {
      json.forEach((e) {
        _channels.add(GameChannelM(id: e['_id'],gameName: e['name'],banner: e['banner'],count: e['count']));
       });
    } catch (e) {
      return GameChannelsM(channels: []);
    }
    return GameChannelsM(channels: _channels);
  }
}