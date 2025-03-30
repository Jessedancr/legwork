// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class JobModelAdapter extends TypeAdapter<JobModel> {
  @override
  final int typeId = 1;

  @override
  JobModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return JobModel(
      jobTitle: fields[0] as String,
      jobLocation: fields[1] as String,
      prefDanceStyles: (fields[2] as List).cast<dynamic>(),
      pay: fields[3] as String,
      amtOfDancers: fields[4] as String,
      jobDuration: fields[5] as String,
      jobDescr: fields[6] as String,
      jobType: fields[7] as String,
      status: fields[8] as bool,
      clientId: fields[9] as String,
      jobId: fields[10] as String,
      createdAt: fields[11] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, JobModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.jobTitle)
      ..writeByte(1)
      ..write(obj.jobLocation)
      ..writeByte(2)
      ..write(obj.prefDanceStyles)
      ..writeByte(3)
      ..write(obj.pay)
      ..writeByte(4)
      ..write(obj.amtOfDancers)
      ..writeByte(5)
      ..write(obj.jobDuration)
      ..writeByte(6)
      ..write(obj.jobDescr)
      ..writeByte(7)
      ..write(obj.jobType)
      ..writeByte(8)
      ..write(obj.status)
      ..writeByte(9)
      ..write(obj.clientId)
      ..writeByte(10)
      ..write(obj.jobId)
      ..writeByte(11)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JobModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
