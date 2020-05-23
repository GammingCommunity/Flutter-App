import 'package:gamming_community/API/config/mainAuth.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class PostRepo{
   static Future<QueryResult> queryGraphQL(String token ,String query){
    GraphQLClient client = postAPI(token);
    var result = client.query(QueryOptions(
      documentNode: gql(query)
    ));
    return result;
  }
  static Future<QueryResult> queryWithVariable(String token ,String query,Map<String,dynamic> variables){
    GraphQLClient client = postAPI(token);
    var result = client.query(QueryOptions(
      variables: variables,
      documentNode: gql(query)
    ));
    return result;
  }
  static Future<QueryResult> mutateWithVariable(String token ,String query,Map<String,dynamic> variables){
    GraphQLClient client = postAPI(token);
    var result = client.query(QueryOptions(
      variables: variables,
      documentNode: gql(query)
    ));
    return result;
  }
  static Future<QueryResult> mutationGraphQL(String token ,String mutate){
    GraphQLClient client = postAPI(token);
    var result = client.mutate(MutationOptions(
      documentNode: gql(mutate)
    ));
    return result;
  }
}