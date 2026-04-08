import 'package:json_annotation/json_annotation.dart';
part 'page_request.g.dart';

@JsonSerializable()
class PageRequest {
  int page = 1;
  int size = 10;
  String? sortField;
  String? sortDirection;

  PageRequest();

  PageRequest.withValues({
    required this.page,
    required this.size,
    this.sortField,
    this.sortDirection,
  });

  factory PageRequest.fromJson(Map<String, dynamic> json) =>
      _$PageRequestFromJson(json);

  Map<String, dynamic> toJson() => _$PageRequestToJson(this);
}
