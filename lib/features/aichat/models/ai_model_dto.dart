import 'package:json_annotation/json_annotation.dart';

part 'ai_model_dto.g.dart';

/// AI模型配置数据传输对象
@JsonSerializable()
class AiModelDTO {
  /// 模型代码（唯一标识）
  final String? modelCode;

  /// 模型名称（显示名称）
  final String? modelName;

  /// 协议类型（OPENAI/ALIBABA）
  final String? providerType;

  /// 模型描述
  final String? description;

  /// 排序号
  final int? sortOrder;

  AiModelDTO({
    this.modelCode,
    this.modelName,
    this.providerType,
    this.description,
    this.sortOrder,
  });

  factory AiModelDTO.fromJson(Map<String, dynamic> json) =>
      _$AiModelDTOFromJson(json);

  Map<String, dynamic> toJson() => _$AiModelDTOToJson(this);
}
