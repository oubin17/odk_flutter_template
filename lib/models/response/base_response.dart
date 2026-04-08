import 'package:json_annotation/json_annotation.dart';

part 'base_response.g.dart';

@JsonSerializable()
class BaseResponse {
  bool success;
  String? errorType;
  String? errorCode;
  String? errorContext;

  BaseResponse({
    required this.success,
    this.errorType,
    this.errorCode,
    this.errorContext,
  });

  factory BaseResponse.fromJson(Map<String, dynamic> json) =>
      _$BaseResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BaseResponseToJson(this);
}
