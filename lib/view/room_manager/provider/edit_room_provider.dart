import 'dart:convert';

import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/class/Room.dart';
import 'package:gamming_community/class/list_game_image.dart';
import 'package:gamming_community/repository/main_repo.dart';
import 'package:gamming_community/repository/upload_image.dart';
import 'package:gamming_community/utils/get_token.dart';
import 'package:gamming_community/view/profile/edit_profile.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class EditRoomProvider extends StatesRebuilder {
  var query = GraphQLQuery();
  ImageService imageService = ImageService();
  List<String> listMember = [];
  int maxofMember = 0;
  String roomName = "";
  GameInfo game = GameInfo();
  String roomLogo = "";
  String roomBackground = "";
  bool isPrivate = false;
  String roomID = "";

  bool isChangeBackground = false;
  bool isChangeLogo = false;

  String logoPath = "";
  String backgroundPath = "";
  bool isLoading = false;

  Future initLoading(String roomID) async {
    setLoading(true);
    var result = await MainRepo.queryGraphQL(await getToken(), query.getRoomInfo(roomID));
    var roomInfo = Room.fromJson(result.data['getRoomInfo']);
    this.listMember.addAll(roomInfo.memberID.cast<String>());
    this.roomID = roomInfo.id;
    this.maxofMember = roomInfo.maxOfMember;
    this.roomName = roomInfo.roomName;
    this.isPrivate = roomInfo.isPrivate;
    this.game = roomInfo.gameInfo;

    this.roomLogo = roomInfo.roomLogo;
    this.roomBackground = roomInfo.roomBackground;
    setLoading(false);
    rebuildStates();
  }

  void setMaxOfMember(int value) {
    this.maxofMember = value;
    rebuildStates();
  }

  void setPrivacy(bool value) {
    this.isPrivate = value;
  }

  void setLoading(bool value) {
    this.isLoading = value;
    rebuildStates();
  }

  Future<String> get gameLogo async {
    var result = await MainRepo.queryGraphQL(await getToken(), query.searchGame("", game.gameID));
    try {
      var logo = GameImage.fromJson(result.data['searchGame']).gameLogo.imageUrl;
      return logo;
    } catch (e) {
      return "";
    }
  }

  // set file local
  void setLogoPath(String path) {
    this.logoPath = path;
    this.isChangeLogo = true;
    rebuildStates();
  }

  // set file local
  void setBackgroundPath(String path) {
    this.backgroundPath = path;
    this.isChangeBackground = true;
    rebuildStates();
  }

  bool get canAddMore {
    if (listMember.length < maxofMember) {
      return true;
    }
    return false;
  }

  int get countMember {
    return listMember.length;
  }

  //upload and get url
  Future uploadImage() async {
    var bgResult = await ImageService.editGroupImage("bg", roomID, backgroundPath);
    this.roomBackground = bgResult;
    var logoResult = await ImageService.editGroupImage("logo", roomID, logoPath);
    this.roomLogo = logoResult;
  }

  Future save() async {
    var info = await getUserInfo();
    // do 2 work
    //1. upload file to server
    logoPath == "" && backgroundPath == "" ?? await uploadImage();
    // 2.  save to db
    return MainRepo.mutationGraphQL(
        await getToken(),
        mutation.editRoom(this.roomID, info['userID'], roomName, isPrivate, "", this.maxofMember,
            jsonEncode(this.listMember), this.game.gameID, this.game.gameName, this.roomLogo, this.roomBackground));
  }

  void clear() {
    listMember = [];
    maxofMember = 0;
    roomName = "";
    isPrivate = false;
    isChangeBackground = false;
    isChangeLogo = false;
    logoPath = "";
    backgroundPath = "";
    rebuildStates();
  }
}
