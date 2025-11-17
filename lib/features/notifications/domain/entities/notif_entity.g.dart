// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notif_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NotifEntityAdapter extends TypeAdapter<NotifEntity> {
  @override
  final int typeId = 2;

  @override
  NotifEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NotifEntity(
      notifId: fields[0] as String?,
      deviceToken: fields[1] as String,
      body: fields[3] as String,
      title: fields[2] as String,
      channelId: fields[4] as String,
      createdAt: fields[5] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, NotifEntity obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.notifId)
      ..writeByte(1)
      ..write(obj.deviceToken)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.body)
      ..writeByte(4)
      ..write(obj.channelId)
      ..writeByte(5)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotifEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
