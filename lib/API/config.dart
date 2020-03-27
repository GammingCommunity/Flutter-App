import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class Config {
  static Link httpLink = HttpLink(uri: "https://gmgraphql.glitch.me/graphql",headers: {
    "token":""
  });

  ValueNotifier<GraphQLClient> client = ValueNotifier(GraphQLClient(
      cache: OptimisticCache(dataIdFromObject: typenameDataIdFromObject), link: httpLink));

 static WebSocketLink websocketLink = WebSocketLink(
    url: "ws://https://gmgraphql.glitch.me/graphql",
    config: SocketClientConfig(
      autoReconnect: true,
      inactivityTimeout: Duration(seconds: 30),
    ),
  );
  var httpLinks = httpLink.concat(websocketLink);
  GraphQLClient clientToQueryMongo() {
    return GraphQLClient(
      cache: OptimisticCache(dataIdFromObject: typenameDataIdFromObject),
      link: httpLink,
    );
  }
}
