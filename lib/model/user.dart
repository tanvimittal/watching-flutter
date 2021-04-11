import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
part 'user.g.dart';

@JsonSerializable()
class User {

  @JsonKey(name: "id")
  int id;

  @JsonKey(name: "api_key")
  String apiKey;

  User({@required this.id, @required  this.apiKey});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}