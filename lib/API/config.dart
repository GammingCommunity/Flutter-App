import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class Config {
  static HttpLink httpLink2 =
      HttpLink(uri: "https://gmgraphql.glitch.me/graphql");
  
 
  ValueNotifier<GraphQLClient> client =
      ValueNotifier(GraphQLClient(cache: OptimisticCache(dataIdFromObject: typenameDataIdFromObject), link: httpLink2));

  

  GraphQLClient clientToQueryMongo() {
    return GraphQLClient(
      cache: OptimisticCache(dataIdFromObject: typenameDataIdFromObject),
      link: httpLink2,
    );
  }
  
}
