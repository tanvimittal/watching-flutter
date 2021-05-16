import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:watching_flutter/model/get_request_user.dart';
part 'get_events.g.dart';

@JsonSerializable()
class GetEvents {

  @JsonKey(name: "id")
  int id;

  @JsonKey(name: "name")
  String name;

  @JsonKey(name: "created_at")
  String createdAt;

  @JsonKey(name: "user")
  UserRequestGet user;

  GetEvents({@required this.id, @required  this.name, @required this.createdAt, @required this.user});

  factory GetEvents.fromJson(Map<String, dynamic> json) => _$GetEventsFromJson(json);
  Map<String, dynamic> toJson() => _$GetEventsToJson(this);
}