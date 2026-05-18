import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:odk_flutter_template/core/utils/l10n_utils.dart';
import 'package:odk_flutter_template/widgets/app_status/app_status_page.dart';
import 'package:odk_flutter_template/widgets/app_widgets/app_widgets.dart';
import 'package:odk_flutter_template/widgets/mixins/mounted_safe_mixin.dart';

/// 加载更多状态枚举
enum LoadMoreStatus {
  /// 空闲（可继续加载）
  idle,

  /// 加载中
  loading,

  /// 没有更多数据
  noMore,

  /// 加载失败（点击可重试）
  failed,
}

/// 列表布局模式
enum AppRefreshListMode {
  /// 单列列表（默认，一行一个内容）
  list,

  /// 双列瀑布流（小红书风格，两列交错布局）
  masonryGrid,
}

/// 通用下拉刷新 + 上拉加载列表组件
///
/// 列表页标配组件，封装分页加载逻辑，统一空数据、加载中、加载失败等状态。
/// 调用方只需提供数据获取回调 [onRefresh] / [onLoadMore] 和列表项构建器 [itemBuilder]，
/// 即可获得完整的下拉刷新 + 上拉加载体验。
///
/// **核心特性：**
/// - 下拉刷新：自动重置分页，清空旧数据
/// - 上拉加载：自动追加新数据，支持加载失败重试
/// - 空数据状态：首次加载无数据时显示空状态页
/// - 首次加载状态：数据为空且正在加载时显示 loading
/// - 安全 setState：内置 [MountedSafeMixin]，异步操作后自动检查 mounted
/// - 国际化：所有提示文案通过 L10nUtils 自动适配
/// - 双列瀑布流：通过 [mode] 切换布局风格
///
/// **使用示例：**
///
/// ```dart
/// // 基础用法（单列列表）
/// AppRefreshList<String>(
///   onRefresh: (page) => api.fetchList(page),
///   itemBuilder: (context, item, index) => ListTile(title: Text(item)),
/// )
///
/// // 双列瀑布流（小红书风格）
/// AppRefreshList<String>(
///   mode: AppRefreshListMode.masonryGrid,
///   crossAxisCount: 2,
///   onRefresh: (page) => api.fetchList(page),
///   itemBuilder: (context, item, index) => Card(child: Text(item)),
/// )
///
/// // 自定义每页数量 + 空数据文案
/// AppRefreshList<Order>(
///   pageSize: 20,
///   onRefresh: (page) => api.fetchOrders(page),
///   emptyText: '暂无订单',
///   itemBuilder: (context, order, index) => OrderCard(order: order),
/// )
///
/// // 通过 controller 外部触发刷新
/// final controller = AppRefreshListController();
/// AppRefreshList<String>(
///   controller: controller,
///   onRefresh: (page) => api.fetchList(page),
///   itemBuilder: (context, item, index) => ListTile(title: Text(item)),
/// )
/// // 外部触发刷新
/// controller.refresh();
/// ```
class AppRefreshList<T> extends StatefulWidget {
  /// ===================== 数据回调 =====================

  /// 下拉刷新回调（返回当前页码，通常为 1）
  /// 返回值：当前页的数据列表
  final Future<List<T>> Function(int page) onRefresh;

  /// 上拉加载更多回调（返回当前页码）
  /// 返回值：当前页的数据列表
  /// 不设置时默认使用 [onRefresh]
  final Future<List<T>> Function(int page)? onLoadMore;

  /// ===================== 列表构建 =====================

  /// 列表项构建器
  final Widget Function(BuildContext context, T item, int index) itemBuilder;

  /// 分隔线构建器（仅 [AppRefreshListMode.list] 模式生效）
  /// 不设置时使用默认 1px 分割线
  final Widget Function(BuildContext context, int index)? separatorBuilder;

  /// ===================== 分页配置 =====================

  /// 每页数据量（用于判断是否还有更多数据）
  final int pageSize;

  /// ===================== 空状态配置 =====================

