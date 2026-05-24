import 'package:json_annotation/json_annotation.dart';
import 'package:odk_flutter_template/core/utils/error_code_mapper.dart';
import 'package:odk_flutter_template/core/utils/l10n_utils.dart';
import 'package:odk_flutter_template/models/response/base_response.dart';

part 'service_response.g.dart';

@JsonSerializable()
class ServiceResponse extends BaseResponse {
  dynamic data;

  ServiceResponse({
    required super.success,
    this.data,
    super.errorType,
    super.errorCode,
    super.errorContext,
  });

  // ✅ 快捷创建网络错误响应
  factory ServiceResponse.networkError() {
    return ServiceResponse(
      success: false,
      errorContext: L10nUtils.noNetworkConnection,
    );
  }

  factory ServiceResponse.commonError() {
    return ServiceResponse(
      success: false,
      errorContext: L10nUtils.requestError,
    );
  }

  factory ServiceResponse.bizError(
    String? errorType,
    String? errorCode,
    String? errorContext,
  ) {
    return ServiceResponse(
      success: false,
      errorType: errorType,
      errorCode: errorCode,
      errorContext: errorContext,
    );
  }

  /// 获取国际化错误信息
  ///
  /// 优先级：
  /// 1. 根据 errorCode 映射国际化文本（ErrorCodeMapper）
  /// 2. 降级到 errorContext（服务端原文，兜底）
  /// 3. 降级到 fallback 参数
  /// 4. 最终降级到 L10nUtils.operationFailed
  String localizedErrorMessage([String? fallback]) {
    return ErrorCodeMapper.localize(errorCode) ??
        fallback ??
        errorContext ??
        L10nUtils.operationFailed;
  }

  factory ServiceResponse.fromJson(Map<String, dynamic> json) =>
      _$ServiceResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ServiceResponseToJson(this);
}
