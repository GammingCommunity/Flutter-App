import 'package:flutter/cupertino.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

GraphQLClient mainAPI(String token) {
  HttpLink httpLink =
      HttpLink(uri: "https://gmgraphql.glitch.me/graphql", headers: {"token": token});

  return GraphQLClient(
    cache: NormalizedInMemoryCache(dataIdFromObject: typenameDataIdFromObject),
    link: httpLink,
  );
}

ValueNotifier<GraphQLClient> customClient(String token) {
  Link httpLink = HttpLink(uri: "https://gmgraphql.glitch.me/graphql", headers: {"token": token});
  var client = ValueNotifier(GraphQLClient(
      cache: NormalizedInMemoryCache(dataIdFromObject: typenameDataIdFromObject), link: httpLink));
  return client;
}

ValueNotifier<GraphQLClient> subscriptionClient(String token) {
 /* Link link = HttpLink(
    uri: 'https://gmgraphql.glitch.me/graphql',
     headers: {"token": token}
    );*/
  WebSocketLink socketLink = WebSocketLink(
    url: 'ws://gmgraphql.glitch.me/graphql',
    
    config: SocketClientConfig(
      autoReconnect: true,
      inactivityTimeout: Duration(seconds: 30),
      
    ),
  );
  
  //var links = link.concat(socketLink);
  return ValueNotifier(
    GraphQLClient(
      cache: InMemoryCache(),
      link: socketLink,
    ),
  );
}
