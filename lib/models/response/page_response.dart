import 'package:json_annotation/json_annotation.dart';
part 'page_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class PageResponse<T> {
  int count = 0;
  List<T> pageList = [];

  PageResponse();
  // 生成的代码现在会需要一个 `fromJson` 函数作为参数
  factory PageResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT, // 👈 注意这个新增的参数
  ) => _$PageResponseFromJson(json, fromJsonT);

  // 生成的代码现在会需要一个 `toJson` 函数作为参数
  Map<String, dynamic> toJson(T Function(T value) toJsonT) =>
      _$PageResponseToJson(this, toJsonT);
}
