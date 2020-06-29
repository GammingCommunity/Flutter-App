import 'package:gamming_community/API/config/subAuth.dart';
import 'package:gamming_community/utils/get_token.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class SubRepo{
  
  static Future<QueryResult> queryGraphQL(String token,String query){
    GraphQLClient client = subAPI(token);
    var result = client.query(QueryOptions(
      documentNode: gql(query)
    ));
    return result;
  }
  static Future<QueryResult> mutationGraphQL(String token,String mutate) async{
    GraphQLClient client = subAPI(await getToken());
    var result = client.mutate(MutationOptions(
      documentNode: gql(mutate)
    ));
    return result;
  }

  

}