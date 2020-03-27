import 'package:gamming_community/API/config.dart';
import 'package:gamming_community/API/mainAuth.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class MainRepo{
  static Config config = Config();
  
  static Future<QueryResult> queryGraphQL(String token ,String query){
    GraphQLClient client = mainAPI(token);
    var result = client.query(QueryOptions(
      documentNode: gql(query)
    ));
    return result;
  }
  static Future<QueryResult> mutationGraphQL(String token ,String mutate){
    GraphQLClient client = mainAPI(token);
    var result = client.mutate(MutationOptions(
      documentNode: gql(mutate)
    ));
    return result;
  }

  

}