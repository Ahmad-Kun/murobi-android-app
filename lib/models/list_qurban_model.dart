import 'dart:convert';

ListQurbanModel listQurbanModelFromJson(String str){
  final jsonData = json.decode(str);
  return ListQurbanModel.fromJson(jsonData);
}

class ListQurbanModel{
  final int id_qurban;
  final String nama_qurban;
  final String harga;

  ListQurbanModel({
    required this.id_qurban,
    required this.nama_qurban,
    required this.harga,
  });

  factory ListQurbanModel.fromJson(Map<String, dynamic> json) {
    return ListQurbanModel(
      id_qurban: json['id_qurban'],
      nama_qurban: json['nama_qurban'],
      harga: json['harga'],
    );
  }
}