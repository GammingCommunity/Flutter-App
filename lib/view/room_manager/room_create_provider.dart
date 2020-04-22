import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gamming_community/API/Mutation.dart';
import 'package:gamming_community/repository/main_repo.dart';
import 'package:gamming_community/utils/get_token.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class RoomCreateProvider extends StatesRebuilder{
    var mutation = GraphQLMutation();
    bool isLoading =false;
    String roomName= "";
    String gameID = "";
    String gameName ="";
    String hostID = "";
    bool isPrivate = false;
    bool adminType = false; // false => free , true => only has permission 
    int numofMember= 0;

    void setRoomName(String name){
      this.roomName = name;
    }
    void setGameInfo(String id,String name){
      this.gameID = id;
      this.gameName= name;
    }
    void setRoomPrivacy(bool privacy){
      this.isPrivate = privacy;

    }
    void setNumOfMember(int number){
      this.numofMember = number;
    }

    void setAdminPermission(bool permission){
      this.adminType = permission;
    }

    void submit() async{
      var info = await getUserInfo();
      //print("info : ${info['userID']}, $roomName, $isPrivate, $numofMember, $gameID, $gameName");
      /*var result = await MainRepo.mutationGraphQL(await getToken(),mutation.addRoom(hostID, roomName, isPrivate, numofMember, gameID, gameName));*/
      //TODO: implement add room here
      setLoading(true);
      /*Timer(Duration(seconds: 5), (){
        setLoading(false);
      });*/
    }
    void setLoading(bool val){
      this.isLoading = val;
      rebuildStates();
    }
}