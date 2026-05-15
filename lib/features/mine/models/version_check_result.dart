import 'package:json_annotation/json_annotation.dart';
import 'package:odk_flutter_template/features/mine/models/app_version_info.dart';

part 'version_check_result.g.dart';

@JsonSerializable()
class VersionCheckResult {
  /// 是否有新版本
  final bool hasUpdate;

  /// 最新版本信息（有更新时不为空）
  final AppVersionInfo? latestVersion;

  /// 当前版本号
  final String currentVersion;

  VersionCheckResult({
    required this.hasUpdate,
    this.latestVersion,
    required this.currentVersion,
  });

  factory VersionCheckResult.fromJson(Map<String, dynamic> json) =>
      _$VersionCheckResultFromJson(json);

  Map<String, dynamic> toJson() => _$VersionCheckResultToJson(this);
}
