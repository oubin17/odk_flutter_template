import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odk_flutter_template/features/content/models/content_item.dart';
import 'package:odk_flutter_template/features/content/presentation/content_detail_page.dart';
import 'package:odk_flutter_template/widgets/app_page/app_bar.dart';
import 'package:odk_flutter_template/widgets/app_refresh/app_refresh_list.dart';
import 'package:odk_flutter_template/widgets/app_widgets/app_widgets.dart';

/// 小红书风格内容首页
///
/// 使用 [AppRefreshList] 实现下拉刷新 + 上拉加载，
/// 使用 [MasonryGridView] 实现瀑布流布局。
class ContentPage extends StatefulWidget {
  const ContentPage({super.key});

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  /// 刷新控制器
  final _refreshController = AppRefreshListController();

  /// 模拟数据 ID 计数器
  int _idCounter = 0;

  // ===================== 模拟数据 =====================

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

  /// 预设颜色（用于图片/头像占位）
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

  /// 图片占位高度范围
  static const double _minImageHeight = 120;
  static const double _maxImageHeight = 240;

  /// 生成模拟数据
  List<ContentItem> _generateMockData(int page) {
    final random = Random();
    final List<ContentItem> items = [];

    for (int i = 0; i < 10; i++) {
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

    return items;
  }

  /// 模拟网络请求：下拉刷新
  Future<List<ContentItem>> _onRefresh(int page) async {
    // 模拟网络延迟
    await Future.delayed(const Duration(milliseconds: 800));
    // 刷新时重置 ID 计数器，模拟全新数据
    _idCounter = (page - 1) * 10;
    return _generateMockData(page);
  }

  /// 模拟网络请求：上拉加载
  Future<List<ContentItem>> _onLoadMore(int page) async {
    // 模拟网络延迟
    await Future.delayed(const Duration(milliseconds: 1000));
    // 第5页后模拟没有更多数据
    if (page > 5) {
      return [];
    }
    return _generateMockData(page);
  }

  // ===================== 构建UI =====================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BasicAppBar(title: AppText('发现')),
      body: AppRefreshList<ContentItem>(
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoadMore: _onLoadMore,
        pageSize: 10,
        separatorBuilder: (_, _) => const SizedBox.shrink(),
        itemBuilder: (context, item, index) {
          return _ContentCard(
            item: item,
            onTap: () => _navigateToDetail(context, item),
          );
        },
      ),
    );
  }

  /// 跳转详情页
  void _navigateToDetail(BuildContext context, ContentItem item) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => ContentDetailPage(item: item)));
  }
}

/// 内容卡片组件（小红书风格）
class _ContentCard extends StatelessWidget {
  final ContentItem item;
  final VoidCallback onTap;

  const _ContentCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: AppColors.card(context),
          borderRadius: BorderRadius.circular(16.w),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(15),
              blurRadius: 8.w,
              offset: Offset(0, 2.w),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 图片占位区域
            _buildImagePlaceholder(context),
            // 内容区域
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 标题
                  AppText(item.title, size: 26.sp, maxLines: 2),
                  AppGap.hSmall,
                  // 作者信息 + 点赞
                  Row(
                    children: [
                      // 作者头像占位
                      _buildAvatarPlaceholder(context),
                      AppGap.wSmall,
                      // 作者名
                      Expanded(
                        child: Text(
                          item.authorName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 24.sp,
                            color: AppColors.textGray(context),
                          ),
                        ),
                      ),
                      // 点赞图标 + 数量
                      Icon(
                        Icons.favorite_outline,
                        size: 24.w,
                        color: AppColors.textGray(context),
                      ),
                      AppGap.wSuperSmall,
                      Text(
                        _formatLikeCount(item.likeCount),
                        style: TextStyle(
                          fontSize: 24.sp,
                          color: AppColors.textGray(context),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建图片占位区域
  Widget _buildImagePlaceholder(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.w)),
      child: Container(
        width: double.infinity,
        height: item.imageHeight.h,
        color: Color(item.imageColor),
        child: Center(
          child: Icon(
            Icons.image_outlined,
            size: 48.w,
            color: AppColors.textGray(context).withAlpha(100),
          ),
        ),
      ),
    );
  }

  /// 构建作者头像占位
  Widget _buildAvatarPlaceholder(BuildContext context) {
    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        color: Color(item.avatarColor),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          Icons.person,
          size: 20.w,
          color: AppColors.primary(context),
        ),
      ),
    );
  }

  /// 格式化点赞数量
  String _formatLikeCount(int count) {
    if (count >= 10000) {
      return '${(count / 10000).toStringAsFixed(1)}w';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return count.toString();
  }
}
