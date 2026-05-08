import 'package:odk_flutter_template/core/network/api_service.dart';
import 'package:odk_flutter_template/features/basic_user/data/models/user_profile/user_profile_request.dart';
import 'package:odk_flutter_template/models/response/service_response.dart';

class UserProfileApi {
  // 单例实例
  static final UserProfileApi _instance = UserProfileApi._internal();

  UserProfileApi._internal();
  factory UserProfileApi() => _instance;

  /// 更新用户信息
  Future<ServiceResponse> updateProfile(UserProfileRequest request) async {
    return await ApiService().post('/user/profile/update', request.toJson());
  }
}
