import 'package:intl/intl.dart';

String formatDbUtcToLocal(
  String raw, {
  String output = 'd - MMMM - yyyy h:mma',
}) {
  if (raw.isEmpty) return '';
  try {
    DateTime utc;

    // Case 1: Already ISO (has 'T' or timezone offset/Z)
    final hasIsoHints =
        raw.contains('T') || raw.contains('+') || raw.endsWith('Z');
    if (hasIsoHints) {
      utc = DateTime.parse(raw).toUtc();
    } else {
      // Case 2: MySQL style "YYYY-MM-DD HH:MM:SS" -> treat as UTC
      final dateTimeParts = raw.split(' ');
      final dateParts = dateTimeParts[0]
          .split('-')
          .map(int.parse)
          .toList(); // [yyyy, mm, dd]
      final timeParts = (dateTimeParts.length > 1
          ? dateTimeParts[1].split(':').map(int.parse).toList()
          : <int>[0, 0, 0]); // [HH, mm, ss]

      final y = dateParts[0],
          m = dateParts[1],
          d = dateParts[2],
          H = timeParts[0],
          M = timeParts[1],
          S = timeParts.length > 2 ? timeParts[2] : 0;

      utc = DateTime.utc(y, m, d, H, M, S);
    }

    final local = utc.toLocal();
    return DateFormat(output).format(local);
  } catch (_) {
    return raw;
  }
}
