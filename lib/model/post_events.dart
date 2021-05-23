import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
part 'post_events.g.dart';

@JsonSerializable()
class PostEvents {

  @JsonKey(name: "name")
  String name;

  PostEvents({@required  this.name});

  factory PostEvents.fromJson(Map<String, dynamic> json) => _$PostEventsFromJson(json);
  Map<String, dynamic> toJson() => _$PostEventsToJson(this);
}