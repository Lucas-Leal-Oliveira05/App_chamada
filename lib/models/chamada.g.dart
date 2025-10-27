// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chamada.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChamadaAdapter extends TypeAdapter<Chamada> {
  @override
  final int typeId = 0;

  @override
  Chamada read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Chamada(
      horaInicio: fields[0] as DateTime,
      horaFim: fields[1] as DateTime,
      aberta: fields[2] as bool,
      presencas: (fields[3] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Chamada obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.horaInicio)
      ..writeByte(1)
      ..write(obj.horaFim)
      ..writeByte(2)
      ..write(obj.aberta)
      ..writeByte(3)
      ..write(obj.presencas);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChamadaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
