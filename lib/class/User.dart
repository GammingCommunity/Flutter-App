import 'package:gamming_community/resources/values/app_constraint.dart';

class User{
  String nickname;
  String describe;
  String birthday;
  String email;
  String phoneNumber;
  String profileUrl;
  User({this.birthday,this.describe,this.email,this.nickname,this.phoneNumber,this.profileUrl});
  factory User.fromJson(json){
    var user = User();
      try {
        user =  User(
            email: json['email'] ??= '',
            birthday: '',
            nickname: json['name'] ??= '',
            phoneNumber: json['phone']['phone'] ??= '',
            describe: json['describe'],
            profileUrl: json['avatar_url'] ??=AppConstraint.default_profile
            
            );
      } catch (e) {
        print(e);
        return User(birthday: "",describe: "",email: "",nickname: "",phoneNumber: "");
      }
      return user;

  }
}
class ListUser {
  List<User> listUser;
  ListUser({this.listUser});
  factory ListUser.fromJson(List json) {
    var _list = <User>[];
    json.forEach((element) {
      _list.add(User(
          email: element['account']['email'] ??= '',
          birthday: '',
          nickname: element['account']['name'] ??= '',
          phoneNumber: element['account']['phone'] ??= '',
          describe: element['account']['describe'],
          profileUrl: element['account']['avatar_url']));
    });
    return ListUser(listUser: _list);
  }
}
