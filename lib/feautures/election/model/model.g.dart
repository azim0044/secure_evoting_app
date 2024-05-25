// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ElectionsModel _$ElectionsModelFromJson(Map<String, dynamic> json) =>
    ElectionsModel(
      id: json['id'] as String,
      title: json['title'] as String,
      status: json['status'] as String,
      totalVoters: (json['totalVoters'] as num).toInt(),
      end_date:
          ElectionsModel._timestampFromJson(json['end_date'] as Timestamp),
      details: json['details'] as String,
    );

Map<String, dynamic> _$ElectionsModelToJson(ElectionsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'status': instance.status,
      'totalVoters': instance.totalVoters,
      'end_date': ElectionsModel._timestampToJson(instance.end_date),
      'details': instance.details,
    };

CandidateModel _$CandidateModelFromJson(Map<String, dynamic> json) =>
    CandidateModel(
      id: json['id'] as String,
      full_name: json['full_name'] as String,
      images:
          (json['images'] as List<dynamic>).map((e) => e as String).toList(),
      manifesto: json['manifesto'] as String,
      status: json['status'] as String?,
      vote: (json['vote'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CandidateModelToJson(CandidateModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'full_name': instance.full_name,
      'images': instance.images,
      'manifesto': instance.manifesto,
      'status': instance.status,
      'vote': instance.vote,
    };
