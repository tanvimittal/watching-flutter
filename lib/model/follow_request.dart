import 'package:json_annotation/json_annotation.dart';

import 'get_request_user.dart';
part 'follow_request.g.dart';

@JsonSerializable(explicitToJson: true)
class FollowRequest {

  @JsonKey(name: "id")
  int id;

  @JsonKey(name: "user_id")
  int userId;

  @JsonKey(name: "from_user")
  UserRequestGet getUserRequests;

  FollowRequest({this.id, this.userId, this.getUserRequests});

  factory FollowRequest.fromJson(Map<String, dynamic> json) => _$FollowRequestFromJson(json);
  Map<String, dynamic> toJson() => _$FollowRequestToJson(this);
}