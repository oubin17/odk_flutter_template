import 'package:odk_flutter_template/features/home/data/api/home_resume_api.dart';
import 'package:odk_flutter_template/features/home/data/models/private_resume.dart';
import 'package:odk_flutter_template/features/home/data/models/project_info.dart';
import 'package:odk_flutter_template/features/home/data/models/projectinfo_statistics_response.dart';
import 'package:odk_flutter_template/features/home/data/models/resume_library.dart';

class HomeResumeService {
  static final HomeResumeService _instance = HomeResumeService._internal();

  HomeResumeService._internal();
  factory HomeResumeService() => _instance;

  /// 获取首页项目统计信息
  Future<ProjectInfoStatisticsResponse> getProjectInfoStatistics() async {
    return await HomeResumeApi().getProjectInfoStatistics();
  }

  /// 获取首页项目列表
  Future<List<ProjectInfo>> getProjectInfo() async {
    return await HomeResumeApi().getProjectInfo();
  }

  /// 获取隐私简历列表
  Future<List<PrivateResumeInfo>> getPrivateResumeInfo() async {
    return [];
    // return await HomeResumeApi().getPrivateResumeInfo();
  }

  /// 添加隐私简历
  Future<dynamic> privateResumeAdd(ResumeLibraryInfo resumeLibraryInfo) async {
    return await HomeResumeApi().privateResumeAdd(resumeLibraryInfo);
  }
}
