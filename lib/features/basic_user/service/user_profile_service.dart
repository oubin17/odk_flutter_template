import 'package:odk_flutter_template/features/basic_user/api/user_profile_api.dart';
import 'package:odk_flutter_template/features/basic_user/models/user_profile/user_profile_request.dart';
import 'package:odk_flutter_template/features/basic_user/service/user_query_service.dart';
import 'package:odk_flutter_template/models/response/service_response.dart';

class UserProfileService {
  // 单例实例
  static final UserProfileService _instance = UserProfileService._internal();

  UserProfileService._internal();
  factory UserProfileService() => _instance;

  /// 更新用户信息
  Future<ServiceResponse> updateProfile(UserProfileRequest request) async {
    ServiceResponse response = await UserProfileApi().updateProfile(request);
    if (response.success) {
      await UserQueryService().reloadUserInfo();
    }
    return response;
  }

  /// 上传头像并更新用户信息
  /// [filePath] 本地图片文件路径
  Future<String> updateAvatar(String filePath) async {
    // 1. 先上传头像文件，获取 URL
    ServiceResponse uploadResponse = await UserProfileApi().uploadAvatar(
      filePath,
    );
    if (!uploadResponse.success) {
      return "";
    }

    // 3. 更新用户信息中的头像 URL
    ServiceResponse urlResponse = await UserProfileApi().getAvatarUrl();
    if (!urlResponse.success) {
      return "";
    }

    if (urlResponse.success) {
      await UserQueryService().reloadUserInfo();
    }
    return urlResponse.data ?? "";
  }
}
