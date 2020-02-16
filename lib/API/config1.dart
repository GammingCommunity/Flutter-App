import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class Config1 {
  static HttpLink httpLink =
      HttpLink(uri: "https://derogative-percenta.000webhostapp.com/graphql");
  ValueNotifier<GraphQLClient> client1 =
      ValueNotifier(GraphQLClient(cache: InMemoryCache(), link: httpLink));
  GraphQLClient clientToQuery() {
    return GraphQLClient(
      cache: OptimisticCache(dataIdFromObject: typenameDataIdFromObject),
      link: httpLink,
    );
  }
}
