import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

String uri = "http://hutech.tech/graphql";
GraphQLClient subAPI(String token) {
  HttpLink httpLink = HttpLink(uri: uri, headers: {"token": token});

  //GraphQLClient client = GraphQLClient(link: httpLink, cache: InMemoryCache());
  return GraphQLClient(
    cache: OptimisticCache(dataIdFromObject: typenameDataIdFromObject),
    link: httpLink,
  );
}

ValueNotifier<GraphQLClient> customSubClient(String token) {
  HttpLink httpLink = HttpLink(uri: uri, headers: {"token": token});
  var client = ValueNotifier(GraphQLClient(
      cache: OptimisticCache(dataIdFromObject: typenameDataIdFromObject), link: httpLink));
  return client;
}
