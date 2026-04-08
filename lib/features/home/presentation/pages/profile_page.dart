import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:odk_flutter_template/core/constants/images/app_images.dart';
import 'package:odk_flutter_template/features/auth/domain/auth_service.dart';
import 'package:odk_flutter_template/providers/user/user_provider.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            _buildInfoCard(),
            const SizedBox(height: 16),
            _buildPlaceholderCard("其他", "暂无数据"),
            const SizedBox(height: 16),
            _buildLogoutCard(context),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  /// 个人信息卡片
  Widget _buildInfoCard() {
    // 监听 UserProvider 变化
    return Consumer<UserProvider>(
      builder: (BuildContext context, UserProvider provider, Widget? child) {
        // 👇 关键：从 Provider 中拿最新的用户数据
        final user = provider.userEntity;

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: AssetImage(
                    // 用最新的 user 数据
                    user?.isAdmin == true
                        ? AppImages.adminBg
                        : AppImages.employeeBg,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  user?.userProfile?.userName ?? "未设置姓名",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Text(
                    user?.isAdmin == true ? "管理员" : "员工",
                    style: TextStyle(color: Colors.blue[700], fontSize: 12),
                  ),
                ),
                const Divider(height: 30),
                _buildInfoRow(
                  Icons.badge,
                  "工号",
                  user?.accessToken.tokenValue ?? "",
                ),
                const SizedBox(height: 12),
                _buildInfoRow(
                  Icons.check_circle_outline,
                  "状态",
                  user?.userStatus == "0" ? "正常" : "异常",
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 信息行组件
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Text(label, style: TextStyle(color: Colors.grey[600])),
        const Spacer(),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }

  /// 占位卡片
  Widget _buildPlaceholderCard(String title, String subtitle) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: const Icon(Icons.layers),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }

  /// 退出登录卡片
  Widget _buildLogoutCard(BuildContext context) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: const Icon(Icons.logout, color: Colors.red),
        title: const Text("退出登录", style: TextStyle(color: Colors.red)),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          AuthService().logout();
          // 直接清空，比refresh更快
          context.read<UserProvider>().clearUser();
          context.go('/?fromOtherPage=true');
        },
      ),
    );
  }
}
