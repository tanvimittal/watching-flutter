// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nickname_post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NicknamePost _$NicknamePostFromJson(Map<String, dynamic> json) {
  return NicknamePost(
    nickname: json['nickname'] as String,
    fcmToken: json['fcm_token'] as String,
  );
}

Map<String, dynamic> _$NicknamePostToJson(NicknamePost instance) =>
    <String, dynamic>{
      'nickname': instance.nickname,
      'fcm_token': instance.fcmToken,
    };
