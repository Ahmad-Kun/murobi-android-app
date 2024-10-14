import 'package:murobi_beta/models/lapkeu_model.dart';
import 'package:murobi_beta/models/wakaf_model.dart';

class LapkeuResponse {
  final List<LapkeuModel> lapkeuList;
  final String saldoAkhir;
  final String inSaldoNow;
  final String totZakFit;
  final String totZakMal;
  final List<wakafModel> wakafList;
  final String totWakaf;
  final String relWakaf;

  LapkeuResponse({
    required this.lapkeuList,
    required this.saldoAkhir,
    required this.inSaldoNow,
    required this.totZakFit,
    required this.totZakMal,
    required this.wakafList,
    required this.totWakaf,
    required this.relWakaf,
  });
}