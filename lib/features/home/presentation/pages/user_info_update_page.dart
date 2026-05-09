import 'package:flutter/material.dart';
import 'package:odk_flutter_template/core/utils/date_time_utils.dart';
import 'package:odk_flutter_template/features/basic_user/data/models/user_profile/user_profile_request.dart';
import 'package:odk_flutter_template/features/basic_user/domain/user_profile_service.dart';
import 'package:odk_flutter_template/routes/navigator_utils.dart';
import 'package:odk_flutter_template/widgets/app_widgets/app_widgets.dart';
import 'package:odk_flutter_template/widgets/appbar/app_bar.dart';
import 'package:odk_flutter_template/widgets/smart_dialog/app_toast.dart';

// 1. 定义修改类型枚举（规范：昵称/性别/生日）
enum UserInfoUpdateType {
  nickname, // 修改昵称
  gender, // 修改性别
  birthday, // 修改生日
}

// 2. 改为 StatefulWidget（需要管理输入状态）
class UserInfoUpdatePage extends StatefulWidget {
  // 核心入参：标题文案 + 修改类型
  const UserInfoUpdatePage({
    super.key,
    required this.title, // 页面标题（如：修改昵称）
    required this.value, // 初始值（如：当前昵称）
    required this.type, // 修改类型
  });

  final String title;
  final String? value;
  final UserInfoUpdateType type;

  @override
  State<UserInfoUpdatePage> createState() => _UserInfoUpdatePageState();
}

class _UserInfoUpdatePageState extends State<UserInfoUpdatePage> {
  // 昵称输入控制器
  TextEditingController get _nicknameController =>
      TextEditingController(text: widget.value ?? '');
  // 选中的性别
  String? _selectedGender;
  // 选中的生日
  DateTime? _selectedBirthday;

  // 3. 销毁控制器，防止内存泄漏
  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  // 打开日期选择器
  Future<void> _showDatePicker() async {
    final result = await showDatePicker(
      context: context,
      initialDate: _selectedBirthday ?? DateTime.now(),
      firstDate: DateTime(1900), // 最小日期
      lastDate: DateTime.now(), // 最大日期（今天）
    );
    if (result != null) {
      setState(() => _selectedBirthday = result);
    }
  }

  // 保存按钮逻辑
  void _handleSave() {
    switch (widget.type) {
      case UserInfoUpdateType.nickname:
        final newNickname = _nicknameController.text.trim();
        if (newNickname.isEmpty) {
          AppToast.showToast("昵称不能为空");
          return;
        }
        // 调用更新昵称接口
        UserProfileService().updateProfile(
          UserProfileRequest(userName: newNickname),
        );
        break;
      case UserInfoUpdateType.gender:
        if (_selectedGender == null) {
          AppToast.showToast("请选择性别");
          return;
        }
        // 调用更新性别接口
        UserProfileService().updateProfile(
          UserProfileRequest(gender: _selectedGender),
        );
        break;
      case UserInfoUpdateType.birthday:
        if (_selectedBirthday == null) {
          AppToast.showToast("请选择生日");
          return;
        }
        // 调用更新生日接口
        UserProfileService().updateProfile(
          UserProfileRequest(
            birthDay: DateTimeUtils.dateToDateStr(_selectedBirthday),
          ),
        );
        break;
    }
    // 保存成功，返回上一页
    NavigatorUtils.pop();
  }

  Widget _buildNicknameInputWidget() {
    return AppInput(
      controller: _nicknameController,
      // label: '昵称',
      // prefix: const AppText("昵称"),
      validator: (value) => value?.trim() ?? "昵称不能为空",
      suffix: ClearButton(controller: _nicknameController),
    );
  }

  Widget _buildGenderInputWidget() {
    return Column(
      children: [
        // 性别单选：仅允许男/女
        RadioListTile<String>(
          title: const AppText("男"),
          value: "1",
          groupValue: _selectedGender,
          onChanged: (val) => setState(() => _selectedGender = val),
        ),
        RadioListTile<String>(
          title: const AppText("女"),
          value: "2",
          groupValue: _selectedGender,
          onChanged: (val) => setState(() => _selectedGender = val),
        ),
      ],
    );
  }

  Widget _buildBirthdayInputWidget() {
    return TextField(
      // 生日禁止手动输入，只能点击选择
      readOnly: true,
      onTap: _showDatePicker,
      controller: TextEditingController(
        text: _selectedBirthday != null
            ? "${_selectedBirthday!.year}-${_selectedBirthday!.month.toString().padLeft(2, '0')}-${_selectedBirthday!.day.toString().padLeft(2, '0')}"
            : "",
      ),
      decoration: const InputDecoration(
        label: AppText("请选择生日"),
        border: OutlineInputBorder(),
        suffixIcon: Icon(Icons.calendar_today),
      ),
    );
  }

  // 根据类型渲染不同的输入组件
  Widget _buildInputWidget() {
    switch (widget.type) {
      case UserInfoUpdateType.nickname:
        return _buildNicknameInputWidget();
      case UserInfoUpdateType.gender:
        return _buildGenderInputWidget();
      case UserInfoUpdateType.birthday:
        return _buildBirthdayInputWidget();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 标题动态展示传入的文案
      appBar: BasicAppBar(
        title: AppText(widget.title),
        onSave: _handleSave, // 你的保存逻辑
        saveText: '保存', // 可选自定义文案
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // const SizedBox(height: 20),
            // 动态输入组件
            _buildInputWidget(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
