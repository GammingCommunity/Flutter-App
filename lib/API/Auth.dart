
import 'package:graphql_flutter/graphql_flutter.dart';

GraphQLClient authAPI(String token) {
  HttpLink httpLink = HttpLink(
      uri: "https://derogative-percenta.000webhostapp.com/graphql",
      headers: {"token": token});
/* ValueNotifier<GraphQLClient> client1 =
      ValueNotifier(GraphQLClient(cache: InMemoryCache(), link: httpLink));*/
  //GraphQLClient client = GraphQLClient(link: httpLink, cache: InMemoryCache());
  return GraphQLClient(
      cache: OptimisticCache(dataIdFromObject: typenameDataIdFromObject),
      link: httpLink,
    );
  
}
