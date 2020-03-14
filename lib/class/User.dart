class User{
  String nickname;
  String describe;
  String birthday;
  String email;
  String phoneNumber;
  User({this.birthday,this.describe,this.email,this.nickname,this.phoneNumber});
  factory User.fromJson(json){
    //print(json['name']);
    var user = User();
      try {
        user =  User(
            email: json['email'] ??= '',
            birthday: '',
            nickname: json['name'] ??= '',
            phoneNumber: json['phone']['phone'] ??= '',
            describe: json['describe']);
        
      } catch (e) {
        print(e);
        return User(birthday: "",describe: "",email: "",nickname: "",phoneNumber: "");
      }
      return user;

  }
}