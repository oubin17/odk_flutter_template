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

  factory ServiceResponse.fromJson(Map<String, dynamic> json) =>
      _$ServiceResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ServiceResponseToJson(this);
}
