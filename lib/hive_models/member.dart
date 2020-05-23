import 'package:hive/hive.dart';
part 'member.g.dart';

@HiveType(typeId: 20)
class Member extends HiveObject {
  @HiveField(0)
  String userID;
  @HiveField(1)
  String name;
  @HiveField(2)
  String image;
  Member({this.userID, this.name, this.image});
}

@HiveType(typeId: 21)
class Members extends HiveObject {
  @HiveField(0)
  String groupID;
  @HiveField(1)
  List<Member> members;
  Members({this.groupID, this.members});
}
