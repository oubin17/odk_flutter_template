import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odk_flutter_template/features/content/models/content_detail_response.dart';
import 'package:odk_flutter_template/features/content/service/content_service.dart';
import 'package:odk_flutter_template/widgets/app_page/app_bar.dart';
import 'package:odk_flutter_template/widgets/app_widgets/app_widgets.dart';

/// 内容详情页
///
/// 接收内容 [id]，进入页面后通过 [ContentService] 请求详情数据。
/// 使用 [FutureBuilder] 管理加载状态（加载中 / 加载失败 / 加载成功）。
class ContentDetailPage extends StatefulWidget {
  /// 内容 ID
  final String id;

  const ContentDetailPage({super.key, required this.id});

  @override
  State<ContentDetailPage> createState() => _ContentDetailPageState();
}

class _ContentDetailPageState extends State<ContentDetailPage> {
  /// 详情数据 Future
  late final Future<ContentDetailResponse> _detailFuture;

  @override
  void initState() {
    super.initState();
    _detailFuture = ContentService().getContentDetail(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BasicAppBar(title: AppText('详情')),
      body: FutureBuilder<ContentDetailResponse>(
        future: _detailFuture,
        builder: (context, snapshot) {
          // 加载中
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 加载失败
          if (snapshot.hasError || !snapshot.hasData) {
            return _buildErrorView(snapshot.error);
          }

          // 加载成功
          final detail = snapshot.data!;
          return _buildDetailContent(context, detail);
        },
      ),
    );
  }

  /// 构建错误视图
  Widget _buildErrorView(Object? error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48.w,
            color: AppColors.textGray(context),
          ),
          AppGap.hNormal,
          AppText.second('加载失败'),
          if (error != null) ...[
            AppGap.hSmall,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: Text(
                error.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24.sp,
                  color: AppColors.textGray(context),
                ),
              ),
            ),
          ],
          AppGap.hNormal,
          ElevatedButton(onPressed: _retry, child: const Text('重试')),
        ],
      ),
    );
  }

  /// 重试加载
  void _retry() {
    setState(() {
      _detailFuture = ContentService().getContentDetail(widget.id);
    });
  }

  /// 构建详情内容
  Widget _buildDetailContent(
    BuildContext context,
    ContentDetailResponse detail,
  ) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 图片占位区域
          _buildImagePlaceholder(context, detail),
          // 内容区域
          Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 标题
                AppText(detail.title, size: 32.sp, maxLines: 10),
                AppGap.hNormal,
                // 作者信息行
                _buildAuthorRow(context, detail),
                AppGap.hNormal,
                // 发布时间
                AppText.tip(detail.publishTime),
                AppGap.hLarge,
                // 正文内容
                Text(
                  detail.content,
                  style: TextStyle(fontSize: 28.sp, height: 1.8),
                ),
                AppGap.hLarge,
                // 标签
                _buildTags(context, detail),
                AppGap.hLarge,
                // 互动数据
                _buildInteractionBar(context, detail),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建图片占位区域
  Widget _buildImagePlaceholder(
    BuildContext context,
    ContentDetailResponse detail,
  ) {
    return Container(
      width: double.infinity,
      height: 400.h,
      color: Color(detail.imageColor),
      child: Center(
        child: Icon(
          Icons.image_outlined,
          size: 64.w,
          color: AppColors.textGray(context).withAlpha(100),
        ),
      ),
    );
  }

  /// 构建作者信息行
  Widget _buildAuthorRow(BuildContext context, ContentDetailResponse detail) {
    return Row(
      children: [
        // 头像占位
        Container(
          width: 48.w,
          height: 48.w,
          decoration: BoxDecoration(
            color: Color(detail.avatarColor),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              Icons.person,
              size: 24.w,
              color: AppColors.primary(context),
            ),
          ),
        ),
        AppGap.wSmall,
        Expanded(
          child: Text(
            detail.authorName,
            style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.w500),
          ),
        ),
        // 关注按钮
        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 4.h),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text('关注', style: TextStyle(fontSize: 24.sp)),
        ),
      ],
    );
  }

  /// 构建标签
  Widget _buildTags(BuildContext context, ContentDetailResponse detail) {
    return Wrap(
      spacing: 12.w,
      runSpacing: 8.h,
      children: detail.tags.map((tag) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: AppColors.bgPage(context),
            borderRadius: BorderRadius.circular(16.w),
          ),
          child: Text(
            '#$tag',
            style: TextStyle(
              fontSize: 24.sp,
              color: AppColors.primary(context),
            ),
          ),
        );
      }).toList(),
    );
  }

  /// 构建互动数据栏
  Widget _buildInteractionBar(
    BuildContext context,
    ContentDetailResponse detail,
  ) {
    return Row(
      children: [
        _buildInteractionItem(
          context,
          Icons.favorite_outline,
          detail.likeCount,
        ),
        AppGap.wNormal,
        _buildInteractionItem(context, Icons.star_outline, detail.collectCount),
        AppGap.wNormal,
        _buildInteractionItem(
          context,
          Icons.chat_bubble_outline,
          detail.commentCount,
        ),
      ],
    );
  }

  /// 构建单个互动项
  Widget _buildInteractionItem(BuildContext context, IconData icon, int count) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 28.w, color: AppColors.textGray(context)),
        AppGap.wSuperSmall,
        Text(
          _formatCount(count),
          style: TextStyle(fontSize: 24.sp, color: AppColors.textGray(context)),
        ),
      ],
    );
  }

  /// 格式化数量
  String _formatCount(int count) {
    if (count >= 10000) {
      return '${(count / 10000).toStringAsFixed(1)}w';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return count.toString();
  }
}
