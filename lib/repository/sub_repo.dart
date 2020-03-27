import 'package:gamming_community/API/subAuth.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class SubRepo{
  
  static Future<QueryResult> queryGraphQL(String token,String query){
    GraphQLClient client = subAPI(token);
    var result = client.query(QueryOptions(
      documentNode: gql(query)
    ));
    return result;
  }
  static Future<QueryResult> mutationGraphQL(String token,String mutate){
    GraphQLClient client = subAPI(token);
    var result = client.mutate(MutationOptions(
      documentNode: gql(mutate)
    ));
    return result;
  }

  

}