import 'dart:io';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import '../models/chamada.dart';

class ExportService {
  Future<String> gerarCSV(List<Chamada> historico) async {
    List<List<String>> rows = [
      ['Data', 'Início', 'Fim', 'Presenças']
    ];

    for (var c in historico) {
      rows.add([
        DateFormat('dd/MM/yyyy').format(c.horaInicio),
        DateFormat('HH:mm').format(c.horaInicio),
        DateFormat('HH:mm').format(c.horaFim),
        c.presencas.join(', ')
      ]);
    }

    String csv = const ListToCsvConverter().convert(rows);
    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/chamadas.csv';
    final file = File(path);
    await file.writeAsString(csv);
    return path;
  }
}
