import 'package:odk_flutter_template/core/utils/l10n_utils.dart';

enum GenderEnum {
  male("1", "male"),
  female("2", "female");

  final String code;
  final String name;
  const GenderEnum(this.code, this.name);

  static String fromCode(String code) {
    return <String, String>{"1": L10nUtils.male, "2": L10nUtils.female}[code] ??
        "";
  }
}
