import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odk_flutter_template/features/content/models/content_item.dart';
import 'package:odk_flutter_template/features/content/service/content_service.dart';
import 'package:odk_flutter_template/models/request/page_request.dart';
import 'package:odk_flutter_template/routes/app_router.dart';
import 'package:odk_flutter_template/routes/navigator_utils.dart';
import 'package:odk_flutter_template/widgets/app_page/app_bar.dart';
import 'package:odk_flutter_template/widgets/app_refresh/app_refresh_list.dart';
import 'package:odk_flutter_template/widgets/app_widgets/app_widgets.dart';

/// 小红书风格内容首页
///
/// 使用 [AppRefreshList] 实现下拉刷新 + 上拉加载，
/// 支持单列列表和双列瀑布流两种布局模式，修改 [mode] 即可切换。
/// 数据通过 [ContentService] 分页接口获取。
class ContentPage extends StatefulWidget {
  const ContentPage({super.key});

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  /// 刷新控制器
  final _refreshController = AppRefreshListController();

  /// 内容服务
  final _contentService = ContentService();

  // ===================== 数据请求 =====================

  /// 下拉刷新：请求第一页数据
  Future<List<ContentItem>> _onRefresh(int page) async {
    final pageRequest = PageRequest.withValues(page: page, size: 10);
    final pageResponse = await _contentService.getContentList(pageRequest);
    return pageResponse.pageList.toList();
  }

  /// 上拉加载：请求下一页数据
  Future<List<ContentItem>> _onLoadMore(int page) async {
    final pageRequest = PageRequest.withValues(page: page, size: 10);
    final pageResponse = await _contentService.getContentList(pageRequest);
    return pageResponse.pageList.toList();
  }

  // ===================== 构建UI =====================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BasicAppBar(title: AppText('发现')),
      body: AppRefreshList<ContentItem>(
        controller: _refreshController,
        // 🔧 切换布局模式：修改此处即可
        // - AppRefreshListMode.list：单列列表
        // - AppRefreshListMode.masonryGrid：双列瀑布流
        mode: AppRefreshListMode.masonryGrid,
        crossAxisCount: 2,
        mainAxisSpacing: 8.h,
        crossAxisSpacing: 8.w,
        onRefresh: _onRefresh,
        onLoadMore: _onLoadMore,
        pageSize: 10,
        separatorBuilder: (_, _) => const SizedBox.shrink(),
        itemBuilder: (context, item, index) {
          return _ContentCard(
            item: item,
            onTap: () => _navigateToDetail(context, item),
          );
        },
      ),
    );
  }

  /// 跳转详情页（通过路由传 id，详情页自行请求数据）
  void _navigateToDetail(BuildContext context, ContentItem item) {
    NavigatorUtils.pushNamed(
      RouteNames.contentDetail,
      queryParameters: {'id': item.id},
    );
  }
}

/// 内容卡片组件（小红书风格）
class _ContentCard extends StatelessWidget {
  final ContentItem item;
  final VoidCallback onTap;

  const _ContentCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: AppColors.card(context),
          borderRadius: BorderRadius.circular(16.w),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(15),
              blurRadius: 8.w,
              offset: Offset(0, 2.w),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 图片占位区域
            _buildImagePlaceholder(context),
            // 内容区域
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 标题
                  AppText(item.title, size: 26.sp, maxLines: 2),
                  AppGap.hSmall,
                  // 作者信息 + 点赞
                  Row(
                    children: [
                      // 作者头像占位
                      _buildAvatarPlaceholder(context),
                      AppGap.wSmall,
                      // 作者名
                      Expanded(
                        child: Text(
                          item.authorName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 24.sp,
                            color: AppColors.textGray(context),
                          ),
                        ),
                      ),
                      // 点赞图标 + 数量
                      Icon(
                        Icons.favorite_outline,
                        size: 24.w,
                        color: AppColors.textGray(context),
                      ),
                      AppGap.wSuperSmall,
                      Text(
                        _formatLikeCount(item.likeCount),
                        style: TextStyle(
                          fontSize: 24.sp,
                          color: AppColors.textGray(context),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建图片占位区域
  Widget _buildImagePlaceholder(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.w)),
      child: Container(
        width: double.infinity,
        height: item.imageHeight.h,
        color: Color(item.imageColor),
        child: Center(
          child: Icon(
            Icons.image_outlined,
            size: 48.w,
            color: AppColors.textGray(context).withAlpha(100),
          ),
        ),
      ),
    );
  }

  /// 构建作者头像占位
  Widget _buildAvatarPlaceholder(BuildContext context) {
    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        color: Color(item.avatarColor),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          Icons.person,
          size: 20.w,
          color: AppColors.primary(context),
        ),
      ),
    );
  }

  /// 格式化点赞数量
  String _formatLikeCount(int count) {
    if (count >= 10000) {
      return '${(count / 10000).toStringAsFixed(1)}w';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return count.toString();
  }
}
