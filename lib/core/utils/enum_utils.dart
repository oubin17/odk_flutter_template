/// 枚举工具类（和 date_time_utils 统一风格）
class EnumUtils {
  /// 通用：通过 code 查找枚举
  static T? fromCode<T>(
    List<T> values,
    String Function(T) getCode,
    String? code,
  ) {
    if (code == null) return null;
    for (final T item in values) {
      if (getCode(item) == code) {
        return item;
      }
    }
    return null;
  }
}
