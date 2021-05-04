import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import 'get_request_user.dart';
part 'follow_requests.g.dart';

@JsonSerializable(explicitToJson: true)
class FollowRequest {

  @JsonKey(name: "id")
  int id;

  @JsonKey(name: "from_user")
  UserRequestGet getUserRequests;

  FollowRequest({@required this.id, @required this.getUserRequests});

  factory FollowRequest.fromJson(Map<String, dynamic> json) => _$FollowRequestFromJson(json);
  Map<String, dynamic> toJson() => _$FollowRequestToJson(this);
}