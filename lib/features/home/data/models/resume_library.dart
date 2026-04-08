import 'package:json_annotation/json_annotation.dart';

part 'resume_library.g.dart';

@JsonSerializable()
class ResumeLibraryInfo {
  String? name;
  String? mobile;
  String? age;
  String? workAddr;
  String? idNo;

  String? domicile;
  String? extendInfo;

  String? gender;

  ResumeLibraryInfo({
    this.name,
    this.mobile,
    this.age,
    this.gender,
    this.domicile,
    this.extendInfo,
    this.workAddr,
    this.idNo,
  });

  factory ResumeLibraryInfo.fromJson(Map<String, dynamic> json) =>
      _$ResumeLibraryInfoFromJson(json);

  Map<String, dynamic> toJson() => _$ResumeLibraryInfoToJson(this);
}
