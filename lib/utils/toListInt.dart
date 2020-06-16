import 'package:gamming_community/class/Friend.dart';

toListString(List<Friend> friends) {
  return List<String>.from(friends.map((e) => e.id.toString()).toList());
}

toListInt(List friends) {
  try {
    return List<int>.from(friends.map((e) => int.parse(e))).toList();
  } catch (e) {
    return [] as int;
  }
}
