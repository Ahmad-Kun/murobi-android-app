import 'package:murobi_beta/models/list_qurban_model.dart';

class QurbanFormModel{
  final int masjid_id;
  final String masjidName;
  final List<ListQurbanModel> list_qurban;

  QurbanFormModel({
    required this.masjid_id,
    required this.masjidName,
    required this.list_qurban
  });

  factory QurbanFormModel.fromJson(Map<String, dynamic> json) {
    var qurbanList = json['qurban'] as List;
    List<ListQurbanModel> qurbans =
        qurbanList.map((e) => ListQurbanModel.fromJson(e)).toList();

    return QurbanFormModel(
      masjidName: json['masjid_name'],
      masjid_id: json['masjid_id'],
      list_qurban: qurbans,
    );
  }
}