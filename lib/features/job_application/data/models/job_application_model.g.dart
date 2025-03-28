// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_application_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class JobApplicationModelAdapter extends TypeAdapter<JobApplicationModel> {
  @override
  final int typeId = 0;

  @override
  JobApplicationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return JobApplicationModel(
      applicationId: fields[0] as String,
      jobId: fields[1] as String,
      dancerId: fields[2] as String,
      clientId: fields[3] as String,
      applicationStatus: fields[4] as String,
      proposal: fields[5] as String,
      appliedAt: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, JobApplicationModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.applicationId)
      ..writeByte(1)
      ..write(obj.jobId)
      ..writeByte(2)
      ..write(obj.dancerId)
      ..writeByte(3)
      ..write(obj.clientId)
      ..writeByte(4)
      ..write(obj.applicationStatus)
      ..writeByte(5)
      ..write(obj.proposal)
      ..writeByte(6)
      ..write(obj.appliedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JobApplicationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