  /// 空数据提示文案
  final String? emptyText;

  /// 自定义空数据组件（优先级高于 [emptyText]）
  final Widget? emptyWidget;

  /// ===================== 控制器 =====================

  /// 外部控制器（用于手动触发刷新等操作）
  final AppRefreshListController? controller;

  /// ===================== 样式配置 =====================

  /// 列表布局模式（默认单列列表）
  final AppRefreshListMode mode;

  /// 瀑布流列数（仅 [AppRefreshListMode.masonryGrid] 模式生效，默认 2）
  final int crossAxisCount;

  /// 瀑布流主轴间距（仅 [AppRefreshListMode.masonryGrid] 模式生效）
  final double mainAxisSpacing;

  /// 瀑布流交叉轴间距（仅 [AppRefreshListMode.masonryGrid] 模式生效）
  final double crossAxisSpacing;

  /// 列表内边距
  final EdgeInsetsGeometry? padding;

  /// 是否反向列表
  final bool reverse;

  /// 滚动控制器
  final ScrollController? scrollController;

  /// 列表滚动方向
  final Axis scrollDirection;

  /// 是否启用下拉刷新（默认 true）
  final bool enableRefresh;

  /// 是否启用上拉加载（默认 true）
  final bool enableLoadMore;

  /// 自定义加载更多指示器
  final Widget Function(LoadMoreStatus status)? loadMoreBuilder;

  /// 触发上拉加载的提前量（距离底部多少像素时触发，默认 300）
  final double loadMoreTriggerDistance;

  const AppRefreshList({
    super.key,
    required this.onRefresh,
    this.onLoadMore,
    required this.itemBuilder,
    this.separatorBuilder,
    this.pageSize = 10,
    this.emptyText,
    this.emptyWidget,
    this.controller,
    this.mode = AppRefreshListMode.list,
    this.crossAxisCount = 2,
    this.mainAxisSpacing = 8.0,
    this.crossAxisSpacing = 8.0,
    this.padding,
    this.reverse = false,
    this.scrollController,
    this.scrollDirection = Axis.vertical,
    this.enableRefresh = true,
    this.enableLoadMore = true,
    this.loadMoreBuilder,
    this.loadMoreTriggerDistance = 300,
  });

  @override
  State<AppRefreshList<T>> createState() => _AppRefreshListState<T>();
}

