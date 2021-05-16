// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_events.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetEvents _$GetEventsFromJson(Map<String, dynamic> json) {
  return GetEvents(
    id: json['id'] as int,
    name: json['name'] as String,
    createdAt: json['created_at'] as String,
    user: json['user'] == null
        ? null
        : UserRequestGet.fromJson(json['user'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$GetEventsToJson(GetEvents instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'created_at': instance.createdAt,
      'user': instance.user,
    };
