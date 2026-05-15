import 'package:flutter/material.dart';
import 'package:odk_flutter_template/widgets/app_status/app_status_page.dart';

/// 通用 FutureBuilder 封装
///
/// 统一处理加载中、错误、空数据三种状态，只需关注成功状态的 UI 构建。
///
/// **使用示例：**
///
/// ```dart
/// CommonFutureBuilder<UserInfo>(
///   future: _fetchUserInfo(),
///   onSuccess: (data) => Text(data.name),
/// )
///
/// // 带重试
/// CommonFutureBuilder<List<Order>>(
///   future: _fetchOrders(),
///   onRetry: _refresh,
///   onSuccess: (data) => ListView(children: [...]),
/// )
/// ```
class CommonFutureBuilder<T> extends StatelessWidget {
  /// 异步数据源
  final Future<T> future;

  /// 成功状态回调
  final Widget Function(T data) onSuccess;

  /// 重试回调（设置后错误状态会显示重试按钮）
  final VoidCallback? onRetry;

  /// 自定义错误提示文案
  final String? errorText;

  /// 自定义空数据提示文案
  final String? emptyText;

  const CommonFutureBuilder({
    super.key,
    required this.future,
    required this.onSuccess,
    this.onRetry,
    this.errorText,
    this.emptyText,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        // 1. 加载中
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const AppStatusPage.loading();
        }

        // 2. 加载失败
        if (snapshot.hasError) {
          return AppStatusPage.unknownError(
            subtitle: errorText,
            onAction: onRetry,
          );
        }

        // 3. 无数据
        if (!snapshot.hasData || snapshot.data == null) {
          return AppStatusPage.empty(subtitle: emptyText);
        }

        // 4. 数据成功返回
        return onSuccess(snapshot.data as T);
      },
    );
  }
}
