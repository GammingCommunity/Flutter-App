import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/API/config.dart';
import 'package:gamming_community/class/PrivateRoom.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class GetListRoom extends StatesRebuilder{
  static GraphQLQuery query =GraphQLQuery();
  static Config config =Config();
  static GraphQLClient client = config.clientToQueryMongo();
  String userID;
  List<PrivateRoom> listPrivateRoom = [];

  GetListRoom({this.userID});
  
  void initRoom() async{
    var result = await client.query(QueryOptions(documentNode: gql(query.getPrivateMessage(userID))));
    print("Data ${result.data}");
  }
}