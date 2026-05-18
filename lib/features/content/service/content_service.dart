import 'package:odk_flutter_template/features/content/api/content_api.dart';
import 'package:odk_flutter_template/features/content/models/content_detail_response.dart';
import 'package:odk_flutter_template/features/content/models/content_item.dart';
import 'package:odk_flutter_template/models/request/page_request.dart';
import 'package:odk_flutter_template/models/response/page_response.dart';

/// 内容服务层
///
/// 封装内容相关的业务逻辑，调用 [ContentApi] 获取数据。
/// 后续对接真实接口时，只需修改 [ContentApi] 实现即可。
class ContentService {
  static final ContentService _instance = ContentService._internal();

  ContentService._internal();
  factory ContentService() => _instance;

  final ContentApi _api = ContentApi();

  /// 获取内容列表（分页）
  ///
  /// 根据 [pageRequest] 中的 page、size 等参数请求分页数据，
  /// 返回 [PageResponse<ContentItem>]。
  Future<PageResponse<ContentItem>> getContentList(
    PageRequest pageRequest,
  ) async {
    return await _api.getContentList(pageRequest);
  }

  /// 获取内容详情
  ///
  /// 根据 [id] 请求详情数据，返回 [ContentDetailResponse]。
  Future<ContentDetailResponse> getContentDetail(String id) async {
    return await _api.getContentDetail(id);
  }
}
