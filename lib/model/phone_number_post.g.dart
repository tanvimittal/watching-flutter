// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'phone_number_post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PhoneNumberPost _$PhoneNumberPostFromJson(Map<String, dynamic> json) {
  return PhoneNumberPost(
    userPost: json['phone_number'] == null
        ? null
        : UserPost.fromJson(json['phone_number'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PhoneNumberPostToJson(PhoneNumberPost instance) =>
    <String, dynamic>{
      'phone_number': instance.userPost?.toJson(),
    };
