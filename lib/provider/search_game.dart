import 'package:flutter/material.dart';
import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/class/Game.dart';
import 'package:gamming_community/repository/main_repo.dart';
import 'package:gamming_community/utils/get_token.dart';

class SearchGame with ChangeNotifier {
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

    loadingResult();
    try {
        listQuery.clear();
        var result = await MainRepo.queryGraphQL(await getToken(), query.searchGame(text,""));
        var data = ListGame.fromJson(result.data['searchGame']).games;
        data != null ? listQuery.addAll(data) : listQuery = [];
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
