import 'package:hive/hive.dart';

part 'chamada.g.dart';

@HiveType(typeId: 0)
class Chamada extends HiveObject {
  @HiveField(0)
  DateTime horaInicio;

  @HiveField(1)
  DateTime horaFim;

  @HiveField(2)
  bool aberta;

  @HiveField(3)
  List<String> presencas;

  Chamada({
    required this.horaInicio,
    required this.horaFim,
    this.aberta = true,
    List<String>? presencas,
  }) : presencas = presencas ?? [];
}
