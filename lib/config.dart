import 'package:flutter/foundation.dart';

class Config {
  static const String appName = "見守りアプリ";

  static const String apiBaseUrl = kReleaseMode
      ? "https://watching-server-production.herokuapp.com/v1"  // production
      : "https://watching-server-staging.herokuapp.com/v1";    // staging

  //static const bool isRelease = const bool.fromEnvironment('dart.vm.product');  // Old way
  static const bool isRelease = kReleaseMode;
}
