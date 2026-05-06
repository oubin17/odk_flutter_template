import 'package:flutter/material.dart';
import 'package:odk_flutter_template/widgets/appbar/app_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AgreementPage extends StatefulWidget {
  final String title;
  final String url;

  const AgreementPage({super.key, required this.title, required this.url});

  @override
  State<AgreementPage> createState() => _AgreementPageState();
}

class _AgreementPageState extends State<AgreementPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..loadRequest(Uri.parse(widget.url))
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 直接用，自动显示返回按钮！
      appBar: BasicAppbar(title: Text(widget.title)),
      body: WebViewWidget(controller: _controller),
    );
  }
}
