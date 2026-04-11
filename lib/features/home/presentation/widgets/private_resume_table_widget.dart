import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:odk_flutter_template/core/storage/secure_storage_manager.dart';
import 'package:odk_flutter_template/core/storage/storage_key.dart';
import 'package:odk_flutter_template/core/utils/log_utils.dart';
import 'package:odk_flutter_template/features/home/data/models/private_resume.dart';
import 'package:odk_flutter_template/features/home/data/models/private_resume_status.dart';
import 'package:odk_flutter_template/features/home/domain/home_resume_service.dart';
import 'package:odk_flutter_template/gen/assets.gen.dart';
import 'package:odk_flutter_template/models/entities/user_entity.dart';
import 'package:odk_flutter_template/widgets/futurebuilder/common_future_builder.dart';

class PrivateResumeData {
  final List<PrivateResumeInfo> resumeList;
  final UserEntity user;

  PrivateResumeData({required this.resumeList, required this.user});
}

class PrivateResumeTableWidget extends StatefulWidget {
  const PrivateResumeTableWidget({super.key});

  @override
  State<PrivateResumeTableWidget> createState() =>
      _PrivateResumeTableWidgetState();
}

class _PrivateResumeTableWidgetState extends State<PrivateResumeTableWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// 🔥 核心：合并两个异步请求（简历列表 + 用户信息）
  Future<PrivateResumeData> _fetchAllData() async {
    try {
      // 同时发起两个请求，并发执行
      final results = await Future.wait([
        HomeResumeService().getPrivateResumeInfo(),
        _loadUserData(),
      ]);

      return PrivateResumeData(
        resumeList: results[0] as List<PrivateResumeInfo>,
        user: results[1] as UserEntity,
      );
    } catch (e) {
      Log.e('加载数据失败: $e');
      rethrow;
    }
  }

  /// 加载用户信息（安全判空，修复强制!解包）
  Future<UserEntity?> _loadUserData() async {
    try {
      final String? userInfo = await SecureStorageManager().read(
        StorageKey.userInfo,
      );
      if (userInfo == null || userInfo.isEmpty) return null;
      return UserEntity.fromJson(jsonDecode(userInfo));
    } catch (e) {
      Log.e('读取用户信息失败: $e');
      return null;
    }
  }

  /// 下拉刷新：极简实现（触发重建=重新请求数据）
  Future<void> _onRefresh() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: Colors.blue,
      // 🔥 使用通用组件，自动管理所有状态
      child: CommonFutureBuilder<PrivateResumeData>(
        future: _fetchAllData(),
        onSuccess: (data) => _buildContent(data),
      ),
    );
  }

  /// 数据加载成功后渲染列表
  Widget _buildContent(PrivateResumeData data) {
    // 空数据提示
    if (data.resumeList.isEmpty) {
      return const Center(child: Text("暂无隐私简历数据"));
    }

    return ListView.builder(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(), // 保证下拉刷新可用
      itemCount: data.resumeList.length,
      itemBuilder: (context, index) {
        final item = data.resumeList[index];
        return PrivateResumeTableRowWidget(
          user: data.user,
          privateResumeInfo: item,
        );
      },
    );
  }
}

// ====================== 子组件（无修改，仅保留） ======================
class PrivateResumeTableRowWidget extends StatelessWidget {
  const PrivateResumeTableRowWidget({
    super.key,
    required this.user,
    required this.privateResumeInfo,
  });

  final UserEntity? user;
  final PrivateResumeInfo privateResumeInfo;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: CircleAvatar(
        radius: 28,
        backgroundImage: AssetImage(
          privateResumeInfo.resumeLibraryDTO?.gender == "1"
              ? Assets.profile.admin.path
              : Assets.profile.employee.path,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      selectedTileColor: Colors.blue[50],
      title: Text(
        privateResumeInfo.resumeLibraryDTO?.name ?? '',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Row(
        children: [
          Text(
            privateResumeInfo.resumeLibraryDTO?.mobile ?? '',
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(width: 8),
          user?.isAdmin == true
              ? Text(
                  "员工：${privateResumeInfo.userName ?? ''}",
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                )
              : const SizedBox(),
        ],
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 225, 223, 223),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          PrivateResumeStatus.privateResumeStatusMap[privateResumeInfo
                  .status] ??
              '',
          style: TextStyle(
            fontSize: 12,
            color:
                PrivateResumeStatus.privateResumeStatusMap[privateResumeInfo
                        .status] ==
                    '有意向'
                ? const Color.fromARGB(255, 255, 89, 0)
                : Colors.grey,
          ),
        ),
      ),
      onTap: () => _showUserDetailDialog(context, privateResumeInfo),
    );
  }

  // 显示详情弹窗
  void _showUserDetailDialog(BuildContext context, PrivateResumeInfo user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.account_circle, color: Colors.blue, size: 30),
              const SizedBox(width: 10),
              Text(user.resumeLibraryDTO?.name ?? ''),
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                _buildDetailRow(
                  Icons.phone,
                  "手机号",
                  user.resumeLibraryDTO?.mobile ?? '',
                ),
                _buildDetailRow(
                  Icons.person,
                  "性别",
                  user.resumeLibraryDTO?.gender == "1" ? "男" : "女",
                ),
                _buildDetailRow(
                  Icons.calendar_today,
                  "年龄",
                  user.resumeLibraryDTO?.age ?? '',
                ),
                _buildDetailRow(
                  Icons.perm_identity_outlined,
                  "身份证号",
                  user.resumeLibraryDTO?.idNo ?? '',
                ),
                _buildDetailRow(
                  Icons.location_on,
                  "工作地",
                  user.resumeLibraryDTO?.workAddr ?? '',
                ),
                _buildDetailRow(
                  Icons.location_on,
                  "户籍所在地",
                  user.resumeLibraryDTO?.domicile ?? '',
                ),
                _buildDetailRow(
                  Icons.extension,
                  "扩展信息",
                  user.resumeLibraryDTO?.extendInfo ?? '',
                ),
                const Divider(),
                Text(
                  "状态: ${PrivateResumeStatus.privateResumeStatusMap[user.status] ?? ''}",
                  style: const TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 详情行组件
  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 10),
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
