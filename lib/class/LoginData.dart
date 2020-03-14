class LoginData{
  String token;
  String status;
  String userName;
  String userID;
  String userProfile;
  LoginData({this.token,this.status,this.userName,this.userID,this.userProfile});
  factory LoginData.fromJson(Map<String,dynamic> json){
    try {
      var value= json.values.first;
      //print(value["account"]["id"]);
      return LoginData(
        status: value["status"],
        token: value["token"],
        userID:value["account"]["id"].toString(),
        userName:value["account"]["name"],
        userProfile: value['account']['avatar_url']
        );
    } catch (e) {
      return LoginData();
    }
  }
}
class RegisterData{
  String token;
  String status;
  RegisterData({this.token,this.status});
  factory RegisterData.fromJson(Map<String,dynamic> json){
    var value= json.values.first;
    return RegisterData(
      status: value["status"],
      token: value["token"]);
      
  }
}