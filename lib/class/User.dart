import 'package:gamming_community/resources/values/app_constraint.dart';

class User {
  int id;
  String nickname;
  String describe;
  String birthday;
  String email;
  String phoneNumber;
  String profileUrl;
  String relationship;
  int numOfFollower;
  User(
      {this.id,
      this.birthday,
      this.describe,
      this.email,
      this.nickname,
      this.phoneNumber,
      this.relationship,
      this.numOfFollower,
      this.profileUrl});
  factory User.fromJson(json) {
    var user = User();
    try {
      user = User(
          id: json['id'],
          email: json['email'] ??= '',
          birthday: '',
          nickname: json['name'] ??= '',
          phoneNumber: json['phone'] ??= '',
          describe: json['describe'],
          relationship: json['relationship'],
          numOfFollower: json['count_followers'],
          profileUrl: json['avatar_url'] ??= AppConstraint.default_profile);
    } catch (e) {
      print(e);
      return User(birthday: "", describe: "", email: "", nickname: "", phoneNumber: "");
    }
    return user;
  }
}

class ListUser {
  List<User> listUser;
  ListUser({this.listUser});
  factory ListUser.fromJson(List json) {
    var _list = <User>[];
    try {
      json.forEach((e) {
        _list.add(User(
            id: e['account']['id'],
            email: e['account']['email'] ??= '',
            birthday: '',
            nickname: e['account']['name'] ??= '',
            phoneNumber: e['account']['phone'] ??= '',
            describe: e['account']['describe'],
            relationship: e['relationship'],
            numOfFollower: e['count_followers'],
            profileUrl: e['account']['avatar_url']));
      });
    } catch (e) {
      return ListUser(listUser: []);
    }
    return ListUser(listUser: _list);
  }
}
