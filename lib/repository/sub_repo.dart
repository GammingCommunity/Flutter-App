import 'package:gamming_community/API/config/subAuth.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubRepo{
  
  static Future<QueryResult> queryGraphQL(String token,String query){
    GraphQLClient client = subAPI(token);
    var result = client.query(QueryOptions(
      documentNode: gql(query)
    ));
    return result;
  }
  static Future<QueryResult> mutationGraphQL(String token,String mutate) async{
    SharedPreferences ref =await SharedPreferences.getInstance();
    GraphQLClient client = subAPI(ref.getStringList("userToken")[2]);
    var result = client.mutate(MutationOptions(
      documentNode: gql(mutate)
    ));
    return result;
  }

  

}