import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odk_flutter_template/core/utils/date_time_utils.dart';
import 'package:odk_flutter_template/core/utils/l10n_utils.dart';
import 'package:odk_flutter_template/features/basic_user/data/models/user_profile/user_profile_request.dart';
import 'package:odk_flutter_template/features/basic_user/domain/user_profile_service.dart';
import 'package:odk_flutter_template/routes/navigator_utils.dart';
import 'package:odk_flutter_template/widgets/app_widgets/app_widgets.dart';
import 'package:odk_flutter_template/widgets/appbar/app_bar.dart';
import 'package:odk_flutter_template/widgets/smart_dialog/app_toast.dart';

enum UserInfoUpdateType { nickname, gender, birthday }

class UserInfoUpdatePage extends StatefulWidget {
  const UserInfoUpdatePage({
    super.key,
    required this.title,
    required this.value,
    required this.type,
  });

  final String title;
  final String? value;
  final UserInfoUpdateType type;

  @override
  State<UserInfoUpdatePage> createState() => _UserInfoUpdatePageState();
}

class _UserInfoUpdatePageState extends State<UserInfoUpdatePage> {
  late final TextEditingController _nicknameController;
  String? _selectedGender;
  DateTime? _selectedBirthday;
  late final TextEditingController _birthdayController;

  @override
  void initState() {
    super.initState();
    _nicknameController = TextEditingController(text: widget.value ?? '');
    _selectedGender = widget.value?.toString();
    // 初始化生日
    _selectedBirthday = DateTime.tryParse(widget.value ?? '');
    _birthdayController = TextEditingController(
      text: _selectedBirthday != null
          ? DateTimeUtils.dateToDateStr(_selectedBirthday)
          : '',
    );
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _birthdayController.dispose();
    super.dispose();
  }

  // 🔥 底部弹出 原生年月日滚轮选择器（替代丑陋的顶部弹窗）
  Future<void> _showBottomDatePicker() async {
    AppBottomDatePicker.show(
      context: context,
      initialDate: _selectedBirthday,
      onConfirm: (date) {
        setState(() {
          _selectedBirthday = date;
          _birthdayController.text = DateTimeUtils.dateToDateStr(date);
        });
      },
    );
  }

  void _handleSave() {
    switch (widget.type) {
      case UserInfoUpdateType.nickname:
        final newNickname = _nicknameController.text.trim();
        if (newNickname.isEmpty) {
          AppToast.showToast(L10nUtils.fieldNotEmptyTip(L10nUtils.nickname));
          return;
        }
        UserProfileService().updateProfile(
          UserProfileRequest(userName: newNickname),
        );
        break;
      case UserInfoUpdateType.gender:
        if (_selectedGender == null) {
          AppToast.showToast(L10nUtils.fieldNotEmptyTip(L10nUtils.gender));
          return;
        }
        UserProfileService().updateProfile(
          UserProfileRequest(gender: _selectedGender),
        );
        break;
      case UserInfoUpdateType.birthday:
        if (_selectedBirthday == null) {
          AppToast.showToast(L10nUtils.fieldNotEmptyTip(L10nUtils.birthday));
          return;
        }
        UserProfileService().updateProfile(
          UserProfileRequest(
            birthDay: DateTimeUtils.dateToDateStr(_selectedBirthday),
          ),
        );
        break;
    }
    AppToast.showToast(L10nUtils.success);
    NavigatorUtils.pop();
  }

  /// 新增：构建昵称输入框
  Widget _buildNicknameInputWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: AppInput(
        controller: _nicknameController,
        validator: (value) => value?.trim().isEmpty ?? true
            ? L10nUtils.fieldNotEmptyTip(L10nUtils.nickname)
            : null,
        suffixIcon: ClearButton(controller: _nicknameController),
      ),
    );
  }

  // 🔥 微信风格性别选择（全屏+可正常切换选中）
  Widget _buildGenderInputWidget() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          _buildGenderItem(L10nUtils.male, "1"),
          Divider(height: 1.h, color: AppColors.divider(context), indent: 40.w),
          _buildGenderItem(L10nUtils.female, "2"),
        ],
      ),
    );
  }

  Widget _buildGenderItem(String title, String value) {
    final isSelected = _selectedGender == value;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        setState(() {
          _selectedGender = value;
        });
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 18.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(title, size: 28.sp, color: AppColors.textMain(context)),
            if (isSelected)
              Icon(Icons.check, color: AppColors.primary(context), size: 32.sp),
          ],
        ),
      ),
    );
  }

  // 🔥 生日输入框：只读 + 点击弹出底部选择器
  Widget _buildBirthdayInputWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: AppInput(
        controller: _birthdayController,
        readOnly: true, // 禁止手动输入
        onTap: _showBottomDatePicker, // 点击弹出底部选择器
        hint: L10nUtils.birthday,
        suffixIcon: const Icon(Icons.calendar_today),
      ),
    );
  }

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
      appBar: BasicAppBar(title: AppText(widget.title), onSave: _handleSave),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [_buildInputWidget()],
        ),
      ),
    );
  }
}
