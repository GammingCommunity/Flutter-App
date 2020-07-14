import 'package:flutter/cupertino.dart';
import 'package:gamming_community/API/URLEndpoint.dart';
import 'package:gamming_community/utils/get_token.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

GraphQLClient mainAPI(String token) {
  HttpLink httpLink = HttpLink(uri: URLEndpoint.mainService, headers: {"token": token});

  return GraphQLClient(
    cache: NormalizedInMemoryCache(dataIdFromObject: typenameDataIdFromObject),
    link: httpLink,
  );
}

GraphQLClient postAPI(String token) {
  HttpLink httpLink = HttpLink(uri: URLEndpoint.postService, headers: {"token": token});

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

String uuidFromObject(Object object) {
  if (object is Map<String, Object>) {
    final String typeName = object['__typename'] as String;
    final String id = object['id'].toString();
    if (typeName != null && id != null) {
      return <String>[typeName, id].join('/');
    }
  }
  return null;
}

final OptimisticCache cache = OptimisticCache(
  dataIdFromObject: uuidFromObject,
);

GraphQLClient initWebSocketLink() {
  /* Link link = HttpLink(
    uri: 'https://gmgraphql.glitch.me/graphql',
     headers: {"token": token}
    );*/

  Link link = HttpLink(uri: URLEndpoint.mainService);
  WebSocketLink socketLink = WebSocketLink(
    url: URLEndpoint.wsMainService,
    config: SocketClientConfig(
      autoReconnect: true,
      inactivityTimeout: Duration(seconds: 30),
      initPayload: () async{
        return {"token": await getToken()};
      },
    ),
  );

  var links = link.concat(socketLink);
  return GraphQLClient(
    cache: cache,
    link: links,
  );
}
