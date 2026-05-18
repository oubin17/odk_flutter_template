import 'package:odk_flutter_template/core/network/api_service.dart';
import 'package:odk_flutter_template/features/mine/models/user_identify/password_reset_request.dart';
import 'package:odk_flutter_template/features/mine/models/user_identify/password_update_request.dart';
import 'package:odk_flutter_template/models/response/service_response.dart';

class UserIdentifyApi {
  // 单例实例
  static final UserIdentifyApi _instance = UserIdentifyApi._internal();

  UserIdentifyApi._internal();
  factory UserIdentifyApi() => _instance;

  /// 更新用户密码
  Future<ServiceResponse> updatePassword(PasswordUpdateRequest request) async {
    return await ApiService().post('/user/password/update', request.toJson());
  }

  /// 重置用户密码
  Future<ServiceResponse> resetPassword(PasswordResetRequest request) async {
    return await ApiService().post('/user/password/reset', request.toJson());
  }
}
