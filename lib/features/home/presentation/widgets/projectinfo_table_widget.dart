import 'package:flutter/material.dart';
import 'package:odk_flutter_template/features/home/data/models/project_info.dart';
import 'package:odk_flutter_template/features/home/data/models/project_urgency_level.dart';

class ProjectInfoTableWidget extends StatefulWidget {
  final List<ProjectInfo>? projectInfoList;
  const ProjectInfoTableWidget({super.key, this.projectInfoList});

  @override
  State<ProjectInfoTableWidget> createState() => _ProjectInfoTableWidgetState();
}

class _ProjectInfoTableWidgetState extends State<ProjectInfoTableWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.projectInfoList?.isEmpty ?? true
          ? const Center(child: Text('暂无项目信息...'))
          : _buildTable(),
    );
  }

  // 3. 构建表格 UI (修改版)
  Widget _buildTable() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        // 使用 ListView 替代 Table，支持无限滚动且性能更好
        child: ListView.builder(
          // 核心：禁用 ListView 自身的滚动，交给外层的 SingleChildScrollView 处理
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true, // 核心：让 ListView 根据内容计算高度
          itemCount: widget.projectInfoList!.length + 1, // 数量 = 数据量 + 1个表头
          itemBuilder: (context, index) {
            // 第一行渲染表头
            if (index == 0) {
              return _buildListRow(["项目名称", "公司", "人数", "紧急"], isHeader: true);
            }
            // 其余行渲染数据 (注意 index - 1 因为第0个是表头)
            final order = widget.projectInfoList![index - 1];
            return _buildListRow([
              order.projectName,
              order.company,
              order.headCount.toString(),
              ProjectUrgencyLevelExtension.fromValue(
                    int.parse(order.urgencyLevel),
                  )?.name ??
                  "",
            ], isHeader: false);
          },
        ),
      ),
    );
  }

  // 4. 构建单行 UI
  Widget _buildListRow(List<String> cells, {required bool isHeader}) {
    return Container(
      decoration: BoxDecoration(
        color: isHeader
            ? Colors.blueGrey[50]
            : (cells.hashCode.isEven ? Colors.grey[50] : Colors.grey[200]),
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!, width: 0.5),
        ),
      ),
      child: Row(
        // 关键修改：让行内组件垂直居中对齐（如果是多行文字，这样比较好看）
        crossAxisAlignment: CrossAxisAlignment.center,
        children: cells.map((text) {
          double flex;
          if (cells.indexOf(text) == 0) {
            flex = 2;
          } else if (cells.indexOf(text) == 1)
            // ignore: curly_braces_in_flow_control_structures
            flex = 1.5;
          else if (cells.indexOf(text) == 2)
            // ignore: curly_braces_in_flow_control_structures
            flex = 0.5;
          else
            // ignore: curly_braces_in_flow_control_structures
            flex = 1;

          return Expanded(
            flex: flex.toInt(),
            child: _buildCellContent(text, isHeader),
          );
        }).toList(),
      ),
    );
  }

  // 5. 提取单元格内容构建逻辑 (修改版)
  Widget _buildCellContent(String text, bool isHeader) {
    // 状态标签样式处理 (保持不变)
    if (text == "level_1") return _buildStatusBadge("紧急", Colors.red);
    if (text == "level_2") return _buildStatusBadge("重要", Colors.orange);
    if (text == "level_3") return _buildStatusBadge("一般", Colors.blue);
    if (text == "level_4") return _buildStatusBadge("不重要", Colors.green);
    if (text == "level_5") return _buildStatusBadge("不紧急", Colors.green);

    // 普通文本样式
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(
        text,
        style: TextStyle(
          color: isHeader ? Colors.blueGrey[800] : Colors.black87,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          // 可选：设置行高，防止换行后文字挤在一起
          height: 1.5,
        ),
        // --- 修改点 ---
      ),
    );
  }

  // 5. 状态胶囊组件
  Widget _buildStatusBadge(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(45),
          border: Border.all(color: color.withOpacity(0.5)),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
