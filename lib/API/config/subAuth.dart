
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

GraphQLClient subAPI(String token) {
  HttpLink httpLink = HttpLink(
      uri: "https://derogative-percenta.000webhostapp.com/graphql",
      headers: {"token": token});

  //GraphQLClient client = GraphQLClient(link: httpLink, cache: InMemoryCache());
  return GraphQLClient(
      cache: OptimisticCache(dataIdFromObject: typenameDataIdFromObject),
      link: httpLink,
    );
  
}
 ValueNotifier<GraphQLClient> customSubClient(String token) {
    HttpLink httpLink = HttpLink(
      uri: "https://derogative-percenta.000webhostapp.com/graphql",
      headers: {"token": token});
    var client = ValueNotifier(GraphQLClient(
      cache: OptimisticCache(dataIdFromObject: typenameDataIdFromObject), link: httpLink));
    return client;
 }
      
