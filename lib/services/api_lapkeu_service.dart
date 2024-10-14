import 'package:murobi_beta/models/lapkeu_model.dart';
import 'package:murobi_beta/models/responselapkeu_model.dart';
import 'package:murobi_beta/models/wakaf_model.dart';
import 'package:murobi_beta/utils/api.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';
import 'dart:convert';

class ApiLapkeu {
  static Future<LapkeuResponse> getApi(String id_masjid) async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.endPointLapkeu + '$id_masjid');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        List<LapkeuModel> _apiLapkeuModel = List.from(data['lapkeu']).map((item) => LapkeuModel.fromJson(item)).toList();
        String saldoAkhir = data['saldoAkhir'].toString();
        String inSaldoNow = data['inSaldoNow'].toString();
        String totZakFit = data['totZakFit'].toString();
        String totZakMal = data['totZakMal'].toString();
        String totWakaf = data['totWakaf'].toString();
        String relWakaf = data['relWakaf'].toString();
        List<wakafModel> _apiWakafModel = List.from(data['dataWakaf']).map((item) => wakafModel.fromJson(item)).toList();
        return LapkeuResponse(
          lapkeuList: _apiLapkeuModel,
          saldoAkhir: saldoAkhir,
          inSaldoNow: inSaldoNow,
          totZakFit: totZakFit,
          totZakMal: totZakMal,
          wakafList: _apiWakafModel,
          totWakaf: totWakaf,
          relWakaf: relWakaf,
        );
      } 
      else {
        throw Exception(
            'Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      log(e.toString());
      throw Exception('Failed to fetch data. Error di API: ${e.toString()}');
    }
  }
}