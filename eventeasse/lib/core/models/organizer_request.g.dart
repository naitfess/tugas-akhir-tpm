// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organizer_request.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrganizerRequestAdapter extends TypeAdapter<OrganizerRequest> {
  @override
  final int typeId = 4;

  @override
  OrganizerRequest read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrganizerRequest(
      id: fields[0] as int,
      organizationName: fields[1] as String,
      organizationDesc: fields[2] as String,
      status: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, OrganizerRequest obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.organizationName)
      ..writeByte(2)
      ..write(obj.organizationDesc)
      ..writeByte(3)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrganizerRequestAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
