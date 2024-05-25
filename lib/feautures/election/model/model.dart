// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'model.g.dart';

@JsonSerializable()
class ElectionsModel {
  final String id;
  final String title;
  final String status;
  final int totalVoters;
  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime end_date;
  final String details;

  ElectionsModel({
    required this.id,
    required this.title,
    required this.status,
    required this.totalVoters,
    required this.end_date,
    required this.details,
  });

  factory ElectionsModel.fromJson(Map<String, dynamic> json) =>
      _$ElectionsModelFromJson(json);

  Map<String, dynamic> toJson() => _$ElectionsModelToJson(this);

  static DateTime _timestampFromJson(Timestamp timestamp) => timestamp.toDate();

  static Timestamp _timestampToJson(DateTime date) => Timestamp.fromDate(date);
}

@JsonSerializable()
class CandidateModel {
  final String id;
  final String full_name;
  final List<String> images;
  final String manifesto;
  final String? status;
  final int? vote;

  CandidateModel({
    required this.id,
    required this.full_name,
    required this.images,
    required this.manifesto,
    this.status,
    this.vote,
  });

  factory CandidateModel.fromJson(Map<String, dynamic> json) =>
      _$CandidateModelFromJson(json);

  Map<String, dynamic> toJson() => _$CandidateModelToJson(this);
}
