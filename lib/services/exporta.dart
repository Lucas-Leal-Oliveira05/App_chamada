import 'dart:io';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class ExportService {
  Future<String> gerarCSV(List historico) async {
    // 1. Montar o CSV
    final dateFormatter = DateFormat('dd/MM/yyyy');
    final timeFormatter = DateFormat('HH:mm');

    List<List<String>> rows = [
      ['Chamada', 'Dia', 'Horário', 'Presenças']
    ];

    for (var c in historico) {
      rows.add([
        c.id?.toString() ?? '—',
        dateFormatter.format(c.horaInicio),
        '${timeFormatter.format(c.horaInicio)} - ${timeFormatter.format(c.horaFim)}',
        c.presencas.isEmpty ? 'Nenhuma' : c.presencas.join(', ')
      ]);
    }

    final csv = const ListToCsvConverter().convert(rows);

    // 2. Pasta correta para salvamento (Android 13+)
    final dir = await getExternalStorageDirectories(type: StorageDirectory.downloads);

    final downloadsDir = dir!.first;

    final file = File('${downloadsDir.path}/chamadas.csv');

    // 3. Escrever arquivo
    await file.writeAsString(csv);

    return file.path;
  }
}
