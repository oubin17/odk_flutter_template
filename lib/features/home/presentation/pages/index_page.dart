import 'package:flutter/material.dart';
import 'package:odk_flutter_template/features/home/data/models/project_info.dart';
import 'package:odk_flutter_template/features/home/data/models/projectinfo_statistics_response.dart';
import 'package:odk_flutter_template/features/home/domain/home_resume_service.dart';
import 'package:odk_flutter_template/features/home/presentation/widgets/projectinfo_gridview_widget.dart';
import 'package:odk_flutter_template/features/home/presentation/widgets/projectinfo_table_widget.dart';
import 'package:odk_flutter_template/widgets/appbar/app_bar.dart';
import 'package:odk_flutter_template/widgets/futurebuilder/common_future_builder.dart';

class IndexPageData {
  final ProjectInfoStatisticsResponse? statistics;
  final List<ProjectInfo>? projectList;

  IndexPageData({required this.statistics, required this.projectList});
}

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  // 🔥 核心：合并两个异步请求，返回一个Future
  Future<IndexPageData> _fetchAllData() async {
    try {
      // 同时发起两个请求，等待全部完成
      final result = await Future.wait([
        HomeResumeService().getProjectInfoStatistics(),
        HomeResumeService().getProjectInfo(),
      ]);

      return IndexPageData(
        statistics: result[0] as ProjectInfoStatisticsResponse?,
        projectList: result[1] as List<ProjectInfo>?,
      );
    } catch (e) {
      rethrow;
    }
  }

  // 下拉刷新：直接重新请求数据
  Future<void> _onRefresh() async {
    //因为你的 future 是直接调用方法，不是缓存变量 → setState 触发重建 → 自动重新请求数据 → 刷新完成！ 这里不用手动调用_fetchAllData
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(title: const Text('首页')),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: Colors.blue,
        // 🔥 直接使用通用组件，全自动处理状态
        child: CommonFutureBuilder<IndexPageData>(
          future: _fetchAllData(),
          onSuccess: (data) => _buildPageContent(data),
        ),
      ),
    );
  }

  // 页面主内容（数据加载成功后渲染）
  Widget _buildPageContent(IndexPageData data) {
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              '指标列表',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: Divider(height: 1, thickness: 1)),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ProjectInfoGridViewWidget(
              projectInfoStatisticsResponse: data.statistics,
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              '项目列表',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: Divider(height: 1, thickness: 1)),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ProjectInfoTableWidget(projectInfoList: data.projectList),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
      ],
    );
  }
}
