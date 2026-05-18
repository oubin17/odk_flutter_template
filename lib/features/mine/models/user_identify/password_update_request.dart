import 'package:json_annotation/json_annotation.dart';

part 'password_update_request.g.dart';

@JsonSerializable()
class PasswordUpdateRequest {
  String identifyType = "1";
  String oldIdentifyValue;
  String newIdentifyValue;

  PasswordUpdateRequest({
    required this.oldIdentifyValue,
    required this.newIdentifyValue,
  });
  factory PasswordUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$PasswordUpdateRequestFromJson(json);
  Map<String, dynamic> toJson() => _$PasswordUpdateRequestToJson(this);
}
