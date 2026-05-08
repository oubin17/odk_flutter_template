/// 日期时间工具类
/// 提供 DateTime 与字符串互转、时间戳转换、时间判断、友好格式化等常用方法
class DateTimeUtils {
  // ====================== 常用日期格式常量 ======================
  /// 默认完整格式：yyyy-MM-dd HH:mm:ss
  static const String formatDefault = 'yyyy-MM-dd HH:mm:ss';

  /// 仅日期格式：yyyy-MM-dd
  static const String formatDate = 'yyyy-MM-dd';

  /// 仅时间格式：HH:mm:ss
  static const String formatTime = 'HH:mm:ss';

  /// 日期+时分格式：yyyy-MM-dd HH:mm
  static const String formatYMDHm = 'yyyy-MM-dd HH:mm';

  /// 中文日期格式：yyyy年MM月dd日
  static const String formatZhDate = 'yyyy年MM月dd日';

  // ====================== DateTime → 字符串 ======================
  /// DateTime 转字符串（使用默认格式 yyyy-MM-dd HH:mm:ss）
  static String dateToStr(DateTime? date, {String defaultValue = ''}) {
    if (date == null) return defaultValue;
    return _dateToCustomStr(date, formatDefault);
  }

  /// DateTime 转 日期字符串（yyyy-MM-dd）
  static String dateToDateStr(DateTime? date, {String defaultValue = ''}) {
    if (date == null) return defaultValue;
    return _dateToCustomStr(date, formatDate);
  }

  /// DateTime 转 时间字符串（HH:mm:ss）
  static String dateToTimeStr(DateTime? date, {String defaultValue = ''}) {
    if (date == null) return defaultValue;
    return _dateToCustomStr(date, formatTime);
  }

  /// DateTime 转 自定义格式字符串
  static String dateToCustomStr(
    DateTime? date,
    String format, {
    String defaultValue = '',
  }) {
    if (date == null || format.isEmpty) return defaultValue;
    return _dateToCustomStr(date, format);
  }

  /// 内部方法：DateTime 格式化核心实现
  static String _dateToCustomStr(DateTime date, String format) {
    // 补零工具：个位数前面加0
    String pad(int value) => value.toString().padLeft(2, '0');

    return format
        .replaceAll('yyyy', date.year.toString())
        .replaceAll('MM', pad(date.month))
        .replaceAll('dd', pad(date.day))
        .replaceAll('HH', pad(date.hour))
        .replaceAll('mm', pad(date.minute))
        .replaceAll('ss', pad(date.second));
  }

  // ====================== 字符串 → DateTime ======================
  /// 字符串转 DateTime（默认格式 yyyy-MM-dd HH:mm:ss）
  /// 转换失败返回 null
  static DateTime? strToDate(String? str) {
    if (str == null || str.isEmpty) return null;
    return _strToCustomDate(str, formatDefault);
  }

  /// 日期字符串转 DateTime（yyyy-MM-dd）
  static DateTime? strToDateOnly(String? str) {
    if (str == null || str.isEmpty) return null;
    return _strToCustomDate(str, formatDate);
  }

  /// 自定义格式字符串转 DateTime
  /// 转换失败返回 null
  static DateTime? strToCustomDate(String? str, String format) {
    if (str == null || str.isEmpty || format.isEmpty) return null;
    return _strToCustomDate(str, format);
  }

  /// 内部方法：字符串转 DateTime 核心实现
  static DateTime? _strToCustomDate(String str, String format) {
    try {
      // 提取年月日时分秒
      int year = 0, month = 1, day = 1, hour = 0, minute = 0, second = 0;

      if (format.contains('yyyy')) {
        year = int.parse(
          str.substring(format.indexOf('yyyy'), format.indexOf('yyyy') + 4),
        );
      }
      if (format.contains('MM')) {
        month = int.parse(
          str.substring(format.indexOf('MM'), format.indexOf('MM') + 2),
        );
      }
      if (format.contains('dd')) {
        day = int.parse(
          str.substring(format.indexOf('dd'), format.indexOf('dd') + 2),
        );
      }
      if (format.contains('HH')) {
        hour = int.parse(
          str.substring(format.indexOf('HH'), format.indexOf('HH') + 2),
        );
      }
      if (format.contains('mm')) {
        minute = int.parse(
          str.substring(format.indexOf('mm'), format.indexOf('mm') + 2),
        );
      }
      if (format.contains('ss')) {
        second = int.parse(
          str.substring(format.indexOf('ss'), format.indexOf('ss') + 2),
        );
      }

      return DateTime(year, month, day, hour, minute, second);
    } catch (e) {
      // 转换异常返回null
      return null;
    }
  }

  // ====================== 时间戳 与 DateTime 互转 ======================
  /// 获取当前时间戳（毫秒级）
  static int getNowTimestamp() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  /// DateTime 转 时间戳
  /// [isSecond] true=秒级 false=毫秒级（默认）
  static int dateToTimestamp(DateTime? date, {bool isSecond = false}) {
    if (date == null) return 0;
    return isSecond
        ? date.millisecondsSinceEpoch ~/ 1000
        : date.millisecondsSinceEpoch;
  }

  /// 时间戳 转 DateTime
  /// [timestamp] 毫秒/秒 自动识别
  static DateTime? timestampToDate(int? timestamp) {
    if (timestamp == null || timestamp == 0) return null;
    // 兼容秒级时间戳（10位）和毫秒级（13位）
    int ms = timestamp.toString().length == 10 ? timestamp * 1000 : timestamp;
    return DateTime.fromMillisecondsSinceEpoch(ms);
  }

  // ====================== 常用时间判断 ======================
  /// 判断两个时间是否为同一天
  static bool isSameDay(DateTime? date1, DateTime? date2) {
    if (date1 == null || date2 == null) return false;
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  /// 判断是否为今天
  static bool isToday(DateTime? date) {
    return isSameDay(date, DateTime.now());
  }

  /// 判断是否为昨天
  static bool isYesterday(DateTime? date) {
    if (date == null) return false;
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return isSameDay(date, yesterday);
  }

  // ====================== 常用时间获取 ======================
  /// 获取昨天的 DateTime
  static DateTime getYesterday() {
    return DateTime.now().subtract(const Duration(days: 1));
  }

  /// 获取明天的 DateTime
  static DateTime getTomorrow() {
    return DateTime.now().add(const Duration(days: 1));
  }

  /// 获取中文星期几
  static String getWeekdayZh(DateTime? date) {
    if (date == null) return '';
    const List<String> weeks = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
    return weeks[date.weekday - 1];
  }

  // ====================== 友好时间格式化（核心） ======================
  /// 格式化时间为友好显示（如：刚刚、5分钟前、今天 10:30、昨天 10:30、2024-05-20）
  static String formatFriendlyTime(DateTime? date) {
    if (date == null) return '';
    final now = DateTime.now();
    final difference = now.difference(date);

    // 小于1分钟：刚刚
    if (difference.inSeconds < 60) {
      return '刚刚';
    }
    // 小于1小时：xx分钟前
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}分钟前';
    }
    // 小于1天：xx小时前
    if (difference.inHours < 24) {
      return '${difference.inHours}小时前';
    }
    // 昨天
    if (isYesterday(date)) {
      return '昨天 ${dateToCustomStr(date, 'HH:mm')}';
    }
    // 今年：显示月日
    if (date.year == now.year) {
      return dateToCustomStr(date, 'MM-dd HH:mm');
    }
    // 跨年：显示完整日期
    return dateToDateStr(date);
  }
}
