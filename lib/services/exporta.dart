import 'dart:io';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class ExportService {
  Future<String> gerarCSV(List historico) async {
    final dateFormatter = DateFormat('dd/MM/yyyy');
    final timeFormatter = DateFormat('HH:mm');

    List<List<String>> rows = [
      ['Chamada', 'Dia', 'Horario', 'Presencas']
    ];

    for (var c in historico) {
      rows.add([
        c.id?.toString() ?? '—',
        dateFormatter.format(c.horaInicio),
        '${timeFormatter.format(c.horaInicio)} - ${timeFormatter.format(c.horaFim)}',
        c.presencas.isEmpty ? 'Nenhuma' : c.presencas.join(', ')
      ]);
    }

    const converter = ListToCsvConverter(
      fieldDelimiter: ';',
      textDelimiter: '"',
      eol: '\n',
    );
    final csv = converter.convert(rows);

    final dirs = await getExternalStorageDirectories(type: StorageDirectory.downloads);
    final downloadsDir = dirs!.first;

    final file = File('${downloadsDir.path}/chamadas.csv');

    await file.writeAsString(csv);

    return file.path;
  }
}
