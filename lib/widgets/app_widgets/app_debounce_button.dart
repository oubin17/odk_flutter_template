import 'package:flutter/material.dart';
import 'package:odk_flutter_template/widgets/app_widgets/app_widgets.dart';
import 'package:odk_flutter_template/widgets/mixins/mounted_safe_mixin.dart';

/// 防重复点击按钮
///
/// 内置防抖逻辑，点击后自动禁用，等待异步操作完成后恢复。
/// 无需手动管理 isLoading 状态，适用于大多数提交场景。
///
/// 示例：
/// ```dart
/// AppDebounceButton(
///   text: '登录',
///   onTap: () async {
///     final result = await vm.login();
///     // 处理结果...
///   },
/// )
/// ```
class AppDebounceButton extends StatefulWidget {
  /// 按钮文字
  final String text;

  /// 点击回调（支持异步）
  /// 返回 Future 时，按钮会等待完成后再恢复可点击
  /// 返回 null 或同步操作时，使用 [debounceDuration] 控制恢复时间
  final Future<void> Function()? onTap;

  /// 防抖时长（同步操作场景下的冷却时间）
  final Duration debounceDuration;

  /// 按钮高度
  final double? height;

  /// 背景色
  final Color? bgColor;

  /// 是否禁用（外部控制，如协议未勾选）
  final bool disabled;

  const AppDebounceButton({
    super.key,
    required this.text,
    required this.onTap,
    this.debounceDuration = const Duration(milliseconds: 500),
    this.height,
    this.bgColor,
    this.disabled = false,
  });

  @override
  State<AppDebounceButton> createState() => _AppDebounceButtonState();
}

class _AppDebounceButtonState extends State<AppDebounceButton>
    with MountedSafeMixin {
  bool _isProcessing = false;

  Future<void> _handleTap() async {
    if (_isProcessing || widget.disabled) return;

    setState(() => _isProcessing = true); // 同步操作，无需安全检查

    try {
      await widget.onTap?.call();
    } finally {
      // 异步操作完成后恢复（确保最短防抖时长）
      await Future.delayed(widget.debounceDuration);
      mountedSafeSetState(
        () => _isProcessing = false,
      ); // await 之后，使用安全 setState
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: widget.text,
      onTap: _isProcessing || widget.disabled ? null : _handleTap,
      disabled: widget.disabled,
      isLoading: _isProcessing,
      height: widget.height,
      bgColor: widget.bgColor,
    );
  }
}

/// 防重复点击包装器（适用于任意可点击组件）
///
/// 不改变子组件外观，仅添加防抖逻辑。
/// 适用于图标按钮、卡片点击等场景。
///
/// 示例：
/// ```dart
/// AppDebounceWrapper(
///   onTap: () => context.pushNamed(RouteNames.userInfo),
///   child: AppIconButton(icon: Icons.edit, onTap: null),
/// )
/// ```
class AppDebounceWrapper extends StatefulWidget {
  final Future<void> Function()? onTap;
  final Widget child;
  final Duration debounceDuration;

  const AppDebounceWrapper({
    super.key,
    required this.onTap,
    required this.child,
    this.debounceDuration = const Duration(milliseconds: 500),
  });

  @override
  State<AppDebounceWrapper> createState() => _AppDebounceWrapperState();
}

class _AppDebounceWrapperState extends State<AppDebounceWrapper>
    with MountedSafeMixin {
  bool _isProcessing = false;

  Future<void> _handleTap() async {
    if (_isProcessing) return;

    setState(() => _isProcessing = true); // 同步操作，无需安全检查

    try {
      await widget.onTap?.call();
    } finally {
      await Future.delayed(widget.debounceDuration);
      mountedSafeSetState(
        () => _isProcessing = false,
      ); // await 之后，使用安全 setState
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _isProcessing ? null : _handleTap,
      child: widget.child,
    );
  }
}
