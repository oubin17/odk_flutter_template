import 'package:json_annotation/json_annotation.dart';
import 'package:odk_flutter_template/features/home/data/models/resume_library.dart';

part 'private_resume.g.dart';

@JsonSerializable()
class PrivateResumeInfo {
  String? remark;

  String? status;

  String? company;

  String? userName;

  ResumeLibraryInfo? resumeLibraryDTO;

  PrivateResumeInfo({
    this.remark,
    this.status,
    this.company,
    this.userName,
    this.resumeLibraryDTO,
  });

  factory PrivateResumeInfo.fromJson(Map<String, dynamic> json) =>
      _$PrivateResumeInfoFromJson(json);

  Map<String, dynamic> toJson() => _$PrivateResumeInfoToJson(this);
}
