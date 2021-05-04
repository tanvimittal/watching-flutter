// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_request_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserRequestGet _$UserRequestGetFromJson(Map<String, dynamic> json) {
  return UserRequestGet(
    nickname: json['nickname'] as String,
    id: json['id'] as int,
  );
}

Map<String, dynamic> _$UserRequestGetToJson(UserRequestGet instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nickname': instance.nickname,
    };
