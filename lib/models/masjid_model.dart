import 'dart:convert';

MasjidModel masjidModelFromJson(String str){
  final jsonData = json.decode(str);
  return MasjidModel.fromJson(jsonData);
}

class MasjidModel{
  final int id;
  final String masjidName;
  final String masjidPict;
  final String alamat;
  final String saldoAwal;

  MasjidModel({
    required this.id,
    required this.masjidName,
    required this.masjidPict,
    required this.alamat,
    required this.saldoAwal,
  });

  factory MasjidModel.fromJson(Map<String, dynamic> json){
    return MasjidModel(
      id: json['id'],
      masjidName: json['masjid_name'],
      masjidPict: json['masjid_pict'],
      alamat: json['alamat'],
      saldoAwal: json['saldo_awal'],
    );
  }

  factory MasjidModel.fromMap(Map<String, dynamic> map){
    return MasjidModel(
      id: map['id'],
      masjidName: map['masjid_name'],
      masjidPict: map['masjid_pict'],
      alamat: map['alamat'],
      saldoAwal: map['saldo_awal'],
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'masjid_name': masjidName,
      'masjid_pict': masjidPict,
      'alamat': alamat,
      'saldo_awal': saldoAwal,
    };
  }
}