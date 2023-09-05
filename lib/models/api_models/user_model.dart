// To parse this JSON data, do
//
//     final userSignUpModel = userSignUpModelFromJson(jsonString);

import 'dart:convert';

UserModel userSignUpModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    this.message,
    this.data,
  });

  String? message;
  Data? data;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data!.toJson(),
  };
}

class Data {
  Data({
    this.token,
    this.user,
  });

  String? token;
  User? user;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    token: json["token"],
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "token": token,
    "user": user!.toJson(),
  };


}


class User {
  User({
    this.id,
    this.name,
    this.fName,
    this.lName,
    this.email,
    this.phone,
    this.isVerifiedPhone,
    this.isVerifiedEmail,
    this.dialCode,
    this.image,
  });

  int? id;
  String? name;
  String? fName;
  String? lName;
  String? email;
  String? phone;
  int? isVerifiedPhone;
  int? isVerifiedEmail;
  String? dialCode;
  String? image;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    fName: json["f_name"],
    lName: json["l_name"],
    email: json["email"],
    isVerifiedPhone: json["is_phone_verified"],
    isVerifiedEmail: json["is_email_verified"],
    dialCode: json["country_dial_code"],
    phone:json["phone"]!= null ?json["phone"][0]=='+' ?json["phone"]:('+'+json["phone"]):null,
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "f_name": fName,
    "l_name": lName,
    "email": email,
    "is_phone_verified": isVerifiedPhone,
    "is_email_verified" : isVerifiedEmail,
    "country_dial_code": dialCode,
    "phone": phone,
    "image": image,
  };
}

