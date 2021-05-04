import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
part 'get_request_user.g.dart';

@JsonSerializable()
class UserRequestGet {

  @JsonKey(name: "id")
  int id;

  @JsonKey(name: "nickname")
  String nickname;

  UserRequestGet({@required this.nickname, @required  this.id});

  factory UserRequestGet.fromJson(Map<String, dynamic> json) => _$UserRequestGetFromJson(json);
  Map<String, dynamic> toJson() => _$UserRequestGetToJson(this);
}