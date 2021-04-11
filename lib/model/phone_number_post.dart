import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:watching_flutter/model/user_post.dart';
part 'phone_number_post.g.dart';

@JsonSerializable()
class PhoneNumberPost {

  @JsonKey(name: "phone_number")
  UserPost userPost;

  @JsonKey(name: "original")
  String original;

  PhoneNumberPost({@required this.userPost});

  factory PhoneNumberPost.fromJson(Map<String, dynamic> json) => _$PhoneNumberPostFromJson(json);
  Map<String, dynamic> toJson() => _$PhoneNumberPostToJson(this);
}