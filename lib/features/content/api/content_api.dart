import 'dart:math';
import 'package:odk_flutter_template/features/content/models/content_detail_response.dart';
import 'package:odk_flutter_template/features/content/models/content_item.dart';
import 'package:odk_flutter_template/models/request/page_request.dart';
import 'package:odk_flutter_template/models/response/page_response.dart';

/// 内容相关 API（Mock 实现）
///
/// 目前所有接口均为本地 Mock，后续对接真实接口时只需替换实现即可。
class ContentApi {
  // 单例实例
  static final ContentApi _instance = ContentApi._internal();

  ContentApi._internal();
  factory ContentApi() => _instance;

  /// 模拟数据 ID 计数器
  int _idCounter = 0;

  /// 预设标题
  static const List<String> _titles = [
    '今日穿搭分享｜秋冬必备的奶茶色大衣',
    '厨房小白也能搞定的懒人食谱',
    '周末探店｜藏在巷子里的宝藏咖啡厅',
    '旅行攻略｜三天两夜玩转大理',
    '居家好物推荐｜提升幸福感的小物件',
    '健身打卡第30天｜分享我的减脂餐',
    '读书笔记｜这本小说让我熬夜看完',
    '手账排版灵感｜极简风月计划',
    '护肤心得｜干皮秋冬保湿攻略',
    '摄影技巧｜手机也能拍出大片感',
    '宠物日常｜我家猫又拆家了',
    '职场分享｜新人如何快速融入团队',
  ];

  /// 预设作者名
  static const List<String> _authors = [
    '小橘子',
    '奶茶控',
    '旅行者Amy',
    '厨神小白',
    '读书人',
    '健身达人',
    '手账少女',
    '护肤博主',
    '摄影师老王',
    '铲屎官',
    '职场新人',
    '居家达人',
  ];

  /// 预设颜色
  static const List<int> _colors = [
    0xFFE8F0FF,
    0xFFFFE8E8,
    0xFFE8FFE8,
    0xFFFFF5E8,
    0xFFF0E8FF,
    0xFFE8FFFF,
    0xFFFFE8F5,
    0xFFE8E8FF,
    0xFFFFF0E8,
    0xFFE8F5E8,
  ];

  /// 预设正文内容
  static const List<String> _contents = [
    '今天给大家分享一个超实用的好物！用了之后真的幸福感满满，强烈推荐给大家～\n\n首先说说使用感受，真的非常方便，操作简单，效果也很明显。我已经用了一段时间了，感觉生活质量都提升了呢！\n\n如果你也有类似的需求，真的可以试试看，绝对不会后悔的！',
    '周末终于有时间好好整理一下了，分享一下我的心得体会～\n\n第一步：先做好规划，列出清单\n第二步：按优先级排序\n第三步：逐一执行\n\n整个过程下来感觉效率提升了不少，大家也可以试试这个方法！',
    '最近发现了一个宝藏地方，必须安利给大家！\n\n环境超级好，氛围感满满，拍照也特别出片。最重要的是性价比很高，完全不会踩雷。\n\n推荐指数：⭐⭐⭐⭐⭐\n下次还会再来的！',
  ];

  /// 预设标签
  static const List<List<String>> _tagGroups = [
    ['穿搭', '秋冬', '大衣'],
    ['美食', '懒人食谱', '厨房小白'],
    ['探店', '咖啡厅', '周末'],
    ['旅行', '大理', '攻略'],
    ['好物推荐', '居家', '幸福感'],
    ['健身', '减脂餐', '打卡'],
    ['读书', '小说', '推荐'],
    ['手账', '排版', '极简风'],
    ['护肤', '保湿', '干皮'],
    ['摄影', '手机摄影', '技巧'],
    ['宠物', '猫咪', '日常'],
    ['职场', '新人', '成长'],
  ];

  /// 预设发布时间
  static const List<String> _publishTimes = [
    '2小时前',
    '5小时前',
    '1天前',
    '2天前',
    '3天前',
    '1周前',
  ];

  /// 图片占位高度范围
  static const double _minImageHeight = 120;
  static const double _maxImageHeight = 240;

  /// 获取内容列表（分页 Mock）
  ///
  /// 入参 [pageRequest] 包含 page、size 等分页参数，
  /// 出参为 [PageResponse<ContentItem>]，包含总数和分页列表。
  Future<PageResponse<ContentItem>> getContentList(
    PageRequest pageRequest,
  ) async {
    // 模拟网络延迟
    await Future.delayed(const Duration(milliseconds: 800));

    final random = Random();
    final int page = pageRequest.page;
    final int size = pageRequest.size;

    // 第5页后模拟没有更多数据
    if (page > 5) {
      final pageResponse = PageResponse<ContentItem>();
      pageResponse.count = 50;
      pageResponse.pageList = [];
      return pageResponse;
    }

    // 刷新时重置 ID 计数器
    if (page == 1) {
      _idCounter = 0;
    }

    final List<ContentItem> items = [];
    for (int i = 0; i < size; i++) {
      _idCounter++;
      items.add(
        ContentItem(
          id: '$_idCounter',
          title: _titles[random.nextInt(_titles.length)],
          authorName: _authors[random.nextInt(_authors.length)],
          avatarColor: _colors[random.nextInt(_colors.length)],
          likeCount: random.nextInt(9999),
          imageHeight:
              _minImageHeight +
              random
                  .nextInt((_maxImageHeight - _minImageHeight).toInt())
                  .toDouble(),
          imageColor: _colors[random.nextInt(_colors.length)],
        ),
      );
    }

    final pageResponse = PageResponse<ContentItem>();
    pageResponse.count = 50; // 模拟总数
    pageResponse.pageList = items;
    return pageResponse;
  }

  /// 获取内容详情（Mock）
  ///
  /// 根据 [id] 模拟返回详情数据，包含正文、标签、评论数等。
  Future<ContentDetailResponse> getContentDetail(String id) async {
    // 模拟网络延迟
    await Future.delayed(const Duration(milliseconds: 600));

    final random = Random(id.hashCode);
    final titleIndex = random.nextInt(_titles.length);
    final contentIndex = random.nextInt(_contents.length);

    return ContentDetailResponse(
      id: id,
      title: _titles[titleIndex],
      authorName: _authors[titleIndex],
      avatarColor: _colors[random.nextInt(_colors.length)],
      likeCount: random.nextInt(9999),
      collectCount: random.nextInt(5000),
      commentCount: random.nextInt(3000),
      imageColor: _colors[random.nextInt(_colors.length)],
      content: _contents[contentIndex],
      tags: _tagGroups[titleIndex],
      publishTime: _publishTimes[random.nextInt(_publishTimes.length)],
    );
  }
}
