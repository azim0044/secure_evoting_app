import 'package:json_annotation/json_annotation.dart';

part 'model.g.dart';

@JsonSerializable()
class UserModel {
  final String fullName;
  final String email;

  UserModel(
      {required this.fullName,
      required this.email,
      });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

@JsonSerializable()
class UserSignInModel {
  final String email;
  final String password;

  UserSignInModel({required this.email, required this.password});

  factory UserSignInModel.fromJson(Map<String, dynamic> json) =>
      _$UserSignInModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserSignInModelToJson(this);
}
