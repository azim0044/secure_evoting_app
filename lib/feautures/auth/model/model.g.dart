// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      fullName: json['fullName'] as String,
      email: json['email'] as String,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'fullName': instance.fullName,
      'email': instance.email,
    };

UserSignInModel _$UserSignInModelFromJson(Map<String, dynamic> json) =>
    UserSignInModel(
      email: json['email'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$UserSignInModelToJson(UserSignInModel instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
    };
