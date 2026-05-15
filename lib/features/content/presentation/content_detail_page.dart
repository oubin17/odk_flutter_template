import 'package:flutter/material.dart';
import 'package:odk_flutter_template/features/content/models/content_item.dart';
import 'package:odk_flutter_template/widgets/app_page/app_bar.dart';
import 'package:odk_flutter_template/widgets/app_widgets/app_widgets.dart';

/// 内容详情页（空白占位，验证跳转即可）
class ContentDetailPage extends StatelessWidget {
  final ContentItem item;

  const ContentDetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(title: AppText(item.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppText.body(item.title),
            AppGap.hNormal,
            AppText.second('作者: ${item.authorName}'),
            AppGap.hSmall,
            AppText.tip('点赞: ${item.likeCount}'),
          ],
        ),
      ),
    );
  }
}
