import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watching_flutter/model/phone_number_post.dart';
import 'package:watching_flutter/model/user.dart';
import 'package:watching_flutter/globals.dart' as globals;
import 'package:watching_flutter/model/user_post.dart';

import '../http_service.dart';

/// User repository
///
/// - MUST NOT dependency for UI
/// - MAY dependency for Dio
///
class UserRepository {

  ///
  /// ユーザー登録
  ///
  /// This function will register user on server
  /// 引数: 正しい形式の電話番号 (ex. 09099999999)
  ///
  static Future registerUser(String phoneNumber) async {
    UserPost userPost = UserPost(countryCode: "JP", original: phoneNumber);
    //UserPost userPost = UserPost(countryCode: "JP", original: "");
    print(userPost.original);

    try {
      User user = await _sendPostUsers(PhoneNumberPost(userPost: userPost));
      print(user.apiKey);

      // TODO: SharedPreferences リファクタリング
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('api_key', user.apiKey);
      globals.apiKey = user.apiKey;
      prefs.setInt('id', user.id);
      globals.id = user.id;
    } on DioError catch (e) {
      String message;

      if (e.response == null) {
        // ネットワークのエラー
        message = 'ネットワーク環境を確認するか、時間をおいて再度試してください。';
      } else {
        // サーバーのエラー
        message = 'サーバーからのレスポンスが不正です。';
      }

      throw UserRepositoryException(message);
    }
  }

  ///
  /// 電話番号からユーザーを検索
  ///
  /// 引数: 正しい形式の電話番号 (ex. 09099999999)
  /// 戻り値: User
  /// 例外: 検索処理に失敗した場合 (見つからなかった場合は検索処理には成功)
  ///
  static Future<User> searchUserFromPhoneNumber(String phoneNumber) async {
    try {
      return await _sendGetUsers(phoneNumber);
    } on DioError catch (e) {
      String message;

      if (e.response == null) {
        // ネットワークのエラー
        message = 'ネットワーク環境を確認するか、時間をおいて再度試してください。';
      } else {
        // サーバーのエラー
        message = 'サーバーからのレスポンスが不正です。';
      }

      throw UserRepositoryException(message);
    }
  }

  // TODO: To layer of API
  // 画面に依存しない処理のみ。モデル変換の責任もここ
  // 通信エラーの時は　DioError を投げる
  static Future<User> _sendPostUsers(PhoneNumberPost phoneNumber) async {
    final http = HttpService();

    Response response = await http.postRequest(
      "/users",
      data: phoneNumber.toJson(),
    );

    return User.fromJson(response.data);
  }

  // TODO: To layer of API
  // 画面に依存しない処理のみ。モデル変換の責任もここ
  static Future<User> _sendGetUsers(String phoneNumber) async {
    final http = HttpService();

    try {
      Response response = await http.getRequest(
        "/users",
        apiKey: globals.apiKey,
        queryParameters: {"phone_number": phoneNumber},
      );

      if (response.statusCode != 200) {
        // TODO: 普通はここに来ない？ドキュメントとかで裏を取りたい。
        assert(false);
      }

      return User.fromJson(response.data);
    } on DioError catch (e) {
      // 404 の時だけは特殊 (エラーではなく、見つからなかったという意味)
      // TODO: 空の配列を返すように API を修正した方がいいかも
      if (e.response != null && e.response.statusCode == 404) {
        return null;
      }

      throw e;
    }
  }
}

class UserRepositoryException implements Exception {
  final String message; // ユーザーに表示するためのメッセージ // TODO: i18n 考えると微妙。。。
  const UserRepositoryException(this.message);

  @override
  String toString() => message;
}
