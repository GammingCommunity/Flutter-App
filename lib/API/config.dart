import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class Config {
  static HttpLink httpLink =
      HttpLink(uri: "https://main-service.mattstacey.now.sh/");
  
 
  ValueNotifier<GraphQLClient> client =
      ValueNotifier(GraphQLClient(cache: OptimisticCache(dataIdFromObject: typenameDataIdFromObject), link: httpLink));

  GraphQLClient clientToQueryMongo() {
    return GraphQLClient(
      cache: OptimisticCache(dataIdFromObject: typenameDataIdFromObject),
      link: httpLink,
    );
  }
  
}
