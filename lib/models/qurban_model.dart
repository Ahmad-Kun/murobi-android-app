import 'dart:convert';

QurbanModel qurbanModelFromJson(String str){
  final jsonData = json.decode(str);
  return QurbanModel.fromJson(jsonData);
}

class QurbanModel{
  final int id;
  final String masjidName;
  final int sapi;
  final int kambing;
  final int sapiUser;
  final int kambingUser;

  QurbanModel({
    required this.id,
    required this.masjidName,
    required this.sapi,
    required this.kambing,
    required this.sapiUser,
    required this.kambingUser,
  });

  factory QurbanModel.fromJson(Map<String, dynamic> json){
    return QurbanModel(
      id: json['masjid_id'],
      masjidName: json['masjid_name'],
      sapi: json['sapi'],
      kambing: json['kambing'],
      sapiUser: json['sapi_user'],
      kambingUser: json['kambing_user'],
    );
  }

  factory QurbanModel.fromMap(Map<String, dynamic> map){
    return QurbanModel(
      id: map['masjid_id'],
      masjidName: map['masjid_name'],
      sapi: map['sapi'],
      kambing: map['kambing'],
      sapiUser: map['sapi_user'],
      kambingUser: map['kambing_user'],
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'masjid_id': id,
      'masjid_name': masjidName,
      'sapi': sapi,
      'kambing': kambing,
      'sapi_user': sapiUser,
      'kambing_user': kambingUser,
    };
  }
}