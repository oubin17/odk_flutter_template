import 'package:flutter/material.dart';
import 'package:odk_flutter_template/widgets/app_page/app_page.dart';
import 'package:odk_flutter_template/widgets/app_widgets/app_widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// WebView 通用页面
///
/// 功能特性：
/// - **标题栏动态更新**：加载网页后自动获取网页标题并更新 AppBar
/// - **加载进度条**：页面顶部显示线性进度条，加载完成自动隐藏
/// - **JS 交互**：支持 Flutter ↔ WebView 双向通信
///   - Flutter 调用 JS：通过 [jsChannelName] 通道向 WebView 发送消息
///   - JS 调用 Flutter：WebView 中通过 `window.flutter_inappwebview.callHandler('jsChannelName', data)` 调用
/// - **Cookie 同步**：加载完成后自动同步 WebView Cookie，保持登录态一致
///
/// **使用示例：**
///
/// ```dart
/// // 基础用法（协议页面）
/// AgreementPage(title: '用户协议', url: 'https://example.com/agreement')
///
/// // 自定义 JS 通道
/// AgreementPage(
///   title: 'H5页面',
///   url: 'https://example.com/h5',
///   jsChannelName: 'AppBridge',
///   onJsMessage: (message) {
///     // 处理来自 WebView 的 JS 消息
///     print('收到JS消息: $message');
///   },
/// )
/// ```
class AgreementPage extends StatefulWidget {
  /// 页面标题（初始标题，加载网页后会被网页标题覆盖）
  final String title;

  /// 网页地址
  final String url;

  /// JS 通道名称（WebView 中 JS 通过此名称与 Flutter 通信）
  /// 默认值：`AppBridge`
  /// JS 端调用方式：`AppBridge.postMessage(JSON.stringify({type: 'xxx', data: 'xxx'}))`
  final String jsChannelName;

  /// 接收来自 WebView 的 JS 消息回调
  final ValueChanged<String>? onJsMessage;

  /// 是否同步 Cookie（默认 true）
  /// 开启后会在页面加载完成时将 WebView 的 Cookie 同步到 Flutter 端
  final bool syncCookie;

  /// 是否启用标题动态更新（默认 true）
  /// 开启后会在网页加载完成时将 AppBar 标题更新为网页标题
  final bool dynamicTitle;

  const AgreementPage({
    super.key,
    required this.title,
    required this.url,
    this.jsChannelName = 'AppBridge',
    this.onJsMessage,
    this.syncCookie = true,
    this.dynamicTitle = true,
  });

  @override
  State<AgreementPage> createState() => _AgreementPageState();
}

class _AgreementPageState extends State<AgreementPage> {
  late final WebViewController _controller;

  /// 当前页面标题（可动态更新）
  String _title = '';

  /// 加载进度 0.0 ~ 1.0
  double _loadingProgress = 0;

  /// 是否正在加载
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _title = widget.title;

