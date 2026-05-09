import 'package:odk_flutter_template/core/network/api_service.dart';
import 'package:odk_flutter_template/features/basic_user/data/models/user_query/user_entity.dart';
import 'package:odk_flutter_template/models/response/service_response.dart';

class UserQueryApi {
  // 单例实例
  static final UserQueryApi _instance = UserQueryApi._internal();

  UserQueryApi._internal();
  factory UserQueryApi() => _instance;

  /// 获取用户信息
  Future<UserEntity> getUserInfo() async {
    ServiceResponse response = await ApiService().get('/user/query');

    return UserEntity.fromJson(response.data as Map<String, dynamic>);
  }
}
