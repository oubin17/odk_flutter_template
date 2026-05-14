import 'package:odk_flutter_template/core/session/user_session_service.dart';
import 'package:odk_flutter_template/features/basic_user/data/api/user_profile_api.dart';
import 'package:odk_flutter_template/features/basic_user/data/models/user_profile/user_profile_request.dart';
import 'package:odk_flutter_template/features/basic_user/domain/user_query_service.dart';
import 'package:odk_flutter_template/features/basic_user/data/models/user_query/user_entity.dart';
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
      UserEntity userEntity = await UserQueryService().getUserInfo();
      await UserSessionService().syncUserSession(
        userEntity,
        token: null,
        updateToken: false,
      );
    }
    return response;
  }

  /// 上传头像并更新用户信息
  /// [filePath] 本地图片文件路径
  Future<ServiceResponse> updateAvatar(String filePath) async {
    // 1. 先上传头像文件，获取 URL
    ServiceResponse uploadResponse = await UserProfileApi().uploadAvatar(
      filePath,
    );
    if (!uploadResponse.success) {
      return uploadResponse;
    }

    // 2. 从上传响应中获取头像 URL
    final String? avatarUrl = uploadResponse.data?.toString();
    if (avatarUrl == null || avatarUrl.isEmpty) {
      return ServiceResponse(success: false, errorContext: '头像上传失败，未获取到头像地址');
    }

    // 3. 更新用户信息中的头像 URL
    ServiceResponse updateResponse = await UserProfileApi().updateProfile(
      UserProfileRequest(avatarUrl: avatarUrl),
    );
    if (updateResponse.success) {
      UserEntity userEntity = await UserQueryService().getUserInfo();
      await UserSessionService().syncUserSession(
        userEntity,
        token: null,
        updateToken: false,
      );
    }
    return updateResponse;
  }
}
