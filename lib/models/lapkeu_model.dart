import 'dart:convert';

LapkeuModel lapkeuModelFromJson(String str) {
  final jsonData = json.decode(str);
  return LapkeuModel.fromJson(jsonData);
}

class LapkeuModel{
  final int masjidId;
  final String note;
  final DateTime tanggal;
  final String jumlah;
  final int arusKas;

  LapkeuModel({
    required this.masjidId,
    required this.note,
    required this.tanggal,
    required this.jumlah,
    required this.arusKas,
  });

  factory LapkeuModel.fromJson(Map<String, dynamic> json){
    return LapkeuModel(
      masjidId: json['masjid_id'],
      note: json['note'],
      tanggal: DateTime.parse(json['tanggal']),
      jumlah: json['jumlah'],
      arusKas: json['arus'],
    );
  }

  factory LapkeuModel.fromMap(Map<String, dynamic> map){
    return LapkeuModel(
      masjidId: map['masjid_id'],
      note: map['note'],
      tanggal: DateTime.parse(map['date']),
      jumlah: map['nominal'],
      arusKas: map['kas'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'masjid_id': masjidId,
      'note': note,
      'date': tanggal,
      'nominal': jumlah,
      'arus': arusKas,
    };
  }
}