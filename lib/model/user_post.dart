import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
part 'user_post.g.dart';

@JsonSerializable()
class UserPost {

  @JsonKey(name: "country_code")
  String countryCode;

  @JsonKey(name: "original")
  String original;

  UserPost({@required this.countryCode, @required  this.original});

  factory UserPost.fromJson(Map<String, dynamic> json) => _$UserPostFromJson(json);
  Map<String, dynamic> toJson() => _$UserPostToJson(this);
}