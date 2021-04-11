// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserPost _$UserPostFromJson(Map<String, dynamic> json) {
  return UserPost(
    countryCode: json['country_code'] as String,
    original: json['original'] as String,
  );
}

Map<String, dynamic> _$UserPostToJson(UserPost instance) => <String, dynamic>{
      'country_code': instance.countryCode,
      'original': instance.original,
    };
