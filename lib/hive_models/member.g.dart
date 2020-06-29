// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MemberAdapter extends TypeAdapter<Member> {
  @override
  final typeId = 20;

  @override
  Member read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Member(
      userID: fields[0] as String,
      name: fields[1] as String,
      image: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Member obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.userID)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.image);
  }
}

class MembersAdapter extends TypeAdapter<Members> {
  @override
  final typeId = 21;

  @override
  Members read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Members(
      groupID: fields[0] as String,
      members: (fields[1] as List)?.cast<Member>(),
    );
  }

  @override
  void write(BinaryWriter writer, Members obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.groupID)
      ..writeByte(1)
      ..write(obj.members);
  }
}
