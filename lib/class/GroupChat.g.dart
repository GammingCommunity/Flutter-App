// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'GroupChat.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GroupChatAdapter extends TypeAdapter<GroupChat> {
  @override
  final typeId = 10;

  @override
  GroupChat read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GroupChat(
      id: fields[0] as String,
      roomName: fields[1] as String,
      hostID: fields[2] as String,
      memberID: (fields[4] as List)?.cast<dynamic>(),
      gameInfo: fields[7] as GameInfo,
      maxOfMember: fields[5] as int,
      roomType: fields[6] as String,
      roomLogo: fields[9] as String,
      roomBackground: fields[10] as String,
      isJoin: fields[11] as bool,
      isRequest: fields[12] as bool,
      createAt: fields[8] as String,
    )..description = fields[3] as String;
  }

  @override
  void write(BinaryWriter writer, GroupChat obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.roomName)
      ..writeByte(2)
      ..write(obj.hostID)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.memberID)
      ..writeByte(5)
      ..write(obj.maxOfMember)
      ..writeByte(6)
      ..write(obj.roomType)
      ..writeByte(7)
      ..write(obj.gameInfo)
      ..writeByte(8)
      ..write(obj.createAt)
      ..writeByte(9)
      ..write(obj.roomLogo)
      ..writeByte(10)
      ..write(obj.roomBackground)
      ..writeByte(11)
      ..write(obj.isJoin)
      ..writeByte(12)
      ..write(obj.isRequest);
  }
}

class GameInfoAdapter extends TypeAdapter<GameInfo> {
  @override
  final typeId = 11;

  @override
  GameInfo read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GameInfo(
      gameID: fields[0] as String,
      gameName: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, GameInfo obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.gameID)
      ..writeByte(1)
      ..write(obj.gameName);
  }
}

class GroupChatsAdapter extends TypeAdapter<GroupChats> {
  @override
  final typeId = 12;

  @override
  GroupChats read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GroupChats(
      rooms: (fields[0] as List)?.cast<GroupChat>(),
    );
  }

  @override
  void write(BinaryWriter writer, GroupChats obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.rooms);
  }
}
