import 'package:odk_flutter_template/core/network/api_service.dart';
import 'package:odk_flutter_template/core/utils/log_utils.dart';
import 'package:odk_flutter_template/features/home/data/models/private_resume.dart';
import 'package:odk_flutter_template/features/home/data/models/project_info.dart';
import 'package:odk_flutter_template/features/home/data/models/projectinfo_statistics_response.dart';
import 'package:odk_flutter_template/features/home/data/models/resume_library.dart';
import 'package:odk_flutter_template/models/request/page_request.dart';
import 'package:odk_flutter_template/models/response/page_response.dart';
import 'package:odk_flutter_template/models/response/service_response.dart';

class HomeResumeApi {
  static final HomeResumeApi _instance = HomeResumeApi._internal();

  HomeResumeApi._internal();
  factory HomeResumeApi() => _instance;

  /// 顶部数据汇总
  Future<ProjectInfoStatisticsResponse> getProjectInfoStatistics() async {
    try {
      ServiceResponse response = await ApiService().get(
        '/project/info/statistic',
      );

      if (response.data == null) {
        return ProjectInfoStatisticsResponse(
          validReportCount: 0,
          addReportCount: 0,
          reviewCount: 0,
          todayReviewCount: 0,
        );
      }

      return ProjectInfoStatisticsResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
    } catch (e, stackTrace) {
      Log.e('🚨 [HomeResumeApi] 获取项目统计信息失败: $e, $stackTrace');
      rethrow;
    }
  }

  /// 项目列表
  Future<List<ProjectInfo>> getProjectInfo() async {
    try {
      PageRequest pageRequest = PageRequest.withValues(
        page: 0,
        size: 10,
        sortField: 'updateTime',
        sortDirection: 'DESC',
      );
      ServiceResponse response = await ApiService().post(
        '/project/info/list',
        pageRequest,
      );
      if (response.data == null) {
        return [];
      }
      PageResponse<ProjectInfo> pageResponse =
          PageResponse<ProjectInfo>.fromJson(
            response.data as Map<String, dynamic>,
            (json) => ProjectInfo.fromJson(json as Map<String, dynamic>),
          );

      return pageResponse.pageList.toList();
    } catch (e, stackTrace) {
      Log.e('🚨 [HomeResumeApi] 获取项目信息失败: $e, $stackTrace');
      rethrow;
    }
  }

  /// 隐私简历列表
  Future<List<PrivateResumeInfo>> getPrivateResumeInfo() async {
    try {
      PageRequest pageRequest = PageRequest.withValues(
        page: 0,
        size: 500,
        sortField: 'in_time',
        sortDirection: 'DESC',
      );
      ServiceResponse response = await ApiService().post(
        '/resume/private/list',
        pageRequest,
      );
      if (response.data == null) {
        return [];
      }
      PageResponse<PrivateResumeInfo> pageResponse =
          PageResponse<PrivateResumeInfo>.fromJson(
            response.data as Map<String, dynamic>,
            (json) => PrivateResumeInfo.fromJson(json as Map<String, dynamic>),
          );

      return pageResponse.pageList.toList();
    } catch (e, stackTrace) {
      Log.e('🚨 [HomeResumeApi] 获取隐私简历信息失败: $e, $stackTrace');
      rethrow;
    }
  }

  /// 添加隐私简历
  Future<dynamic> privateResumeAdd(ResumeLibraryInfo resumeLibraryInfo) async {
    try {
      ServiceResponse response = await ApiService().post(
        '/resume/private/add',
        resumeLibraryInfo.toJson(),
      );
      if (response.success) {
        return true;
      } else {
        return response.errorContext;
      }
    } catch (e, stackTrace) {
      Log.e('🚨 [HomeResumeApi] 添加隐私简历失败: $e, $stackTrace');
      rethrow;
    }
  }
}
