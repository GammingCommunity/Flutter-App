// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'GroupMessage.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GroupMessageAdapter extends TypeAdapter<GroupMessage> {
  @override
  final typeId = 1;

  @override
  GroupMessage read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GroupMessage(
      messageType: fields[0] as String,
      messageID: fields[1] as String,
      text: fields[2] as GMessage,
      sender: fields[3] as String,
      createAt: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, GroupMessage obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.messageType)
      ..writeByte(1)
      ..write(obj.messageID)
      ..writeByte(2)
      ..write(obj.text)
      ..writeByte(3)
      ..write(obj.sender)
      ..writeByte(4)
      ..write(obj.createAt);
  }
}

class GMessageAdapter extends TypeAdapter<GMessage> {
  @override
  final typeId = 0;

  @override
  GMessage read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GMessage(
      content: fields[0] as String,
      height: fields[1] as int,
      width: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, GMessage obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.content)
      ..writeByte(1)
      ..write(obj.height)
      ..writeByte(2)
      ..write(obj.width);
  }
}

class GroupMessagesAdapter extends TypeAdapter<GroupMessages> {
  @override
  final typeId = 2;

  @override
  GroupMessages read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GroupMessages(
      groupMessages: (fields[0] as List)?.cast<GroupMessage>(),
    );
  }

  @override
  void write(BinaryWriter writer, GroupMessages obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.groupMessages);
  }
}
