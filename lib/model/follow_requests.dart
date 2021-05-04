import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:watching_flutter/model/user_post.dart';

import 'get_request_user.dart';
part 'follow_requests.g.dart';

@JsonSerializable(explicitToJson: true)
class GetFollowRequests {

  @JsonKey(name: "id")
  int id;

  @JsonKey(name: "from_user")
  UserRequestGet getUserRequests;

  GetFollowRequests({@required this.id, @required this.getUserRequests});

  factory GetFollowRequests.fromJson(Map<String, dynamic> json) => _$GetFollowRequestsFromJson(json);
  Map<String, dynamic> toJson() => _$GetFollowRequestsToJson(this);
}