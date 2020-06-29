import 'package:gamming_community/API/Mutation.dart';
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
    
    

   
}