    _controller = WebViewController()
      // 启用 JS 支持
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      // 注册 JS 通道，接收 WebView 中的消息
      ..addJavaScriptChannel(
        widget.jsChannelName,
        onMessageReceived: (JavaScriptMessage message) {
          _handleJsMessage(message.message);
        },
      )
      // 监听加载进度
      ..setNavigationDelegate(
        NavigationDelegate(
          // 页面开始加载
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
              _loadingProgress = 0;
            });
          },
          // 加载进度更新
          onProgress: (int progress) {
            setState(() {
              _loadingProgress = progress / 100.0;
            });
          },
          // 页面加载完成
          onPageFinished: (String url) async {
            setState(() {
              _isLoading = false;
              _loadingProgress = 1.0;
            });

            // 动态更新标题：获取网页标题
            if (widget.dynamicTitle) {
              _updateWebTitle();
            }

            // Cookie 同步
            if (widget.syncCookie) {
              _syncCookies();
            }
          },
          // 处理导航请求（可用于拦截特定 URL）
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      // 加载目标 URL
      ..loadRequest(Uri.parse(widget.url));
  }

  /// 获取网页标题并更新 AppBar
  Future<void> _updateWebTitle() async {
    try {
      final webTitle = await _controller.getTitle();
      if (webTitle != null && webTitle.isNotEmpty && mounted) {
        setState(() {
          _title = webTitle;
        });
      }
    } catch (e) {
      // 获取标题失败时保持原始标题
      debugPrint('获取网页标题失败: $e');
    }
  }

  /// 同步 WebView Cookie
  ///
  /// 将 WebView 中的 Cookie 同步到 Flutter 端，
  /// 确保 WebView 和原生网络请求共享登录态。
  ///
  /// webview_flutter v4.x 的 WebViewCookieManager 不提供 getCookies 方法，
  /// 因此通过执行 JS `document.cookie` 来获取当前页面的 Cookie 字符串。
  Future<void> _syncCookies() async {
    try {
      // 通过 JS 获取 WebView 中的 Cookie 字符串
      final cookieStr = await _controller.runJavaScriptReturningResult(
        'document.cookie',
      );
      final cookieString = cookieStr.toString();

      if (cookieString.isEmpty || cookieString == 'null') {
        debugPrint('WebView Cookie 同步: 无 Cookie');
        return;
      }

      debugPrint('WebView Cookie 同步: $cookieString');

      // 解析 Cookie 字符串
      final cookies = _parseCookieString(cookieString);

      // TODO: 根据项目需求，将 Cookie 同步到 Dio 等网络请求模块
      for (final entry in cookies.entries) {
        debugPrint('Cookie: ${entry.key}=${entry.value}');
      }
    } catch (e) {
      debugPrint('Cookie 同步失败: $e');
    }
  }

  /// 解析 Cookie 字符串为 Map
  ///
  /// 输入格式：`"key1=value1; key2=value2"`
  /// 输出格式：`{key1: value1, key2: value2}`
  Map<String, String> _parseCookieString(String cookieString) {
    final Map<String, String> cookies = {};
    // 去除 JS 返回值的引号
    final cleanStr = cookieString.replaceAll('"', '');
    final pairs = cleanStr.split(';');
    for (final pair in pairs) {
      final trimmed = pair.trim();
      if (trimmed.isEmpty) continue;
      final eqIndex = trimmed.indexOf('=');
      if (eqIndex > 0) {
        final key = trimmed.substring(0, eqIndex).trim();
        final value = trimmed.substring(eqIndex + 1).trim();
        cookies[key] = value;
      }
    }
    return cookies;
  }

  /// 处理来自 WebView 的 JS 消息
  void _handleJsMessage(String message) {
    debugPrint('收到 JS 消息: $message');

    // 回调给外部处理
    widget.onJsMessage?.call(message);

    // 内置通用消息处理（可根据项目需求扩展）
    // 示例消息格式：{"type": "close", "data": ""}
    // 示例消息格式：{"type": "toast", "data": "操作成功"}
  }

  /// Flutter 端调用 WebView 中的 JS 函数
  ///
  /// [jsCode] 要执行的 JS 代码
  /// 示例：`_evaluateJs('document.title')`
  /// 示例：`_evaluateJs('handleFlutterMessage("hello")')`
  Future<String?> evaluateJs(String jsCode) async {
    try {
      final result = await _controller.runJavaScriptReturningResult(jsCode);
      return result.toString();
    } catch (e) {
      debugPrint('JS 执行失败: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: AppText(_title),
      padding: EdgeInsets.zero,
      body: Stack(
        children: [
          // WebView 主体
          WebViewWidget(controller: _controller),

          // 顶部加载进度条
          if (_isLoading)
            Positioned(top: 0, left: 0, right: 0, child: _buildProgressBar()),
        ],
      ),
    );
  }

  /// 构建线性进度条
  Widget _buildProgressBar() {
    return LinearProgressIndicator(
      value: _loadingProgress,
      minHeight: 3.h,
      backgroundColor: Colors.transparent,
      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary(context)),
    );
  }
}