class _AppRefreshListState<T> extends State<AppRefreshList<T>>
    with MountedSafeMixin {
  /// ===================== 数据状态 =====================

  /// 列表数据
  final List<T> _dataList = [];

  /// 当前页码
  int _currentPage = 1;

  /// 加载更多状态
  LoadMoreStatus _loadMoreStatus = LoadMoreStatus.idle;

  /// 是否正在首次加载（数据为空时的加载状态）
  bool _isFirstLoading = true;

  /// 是否正在下拉刷新中
  bool _isRefreshing = false;

  /// 首次加载是否出错
  bool _isFirstError = false;

  /// ===================== RefreshIndicator Key =====================
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    // 绑定控制器
    widget.controller?._bindState(this);
    // 首次加载数据
    _loadData(isRefresh: true);
  }

  @override
  void dispose() {
    widget.controller?._unbindState();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AppRefreshList<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 控制器变更时重新绑定
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?._unbindState();
      widget.controller?._bindState(this);
    }
  }

  /// ===================== 数据加载 =====================

  /// 加载数据
  Future<void> _loadData({required bool isRefresh}) async {
    if (isRefresh) {
      // 下拉刷新：重置页码
      _currentPage = 1;
      _isRefreshing = true;
      _loadMoreStatus = LoadMoreStatus.idle;
    } else {
      // 上拉加载：页码 +1
      _currentPage++;
      _loadMoreStatus = LoadMoreStatus.loading;
    }

    mountedSafeSetState(() {});

    try {
      final callback = isRefresh
          ? widget.onRefresh
          : (widget.onLoadMore ?? widget.onRefresh);
      final List<T> result = await callback(_currentPage);

      if (!mounted) return;

      if (isRefresh) {
        // 刷新成功：替换数据
        _dataList
          ..clear()
          ..addAll(result);
        _isFirstLoading = false;
        _isFirstError = false;
        _isRefreshing = false;

        // 判断是否还有更多数据
        if (result.length < widget.pageSize) {
          _loadMoreStatus = LoadMoreStatus.noMore;
        } else {
          _loadMoreStatus = LoadMoreStatus.idle;
        }
      } else {
        // 加载更多成功：追加数据
        _dataList.addAll(result);

        // 判断是否还有更多数据
        if (result.length < widget.pageSize) {
          _loadMoreStatus = LoadMoreStatus.noMore;
        } else {
          _loadMoreStatus = LoadMoreStatus.idle;
        }
      }
    } catch (e) {
      if (!mounted) return;

      if (isRefresh) {
        // 刷新失败
        _isFirstLoading = false;
        _isRefreshing = false;
        if (_dataList.isEmpty) {
          // 首次加载失败，显示错误状态
          _isFirstError = true;
        }
      } else {
        // 加载更多失败
        _currentPage--; // 回退页码
        _loadMoreStatus = LoadMoreStatus.failed;
      }
    }

    mountedSafeSetState(() {});
  }

  /// 下拉刷新
  Future<void> _onRefresh() async {
    await _loadData(isRefresh: true);
  }

  /// 上拉加载更多
  Future<void> _onLoadMore() async {
    if (_loadMoreStatus == LoadMoreStatus.loading ||
        _loadMoreStatus == LoadMoreStatus.noMore) {
      return;
    }
    await _loadData(isRefresh: false);
  }

  /// 外部触发刷新
  void _externalRefresh() {
    _refreshIndicatorKey.currentState?.show();
  }

  /// ===================== 构建UI =====================

  @override
  Widget build(BuildContext context) {
    // 1. 首次加载中
    if (_isFirstLoading && _dataList.isEmpty && !_isFirstError) {
      return const AppStatusPage.loading();
    }

    // 2. 首次加载失败
    if (_isFirstError && _dataList.isEmpty) {
      return AppStatusPage.unknownError(
        onAction: () {
          mountedSafeSetState(() {
            _isFirstLoading = true;
            _isFirstError = false;
          });
          _loadData(isRefresh: true);
        },
      );
    }

    // 3. 空数据
    if (_dataList.isEmpty && !_isFirstLoading) {
      return widget.emptyWidget ??
          AppStatusPage.empty(subtitle: widget.emptyText);
    }

    // 4. 有数据：构建列表
    Widget listWidget = _buildListByMode();

    // 5. 包裹下拉刷新
    if (widget.enableRefresh) {
      listWidget = RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _onRefresh,
        color: AppColors.primary(context),
        child: listWidget,
      );
    }

    return listWidget;
  }

  /// 根据布局模式构建列表
  Widget _buildListByMode() {
    switch (widget.mode) {
      case AppRefreshListMode.list:
        return _buildListView();
      case AppRefreshListMode.masonryGrid:
        return _buildMasonryGridView();
    }
  }

  /// 构建单列列表视图
  Widget _buildListView() {
    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: ListView.separated(
        controller: widget.scrollController,
        padding: widget.padding,
        reverse: widget.reverse,
        scrollDirection: widget.scrollDirection,
        itemCount: _dataList.length + 1, // +1 为底部加载指示器
        separatorBuilder: (context, index) {
          // 最后一项（加载指示器）不需要分隔线
          if (index >= _dataList.length - 1) {
            return const SizedBox.shrink();
          }
          return widget.separatorBuilder?.call(context, index) ??
              _defaultSeparator(context);
        },
        itemBuilder: (context, index) {
          // 最后一项：加载更多指示器
          if (index >= _dataList.length) {
            return _buildLoadMoreIndicator();
          }
          return widget.itemBuilder(context, _dataList[index], index);
        },
      ),
    );
  }

  /// 构建双列瀑布流视图
  Widget _buildMasonryGridView() {
    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: MasonryGridView.count(
        controller: widget.scrollController,
        padding: widget.padding,
        reverse: widget.reverse,
        scrollDirection: widget.scrollDirection,
        crossAxisCount: widget.crossAxisCount,
        mainAxisSpacing: widget.mainAxisSpacing,
        crossAxisSpacing: widget.crossAxisSpacing,
        itemCount: _dataList.length + 1, // +1 为底部加载指示器
        itemBuilder: (context, index) {
          // 最后一项：加载更多指示器（跨列显示）
          if (index >= _dataList.length) {
            return _buildLoadMoreIndicator();
          }
          return widget.itemBuilder(context, _dataList[index], index);
        },
      ),
    );
  }

  /// 默认分隔线
  Widget _defaultSeparator(BuildContext context) {
    return Divider(
      height: 1.h,
      thickness: 1.h,
      color: AppColors.divider(context),
    );
  }

  /// 处理滚动通知（触发上拉加载）
  bool _handleScrollNotification(ScrollNotification notification) {
    if (!widget.enableLoadMore) return false;

    // 只有滚动到接近底部时才触发加载
    if (notification is ScrollUpdateNotification) {
      final metrics = notification.metrics;
      // 距离底部不足 loadMoreTriggerDistance 像素时触发
      if (metrics.maxScrollExtent - metrics.pixels <
              widget.loadMoreTriggerDistance &&
          _loadMoreStatus != LoadMoreStatus.loading &&
          _loadMoreStatus != LoadMoreStatus.noMore &&
          !_isRefreshing) {
        _onLoadMore();
      }
    }
    return false;
  }

  /// 构建加载更多指示器
  Widget _buildLoadMoreIndicator() {
    // 自定义构建器优先
    if (widget.loadMoreBuilder != null) {
      return widget.loadMoreBuilder!(_loadMoreStatus);
    }

    switch (_loadMoreStatus) {
      case LoadMoreStatus.idle:
        return _buildLoadMoreItem(
          text: L10nUtils.pullToLoadMore,
          showIndicator: false,
        );
      case LoadMoreStatus.loading:
        return _buildLoadMoreItem(
          text: L10nUtils.loadingMore,
          showIndicator: true,
        );
      case LoadMoreStatus.noMore:
        return _buildLoadMoreItem(
          text: L10nUtils.noMoreData,
          showIndicator: false,
        );
      case LoadMoreStatus.failed:
        return _buildLoadMoreItem(
          text: L10nUtils.loadFailed,
          showIndicator: false,
          onTap: _onLoadMore,
        );
    }
  }

  /// 构建加载更多单项
  Widget _buildLoadMoreItem({
    required String text,
    required bool showIndicator,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 100.h,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showIndicator)
              Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: SizedBox(
                  width: 32.w,
                  height: 32.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.w,
                    color: AppColors.textGray(context),
                  ),
                ),
              ),
            AppText.tip(text, color: AppColors.textGray(context)),
          ],
        ),
      ),
    );
  }
}

/// AppRefreshList 外部控制器
///
/// 用于在外部手动触发刷新等操作。
///
/// **使用示例：**
///
/// ```dart
/// final _controller = AppRefreshListController();
///
/// AppRefreshList<String>(
///   controller: _controller,
///   onRefresh: (page) => api.fetchList(page),
///   itemBuilder: (context, item, index) => ListTile(title: Text(item)),
/// )
///
/// // 外部触发刷新
/// _controller.refresh();
/// ```
class AppRefreshListController {
  _AppRefreshListState? _state;

  void _bindState(_AppRefreshListState state) {
    _state = state;
  }

  void _unbindState() {
    _state = null;
  }

  /// 触发下拉刷新（显示 RefreshIndicator 动画）
  void refresh() {
    _state?._externalRefresh();
  }
}
