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
}
