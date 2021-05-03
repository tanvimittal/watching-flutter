import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
part 'nickname_post.g.dart';

@JsonSerializable()
class NicknamePost {

  @JsonKey(name: "nickname")
  String nickname;

  @JsonKey(name: "fcm_token")
  String fcmToken;

  NicknamePost({@required this.nickname, @required  this.fcmToken});

  factory NicknamePost.fromJson(Map<String, dynamic> json) => _$NicknamePostFromJson(json);
  Map<String, dynamic> toJson() => _$NicknamePostToJson(this);
}