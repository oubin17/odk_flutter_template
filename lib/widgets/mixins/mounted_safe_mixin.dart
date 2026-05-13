import 'package:flutter/widgets.dart';

/// 安全的 State Mixin，自动处理异步操作后的 mounted 检查。
///
/// 在异步操作（await）之后调用 [setState] 时，Widget 可能已经被销毁，
/// 直接调用会抛出 "setState() called after dispose()" 异常。
///
/// 使用此 Mixin 后，可通过以下方法避免手动检查 mounted：
///
/// - [mountedSafeSetState]：仅在 mounted 时执行 setState
/// - [mountedSafeCallback]：仅在 mounted 时执行回调（如导航跳转）
///
/// 示例：
/// ```dart
/// class _MyPageState extends State<MyPage> with MountedSafeMixin {
///   Future<void> _loadData() async {
///     setState(() => _isLoading = true); // 同步操作，无需安全检查
///     try {
///       final result = await api.fetchData();
///       mountedSafeSetState(() {         // await 之后，需要安全检查
///         _data = result;
///         _isLoading = false;
///       });
///     } catch (e) {
///       mountedSafeSetState(() => _isLoading = false);
///     }
///   }
/// }
/// ```
mixin MountedSafeMixin<T extends StatefulWidget> on State<T> {
  /// 仅在 mounted 时执行 [setState]，避免 "setState() called after dispose()" 异常。
  ///
  /// 适用于异步操作（await）完成后需要更新 UI 的场景。
  void mountedSafeSetState(VoidCallback fn) {
    if (mounted) {
      setState(fn);
    }
  }

  /// 仅在 mounted 时执行回调，适用于不需要 setState 的场景（如导航跳转、显示 Toast）。
  ///
  /// 示例：
  /// ```dart
  /// final result = await someAsyncOp();
  /// mountedSafeCallback(() {
  ///   Navigator.of(context).push(...);
  /// });
  /// ```
  void mountedSafeCallback(VoidCallback fn) {
    if (mounted) {
      fn();
    }
  }
}
