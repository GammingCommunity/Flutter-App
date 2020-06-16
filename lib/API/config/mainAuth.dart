import 'package:flutter/cupertino.dart';
import 'package:gamming_community/API/URLEndpoint.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

GraphQLClient mainAPI(String token) {
  HttpLink httpLink =
      HttpLink(uri: URLEndpoint.mainService, headers: {"token": token});

  return GraphQLClient(
    cache: NormalizedInMemoryCache(dataIdFromObject: typenameDataIdFromObject),
    link: httpLink,
  );
}

GraphQLClient postAPI(String token) {
  HttpLink httpLink =
      HttpLink(uri: URLEndpoint.postService, headers: {"token": token});

  return GraphQLClient(
    cache: NormalizedInMemoryCache(dataIdFromObject: typenameDataIdFromObject),
    link: httpLink,
  );
}

ValueNotifier<GraphQLClient> customClient(String token) {
  Link httpLink = HttpLink(uri: URLEndpoint.mainService, headers: {"token": token});
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
    url: URLEndpoint.wsMainService,
    config: SocketClientConfig(
      autoReconnect: true,
      inactivityTimeout: Duration(seconds: 30),
      initPayload: () {
        return {
          "headers": {"token": token}
        };
      },
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
