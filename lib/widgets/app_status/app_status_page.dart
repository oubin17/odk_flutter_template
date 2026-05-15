import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odk_flutter_template/core/utils/l10n_utils.dart';
import 'package:odk_flutter_template/widgets/app_widgets/app_widgets.dart';

/// 状态页面类型枚举
enum AppStatusType {
  /// 加载中
  loading,

  /// 空数据
  empty,

  /// 网络错误
  networkError,

  /// 服务器错误
  serverError,

  /// 页面未找到（404）
  notFound,

  /// 未知错误
  unknownError,
}

/// 统一状态页面组件
///
/// 提供统一的空数据页、网络错误页、加载中页、服务器错误页、404页面等。
/// 所有状态页面风格一致，支持自定义图标、文案和操作按钮。
///
/// **使用示例：**
///
/// ```dart
/// // 加载中
/// AppStatusPage.loading()
///
/// // 空数据
/// AppStatusPage.empty()
///
/// // 网络错误（带重试按钮）
/// AppStatusPage.networkError(onRetry: _reload)
///
/// // 服务器错误
/// AppStatusPage.serverError(onRetry: _reload)
///
/// // 404页面
/// AppStatusPage.notFound()
///
/// // 自定义
/// AppStatusPage(
///   type: AppStatusType.empty,
///   icon: Icons.inbox,
///   title: '暂无订单',
///   subtitle: '您还没有任何订单',
///   actionText: '去下单',
///   onAction: _goToOrder,
/// )
/// ```
class AppStatusPage extends StatelessWidget {
  /// 状态类型
  final AppStatusType type;

  /// 自定义图标（优先级高于默认图标）
  final IconData? icon;

  /// 自定义标题（优先级高于默认标题）
  final String? title;

  /// 自定义副标题（优先级高于默认副标题）
  final String? subtitle;

  /// 操作按钮文案
  final String? actionText;

  /// 操作按钮回调
  final VoidCallback? onAction;

  /// 自定义子组件（优先级最高，设置后忽略 icon/title/subtitle/actionText）
  final Widget? child;

  const AppStatusPage({
    super.key,
    required this.type,
    this.icon,
    this.title,
    this.subtitle,
    this.actionText,
    this.onAction,
    this.child,
  });

  // ===================== 便捷构造函数 =====================

  /// 加载中状态
  const AppStatusPage.loading({super.key})
    : type = AppStatusType.loading,
      icon = null,
      title = null,
      subtitle = null,
      actionText = null,
      onAction = null,
      child = null;

  /// 空数据状态
  const AppStatusPage.empty({
    super.key,
    String? subtitle,
    String? actionText,
    VoidCallback? onAction,
  }) : type = AppStatusType.empty,
       icon = null,
       title = null,
       subtitle = subtitle,
       actionText = actionText,
       onAction = onAction,
       child = null;

  /// 网络错误状态
  const AppStatusPage.networkError({
    super.key,
    String? subtitle,
    String? actionText,
    VoidCallback? onAction,
  }) : type = AppStatusType.networkError,
       icon = null,
       title = null,
       subtitle = subtitle,
       actionText = actionText,
       onAction = onAction,
       child = null;

  /// 服务器错误状态
  const AppStatusPage.serverError({
    super.key,
    String? subtitle,
    String? actionText,
    VoidCallback? onAction,
  }) : type = AppStatusType.serverError,
       icon = null,
       title = null,
       subtitle = subtitle,
       actionText = actionText,
       onAction = onAction,
       child = null;

  /// 404 页面未找到
  const AppStatusPage.notFound({
    super.key,
    String? subtitle,
    String? actionText,
    VoidCallback? onAction,
  }) : type = AppStatusType.notFound,
       icon = null,
       title = null,
       subtitle = subtitle,
       actionText = actionText,
       onAction = onAction,
       child = null;

  /// 未知错误状态
  const AppStatusPage.unknownError({
    super.key,
    String? subtitle,
    String? actionText,
    VoidCallback? onAction,
  }) : type = AppStatusType.unknownError,
       icon = null,
       title = null,
       subtitle = subtitle,
       actionText = actionText,
       onAction = onAction,
       child = null;

