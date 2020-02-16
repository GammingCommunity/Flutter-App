class LoginData{
  String token;
  String status;
  String userName;
  LoginData({this.token,this.status,this.userName});
  factory LoginData.fromJson(Map<String,dynamic> json){
    var value= json.values.first;
   // print(value["account"]["name"]);
    return LoginData(
      status: value["status"],
      token: value["token"],
      userName:value["account"]["name"]
      );
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