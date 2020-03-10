class User{
  String nickname;
  String describe;
  String birthday;
  String email;
  String phoneNumber;
  User({this.birthday,this.describe,this.email,this.nickname,this.phoneNumber});
  factory User.fromJson(Map<String,dynamic> json){
      var result = json.values.first;
      //print(result["account"]["name"]);
      return User(
        email: result["account"]["email"] == null ? "" :result["account"]["email"].values,
        birthday: "",
        nickname: result["account"]["name"],
        phoneNumber: result["account"]["phone"] == null ? "": result["account"]["phone"].values,
        describe: result["account"]["describe"]);

  }
}