  // ===================== 默认配置 =====================

  /// 获取默认图标
  IconData _defaultIcon() {
    switch (type) {
      case AppStatusType.loading:
        return Icons.hourglass_empty;
      case AppStatusType.empty:
        return Icons.inbox_outlined;
      case AppStatusType.networkError:
        return Icons.wifi_off_outlined;
      case AppStatusType.serverError:
        return Icons.cloud_off_outlined;
      case AppStatusType.notFound:
        return Icons.search_off_outlined;
      case AppStatusType.unknownError:
        return Icons.error_outline;
    }
  }

  /// 获取默认图标颜色
  Color _defaultIconColor(BuildContext context) {
    switch (type) {
      case AppStatusType.loading:
        return AppColors.primary(context);
      case AppStatusType.empty:
        return AppColors.textGray(context);
      case AppStatusType.networkError:
        return AppColors.textGray(context);
      case AppStatusType.serverError:
        return AppColors.textGray(context);
      case AppStatusType.notFound:
        return AppColors.textGray(context);
      case AppStatusType.unknownError:
        return AppColors.textGray(context);
    }
  }

  /// 获取默认标题
  String _defaultTitle() {
    switch (type) {
      case AppStatusType.loading:
        return L10nUtils.loading;
      case AppStatusType.empty:
        return L10nUtils.emptyData;
      case AppStatusType.networkError:
        return L10nUtils.networkErrorDesc;
      case AppStatusType.serverError:
        return L10nUtils.serverErrorDesc;
      case AppStatusType.notFound:
        return L10nUtils.pageNotFoundDesc;
      case AppStatusType.unknownError:
        return L10nUtils.unknownErrorDesc;
    }
  }

  /// 获取默认操作按钮文案
  String? _defaultActionText() {
    switch (type) {
      case AppStatusType.loading:
        return null;
      case AppStatusType.empty:
        return null;
      case AppStatusType.networkError:
        return L10nUtils.retry;
      case AppStatusType.serverError:
        return L10nUtils.retry;
      case AppStatusType.notFound:
        return null;
      case AppStatusType.unknownError:
        return L10nUtils.retry;
    }
  }

  @override
  Widget build(BuildContext context) {
    // 自定义子组件优先级最高
    if (child != null) return child!;

    // 加载中状态使用专用布局
    if (type == AppStatusType.loading) {
      return _buildLoading(context);
    }

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 60.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 图标
            Icon(
              icon ?? _defaultIcon(),
              size: 120.w,
              color: _defaultIconColor(context),
            ),
            AppGap.hLarge,
            // 标题
            AppText(
              title ?? _defaultTitle(),
              size: 26.sp,
              align: TextAlign.center,
            ),
            // 副标题
            if (subtitle != null && subtitle!.isNotEmpty) ...[
              AppGap.hSmall,
              AppText(subtitle!, size: 24.sp, align: TextAlign.center),
            ],
            // 操作按钮
            if (_hasAction()) ...[AppGap.hLarge, _buildActionButton(context)],
          ],
        ),
      ),
    );
  }

  /// 构建加载中状态
  Widget _buildLoading(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            color: AppColors.primary(context),
            strokeWidth: 3.w,
          ),
          AppGap.hNormal,
          AppText.second(title ?? L10nUtils.loading),
        ],
      ),
    );
  }

  /// 是否有操作按钮
  bool _hasAction() {
    final effectiveActionText = actionText ?? _defaultActionText();
    return effectiveActionText != null && onAction != null;
  }

  /// 构建操作按钮
  Widget _buildActionButton(BuildContext context) {
    final effectiveActionText = actionText ?? _defaultActionText() ?? '';
    return SizedBox(
      width: 240.w,
      height: 72.h,
      child: OutlinedButton(
        onPressed: onAction,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: AppColors.primary(context), width: 1.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.w),
          ),
        ),
        child: AppText(
          effectiveActionText,
          color: AppColors.primary(context),
          size: 28.sp,
        ),
      ),
    );
  }
}
