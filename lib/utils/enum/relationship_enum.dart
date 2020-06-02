class RelationShipEnum {
  static const String block = "BLOCKED";
  static const String stranger = "STRANGER";
  static const String friend = "FRIEND";
  static const String friendRequest = "FRIEND_REQUEST";
  static const String fromFriendRequest = "FROM_FRIEND_REQUEST";
}

bool isHostRequest(String rls) {
  switch (rls) {
    case RelationShipEnum.friendRequest:
      return true;
      break;
    case RelationShipEnum.stranger:
      return false;
      break;
    default:
      return false;
  }
}
