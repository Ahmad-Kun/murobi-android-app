import 'dart:convert';

UserModel userModelFromJson(String str){
  final jsonData = json.decode(str);
  return UserModel.fromJson(jsonData);
}

class UserModel{
  final int id;
  final String userName;
  final String userEmail;
  final String userPhone;

  UserModel({
    required this.id,
    required this.userName,
    required this.userEmail,
    required this.userPhone,
  });

  factory UserModel.fromJson(Map<String, dynamic> json){
    return UserModel(
      id: json['user_id'],
      userName: json['user_name'],
      userEmail: json['user_email'],
      userPhone: json['user_phone'],
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> map){
    return UserModel(
      id: map['user_id'],
      userName: map['user_name'],
      userEmail: map['user_email'],
      userPhone: map['user_phone'],
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'user_id': id,
      'user_name': userName,
      'user_email': userEmail,
      'user_phone': userPhone,
    };
  }
}