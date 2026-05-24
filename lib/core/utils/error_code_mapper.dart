import 'package:flutter/widgets.dart';
import 'package:odk_flutter_template/l10n/app_localizations.dart';

/// 服务端 errorCode → 国际化文本映射工具
///
/// 职责：
/// - 根据服务端返回的 errorCode 查找对应的国际化提示文本
/// - 找不到映射时返回 null，由调用方决定降级策略
///
/// 命名规则：
/// - arb key 为 `errorCode{code}`，如 `errorCode013`
/// - 本文件映射表 key 为服务端 errorCode，如 `'013'`
/// - value 直接引用 AppLocalizations 的 getter
///
/// 扩展方式：
/// 1. 在 `app_zh.arb` / `app_en.arb` 中添加 `"errorCode{code}": "提示文本"`
/// 2. 运行 `flutter gen-l10n` 生成代码
/// 3. 在本文件 `_errorCodeMap` 中添加 `'code': (l) => l.errorCode{code}`
///
/// 使用方式：
/// ```dart
/// final msg = ErrorCodeMapper.localize('013') ?? '默认提示';
/// ```
class ErrorCodeMapper {
  ErrorCodeMapper._();

  /// 根据 errorCode 获取国际化错误提示
  ///
  /// 返回 null 表示无对应映射，调用方应自行降级处理
  static String? localize(String? errorCode) {
    if (errorCode == null || errorCode.isEmpty) return null;
    final mapper = _errorCodeMap[errorCode];
    if (mapper == null) return null;

    final localizations = _localizations;
    if (localizations == null) return null;

    return mapper(localizations);
  }

  /// 获取当前 AppLocalizations 实例
  static AppLocalizations? get _localizations {
    // 优先从 L10nUtils 的静态缓存获取
    final loc = _cachedLocalizations;
    if (loc != null) return loc;

    // 降级：从根 context 获取
    final rootContext = _rootContextGetter?.call();
    if (rootContext != null) {
      return AppLocalizations.of(rootContext);
    }
    return null;
  }

  /// 静态缓存（由 L10nUtils.init 设置）
  static AppLocalizations? _cachedLocalizations;

  /// 根 context 获取函数（由 L10nUtils.init 设置）
  static BuildContext? Function()? _rootContextGetter;

  /// 初始化（在 L10nUtils.init 中调用）
  static void init(AppLocalizations localizations) {
    _cachedLocalizations = localizations;
  }

  /// 设置根 context 获取函数
  static void setRootContextGetter(BuildContext? Function() getter) {
    _rootContextGetter = getter;
  }

  /// errorCode → AppLocalizations getter 映射表
  ///
  /// key: 服务端 errorCode
  /// value: 从 AppLocalizations 实例获取国际化文本的函数
  ///
  /// 新增映射时：
  /// 1. 在 arb 文件中添加 errorCode{code} key
  /// 2. 运行 flutter gen-l10n
  /// 3. 在此表中添加对应条目
  static final Map<String, String Function(AppLocalizations)> _errorCodeMap = {
    // ======================== 通用 ========================
    '000': (l) => l.errorCode000, // 成功
    '001': (l) => l.errorCode001, // 请求参数非法
    '002': (l) => l.errorCode002, // 请求过于频繁
    // ======================== 租户相关 ========================
    '003': (l) => l.errorCode003, // 租户非法
    '004': (l) => l.errorCode004, // 租户为空
    '005': (l) => l.errorCode005, // 租户不匹配
    // ======================== 用户相关 ========================
    '010': (l) => l.errorCode010, // 用户已经存在
    '011': (l) => l.errorCode011, // 登录ID重复
    '012': (l) => l.errorCode012, // 用户不存在
    '013': (l) => l.errorCode013, // 密码不匹配
    '014': (l) => l.errorCode014, // 用户状态异常
    '015': (l) => l.errorCode015, // 用户未登录
    '016': (l) => l.errorCode016, // 新旧密码一致
    '017': (l) => l.errorCode017, // 密码已经存在
    // ======================== Token 相关 ========================
    '020': (l) => l.errorCode020, // Token过期
    '021': (l) => l.errorCode021, // Token缺失
    '022': (l) => l.errorCode022, // Token不匹配
    // ======================== 权限相关 ========================
    '030': (l) => l.errorCode030, // 暂无权限
    // ======================== 验证码相关 ========================
    '040': (l) => l.errorCode040, // 验证码不匹配
    '041': (l) => l.errorCode041, // 验证码已过期
    '042': (l) => l.errorCode042, // 验证码已存在
    '043': (l) => l.errorCode043, // 验证码已超过最大验证次数
    '044': (l) => l.errorCode044, // 验证码已超过最大发送次数
    '045': (l) => l.errorCode045, // 验证码唯一键错误
    '046': (l) => l.errorCode046, // 验证码不存在
    // ======================== 系统异常 ========================
    '-100': (l) => l.errorCodeN100, // 未知系统异常
    '-110': (l) => l.errorCodeN110, // 签名错误
  };
}
