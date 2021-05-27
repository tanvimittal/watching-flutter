import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Phone number utility
class PhoneNumberUtil {
  // 入力させる電話の桁数 (日本だと 090xxxxxxxx で入力させるのが普通)
  static const int lengthInputPhoneNumber = 11;

  // https://www.soumu.go.jp/main_sosiki/joho_tsusin/top/tel_number/q_and_a.html#q5
  static final RegExp regExpJapaneseMobilePhoneNumber = RegExp(r'^0[789]0[0-9]{8}$');

  static TextField buildTextFieldForPhoneNumber({TextEditingController controller, void Function(String) onChanged}) {
    return TextField(
      maxLength: lengthInputPhoneNumber,
      // https://qiita.com/beckyJPN/items/912cb61cfee813bf4a70
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      controller: controller,
      decoration: InputDecoration(
        hintText: "ハイフン区切りなし、数字のみ",
      ),
      onChanged: onChanged,
    );
  }

  // 入力途中の Validation
  static bool isValidForInputting(String number) {
    // TODO: 数字以外は入力できないようにしているので、ここではやらない？！

    if (number.length == lengthInputPhoneNumber) {
      return true;
    } else {
      return false;
    }
  }

  // 送信するかどうかの Validation
  static bool isValid(String number) {
    if (regExpJapaneseMobilePhoneNumber.hasMatch(number)) {
      return true;
    } else {
      return false;
    }
  }

  // https://github.com/ruimarinho/google-libphonenumber
  // number: isValid でチェック済みの文字列
  static String toE164FormatFromJapanesePhoneNumber(String number) {
    // https://dart.dev/guides/language/language-tour#assert
    assert(isValid(number));

    return "+81${number.substring(1)}";
  }
}
