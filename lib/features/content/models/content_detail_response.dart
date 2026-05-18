/// 内容详情响应模型（模拟详情接口返回数据）
///
/// 相比列表页的 [ContentItem]，详情页包含更丰富的内容：
/// 正文、标签、评论数、收藏数等。
class ContentDetailResponse {
  /// 唯一标识
  final String id;

  /// 标题
  final String title;

  /// 作者名字
  final String authorName;

  /// 作者头像颜色
  final int avatarColor;

  /// 点赞数量
  final int likeCount;

  /// 收藏数量
  final int collectCount;

  /// 评论数量
  final int commentCount;

  /// 图片占位颜色
  final int imageColor;

  /// 正文内容
  final String content;

  /// 标签列表
  final List<String> tags;

  /// 发布时间
  final String publishTime;

  const ContentDetailResponse({
    required this.id,
    required this.title,
    required this.authorName,
    required this.avatarColor,
    required this.likeCount,
    required this.collectCount,
    required this.commentCount,
    required this.imageColor,
    required this.content,
    required this.tags,
    required this.publishTime,
  });

  factory ContentDetailResponse.fromJson(Map<String, dynamic> json) {
    return ContentDetailResponse(
      id: json['id'] as String,
      title: json['title'] as String,
      authorName: json['authorName'] as String,
      avatarColor: json['avatarColor'] as int,
      likeCount: json['likeCount'] as int,
      collectCount: json['collectCount'] as int,
      commentCount: json['commentCount'] as int,
      imageColor: json['imageColor'] as int,
      content: json['content'] as String,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      publishTime: json['publishTime'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'authorName': authorName,
      'avatarColor': avatarColor,
      'likeCount': likeCount,
      'collectCount': collectCount,
      'commentCount': commentCount,
      'imageColor': imageColor,
      'content': content,
      'tags': tags,
      'publishTime': publishTime,
    };
  }
}
