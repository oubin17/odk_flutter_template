import 'package:odk_flutter_template/core/utils/encrypt_utils.dart';
import 'package:odk_flutter_template/features/basic_user/api/user_identify_api.dart';
import 'package:odk_flutter_template/features/basic_user/models/user_identify/password_reset_request.dart';
import 'package:odk_flutter_template/features/basic_user/models/user_identify/password_update_request.dart';
import 'package:odk_flutter_template/models/response/service_response.dart';

class UserIdentifyService {
  // 单例实例
  static final UserIdentifyService _instance = UserIdentifyService._internal();

  UserIdentifyService._internal();
  factory UserIdentifyService() => _instance;

  /// 更新用户密码
  Future<ServiceResponse> updatePassword(PasswordUpdateRequest request) async {
    request.oldIdentifyValue = await EncryptUtils.encrypt(
      request.oldIdentifyValue,
    );
    request.newIdentifyValue = await EncryptUtils.encrypt(
      request.newIdentifyValue,
    );
    return await UserIdentifyApi().updatePassword(request);
  }

  /// 重置用户密码
  Future<ServiceResponse> resetPassword(PasswordResetRequest request) async {
    request.identifyValue = await EncryptUtils.encrypt(request.identifyValue);
    return await UserIdentifyApi().resetPassword(request);
  }
}
