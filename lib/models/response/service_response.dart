import 'package:json_annotation/json_annotation.dart';
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

  // ✅ 新增：快捷创建网络错误响应
  factory ServiceResponse.networkError() {
    return ServiceResponse(success: false, errorContext: '无网络连接');
  }

  factory ServiceResponse.fromJson(Map<String, dynamic> json) =>
      _$ServiceResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ServiceResponseToJson(this);
}
