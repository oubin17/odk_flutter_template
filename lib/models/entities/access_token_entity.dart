import 'package:json_annotation/json_annotation.dart';

part 'access_token_entity.g.dart';

@JsonSerializable()
class AccessTokenEntity {
  String tokenValue;
  String tokenType;

  AccessTokenEntity({required this.tokenValue, required this.tokenType});

  factory AccessTokenEntity.fromJson(Map<String, dynamic> json) =>
      _$AccessTokenEntityFromJson(json);

  // 2. 👇 添加这个 toJson 方法
  Map<String, dynamic> toJson() => _$AccessTokenEntityToJson(this);
}
