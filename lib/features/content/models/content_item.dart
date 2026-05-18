/// 内容卡片数据模型（模拟小红书首页卡片）
class ContentItem {
  /// 唯一标识
  final String id;

  /// 标题
  final String title;

  /// 作者名字
  final String authorName;

  /// 作者头像颜色（用颜色占位替代真实头像）
  final int avatarColor;

  /// 点赞数量
  final int likeCount;

  /// 图片占位高度（模拟不同高度的瀑布流图片）
  final double imageHeight;

  /// 图片占位颜色（用颜色占位替代真实图片）
  final int imageColor;

  const ContentItem({
    required this.id,
    required this.title,
    required this.authorName,
    required this.avatarColor,
    required this.likeCount,
    required this.imageHeight,
    required this.imageColor,
  });

  factory ContentItem.fromJson(Map<String, dynamic> json) {
    return ContentItem(
      id: json['id'] as String,
      title: json['title'] as String,
      authorName: json['authorName'] as String,
      avatarColor: json['avatarColor'] as int,
      likeCount: json['likeCount'] as int,
      imageHeight: (json['imageHeight'] as num).toDouble(),
      imageColor: json['imageColor'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'authorName': authorName,
      'avatarColor': avatarColor,
      'likeCount': likeCount,
      'imageHeight': imageHeight,
      'imageColor': imageColor,
    };
  }
}
