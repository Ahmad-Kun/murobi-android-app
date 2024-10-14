import 'dart:convert';

wakafModel wakafModelFromJson(String str) {
  final jsonData = json.decode(str);
  return wakafModel.fromJson(jsonData);
}

class wakafModel{
  final int masjidId;
  final String sumbangan;
  final DateTime tanggal;

  wakafModel({
    required this.masjidId,
    required this.sumbangan,
    required this.tanggal,
  });

  factory wakafModel.fromJson(Map<String, dynamic> json){
    return wakafModel(
      masjidId: json['masjid_id'],
      sumbangan: json['sumbangan'],
      tanggal: DateTime.parse(json['tanggal']),
    );
  }

  factory wakafModel.fromMap(Map<String, dynamic> map){
    return wakafModel(
      masjidId: map['masjid_id'],
      sumbangan: map['sumbangan'],
      tanggal: DateTime.parse(map['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'masjid_id': masjidId,
      'sumbangan': sumbangan,
      'date': tanggal,
    };
  }
}