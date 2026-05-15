import 'package:json_annotation/json_annotation.dart';

part 'app_version_info.g.dart';

/// 版本信息模型（后端返回的最新版本数据）
@JsonSerializable()
class AppVersionInfo {
  /// 最新版本号（如 "1.2.0"）
  final String version;

  /// 最新构建号（如 "2"）
  final String? buildNumber;

  /// 更新内容/更新日志
  final String? updateContent;

  /// 是否强制更新
  final bool? forceUpdate;

  /// Android 应用市场下载地址（可选）
  final String? androidUrl;

  /// iOS App Store 地址（可选）
  final String? iosUrl;

  const AppVersionInfo({
    required this.version,
    this.buildNumber,
    this.updateContent,
    this.forceUpdate,
    this.androidUrl,
    this.iosUrl,
  });

  factory AppVersionInfo.fromJson(Map<String, dynamic> json) =>
      _$AppVersionInfoFromJson(json);

  Map<String, dynamic> toJson() => _$AppVersionInfoToJson(this);
}
