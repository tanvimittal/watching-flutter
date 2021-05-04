// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'follow_requests.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetFollowRequests _$GetFollowRequestsFromJson(Map<String, dynamic> json) {
  return GetFollowRequests(
    id: json['id'] as int,
    getUserRequests: json['from_user'] == null
        ? null
        : UserRequestGet.fromJson(json['from_user'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$GetFollowRequestsToJson(GetFollowRequests instance) =>
    <String, dynamic>{
      'id': instance.id,
      'from_user': instance.getUserRequests?.toJson(),
    };
