import 'package:flutter/material.dart';
import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/API/config.dart';
import 'package:gamming_community/class/Game.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class SearchGame with ChangeNotifier {
  Config config = Config();
  var query = GraphQLQuery();
  List<Game> listQuery= [];
  List<Game> games = [];
  bool isLoading = false;
  bool isrequestSearch =false;
  bool isHideSearch = false;
  int listLength =0;
  void requestSearch(bool request){
    isrequestSearch = request;
    notifyListeners();
  }

  get isSearch => isrequestSearch;

  Future<void> requestGetGame(String text) async {
    requestSearch(true);
    GraphQLClient client = config.clientToQueryMongo();
    loadingResult();
    try {
        listQuery.clear();
        var result = await client.query(QueryOptions(documentNode: gql(query.searchGame(text))));
        var data = Game.fromJson(result.data);
        data != null ? listQuery.add(data) : listQuery = [];
        requestSearch(false);
        loadingComplete(1);
    } catch (e) {
        requestSearch(false);
        loadingComplete(-1);
    }
    
    notifyListeners();

  }
  void selectGame(int index){
    games.add(listQuery[index]);
    listQuery.clear();
    notifyListeners();

  }
  void removeGame(){
    games.clear();
    notifyListeners();
  }
  get getListLength => listLength;
  void hideSearchResult (bool hide){
    isHideSearch = hide;
    notifyListeners();
  }
  void loadingResult() {
    isLoading = true;
    notifyListeners();
  }
  void loadingComplete(int length){
    listLength =length;
    isLoading = false;
    notifyListeners();
  }
  void clearListSearch(){
    listQuery.clear();
    notifyListeners();
  }
  void expand(){

  }
  void collapse(){

  }
}
