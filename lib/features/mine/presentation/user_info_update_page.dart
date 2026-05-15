import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:odk_flutter_template/core/utils/date_time_utils.dart';
import 'package:odk_flutter_template/core/utils/l10n_utils.dart';
import 'package:odk_flutter_template/features/basic_user/data/models/user_profile/user_profile_request.dart';
import 'package:odk_flutter_template/features/basic_user/domain/user_profile_service.dart';
import 'package:odk_flutter_template/routes/navigator_utils.dart';
import 'package:odk_flutter_template/widgets/app_page/app_page.dart';
import 'package:odk_flutter_template/widgets/app_widgets/app_widgets.dart';
import 'package:odk_flutter_template/widgets/smart_dialog/app_toast.dart';
import 'package:permission_handler/permission_handler.dart';

enum UserInfoUpdateType { nickname, gender, birthday, avatar }

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

  // 头像相关状态
  String? _avatarUrl;
  XFile? _selectedImage;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nicknameController = TextEditingController(text: widget.value ?? '');
    _selectedGender = widget.value?.toString();
    _selectedBirthday = DateTime.tryParse(widget.value ?? '');
    _birthdayController = TextEditingController(
      text: _selectedBirthday != null
          ? DateTimeUtils.dateToDateStr(_selectedBirthday)
          : '',
    );
    if (widget.type == UserInfoUpdateType.avatar) {
      _avatarUrl = widget.value;
    }
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _birthdayController.dispose();
    super.dispose();
  }

  // ===================== 日期选择 =====================

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

  // ===================== 权限请求 =====================

  Future<bool> _requestCameraPermission() async {
    final status = await Permission.camera.status;
    if (status.isGranted) return true;

    final result = await Permission.camera.request();
    if (result.isGranted) return true;

    if (result.isPermanentlyDenied) {
      if (mounted) {
        AppToast.showAppConfirmDialog(
          title: L10nUtils.cameraPermissionDenied,
          msg: L10nUtils.permissionDeniedTip,
          onConfirm: () => openAppSettings(),
        );
      }
      return false;
    }

    if (mounted) {
      AppToast.showToast(L10nUtils.cameraPermissionDenied);
    }
    return false;
  }

  Future<bool> _requestPhotoPermission() async {
    final status = await Permission.photos.status;
    if (status.isGranted) return true;

    final result = await Permission.photos.request();
    if (result.isGranted) return true;

    if (result.isPermanentlyDenied) {
      if (mounted) {
        AppToast.showAppConfirmDialog(
          title: L10nUtils.photoPermissionDenied,
          msg: L10nUtils.permissionDeniedTip,
          onConfirm: () => openAppSettings(),
        );
      }
      return false;
    }

    if (mounted) {
      AppToast.showToast(L10nUtils.photoPermissionDenied);
    }
    return false;
  }

  // ===================== 图片选择 =====================

  Future<void> _pickFromCamera() async {
    final hasPermission = await _requestCameraPermission();
    if (!hasPermission) return;

    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() => _selectedImage = image);
      }
    } catch (e) {
      AppToast.showToast(L10nUtils.error);
    }
  }

  Future<void> _pickFromGallery() async {
    final hasPermission = await _requestPhotoPermission();
    if (!hasPermission) return;

    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() => _selectedImage = image);
      }
    } catch (e) {
      AppToast.showToast(L10nUtils.error);
    }
  }

  /// 底部弹出选择拍照/相册
  void _showImageSourceActionSheet() {
    FocusScope.of(context).unfocus();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: AppColors.card(context),
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.w)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildActionSheetHeader(L10nUtils.selectAvatar),
              _buildActionSheetItem(
                icon: Icons.camera_alt_outlined,
                text: L10nUtils.takePhoto,
                onTap: _pickFromCamera,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: Divider(height: 1.h, color: AppColors.divider(context)),
              ),
              _buildActionSheetItem(
                icon: Icons.photo_library_outlined,
                text: L10nUtils.chooseFromAlbum,
                onTap: _pickFromGallery,
              ),
              Divider(height: 8.h, color: AppColors.divider(context)),
              _buildActionSheetCancel(),
            ],
          ),
        ),
      ),
    );
  }

  /// ActionSheet 标题栏
  Widget _buildActionSheetHeader(String title) {
    return Container(
      height: 80.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.divider(context), width: 1),
        ),
      ),
      child: AppText.body(title, color: AppColors.textGray(context)),
    );
  }

  /// ActionSheet 选项行
  Widget _buildActionSheetItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: () {
        NavigatorUtils.pop();
        onTap();
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 28.h),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36.w, color: AppColors.primary(context)),
            AppGap.wNormal,
            AppText.body(text),
          ],
        ),
      ),
    );
  }

  /// ActionSheet 取消按钮
  Widget _buildActionSheetCancel() {
    return InkWell(
      onTap: () => NavigatorUtils.pop(),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 28.h),
        alignment: Alignment.center,
        child: AppText.body(
          L10nUtils.cancel,
          color: AppColors.textGray(context),
        ),
      ),
    );
  }

  // ===================== 保存逻辑 =====================

  void _handleSave() async {
    if (_isSaving) return;

    switch (widget.type) {
      case UserInfoUpdateType.nickname:
        final newNickname = _nicknameController.text.trim();
        if (newNickname.isEmpty) {
          AppToast.showToast(L10nUtils.fieldNotEmptyTip(L10nUtils.nickname));
          return;
        }
        await UserProfileService().updateProfile(
          UserProfileRequest(userName: newNickname),
        );
        break;
      case UserInfoUpdateType.gender:
        if (_selectedGender == null) {
          AppToast.showToast(L10nUtils.fieldNotEmptyTip(L10nUtils.gender));
          return;
        }
        await UserProfileService().updateProfile(
          UserProfileRequest(gender: _selectedGender),
        );
        break;
      case UserInfoUpdateType.birthday:
        if (_selectedBirthday == null) {
          AppToast.showToast(L10nUtils.fieldNotEmptyTip(L10nUtils.birthday));
          return;
        }
        await UserProfileService().updateProfile(
          UserProfileRequest(
            birthDay: DateTimeUtils.dateToDateStr(_selectedBirthday),
          ),
        );
        break;
      case UserInfoUpdateType.avatar:
        if (_selectedImage == null) {
          AppToast.showToast(L10nUtils.fieldNotEmptyTip(L10nUtils.avatar));
          return;
        }
        setState(() => _isSaving = true);
        AppToast.showLoading(loading: L10nUtils.saving);
        try {
          await UserProfileService().updateAvatar(_selectedImage!.path);
          AppToast.dismiss();
          if (mounted) {
            AppToast.showToast(L10nUtils.avatarUpdateSuccess);
          }
        } catch (e) {
          AppToast.dismiss();
          if (mounted) {
            AppToast.showToast(L10nUtils.uploadFailed);
          }
        } finally {
          if (mounted) {
            setState(() => _isSaving = false);
          }
        }
        break;
    }

    if (widget.type != UserInfoUpdateType.avatar) {
      AppToast.showToast(L10nUtils.success);
    }
    if (mounted) {
      NavigatorUtils.pop();
    }
  }

  // ===================== UI 构建 =====================

  /// 昵称输入框
  Widget _buildNicknameInputWidget() {
    return AppCard(
      showShadow: false,
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: AppInput(
        controller: _nicknameController,
        validator: (value) => value?.trim().isEmpty ?? true
            ? L10nUtils.fieldNotEmptyTip(L10nUtils.nickname)
            : null,
        suffixIcon: ClearButton(controller: _nicknameController),
      ),
    );
  }

  /// 性别选择
  Widget _buildGenderInputWidget() {
    return AppCard(
      showShadow: false,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          _buildGenderItem(L10nUtils.male, "1"),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: Divider(height: 1.h, color: AppColors.divider(context)),
          ),
          _buildGenderItem(L10nUtils.female, "2"),
        ],
      ),
    );
  }

  Widget _buildGenderItem(String title, String value) {
    final isSelected = _selectedGender == value;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => setState(() => _selectedGender = value),
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

  /// 生日输入框
  Widget _buildBirthdayInputWidget() {
    return AppCard(
      showShadow: false,
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: AppInput(
        controller: _birthdayController,
        readOnly: true,
        onTap: _showBottomDatePicker,
        hint: L10nUtils.birthday,
        suffixIcon: const Icon(Icons.calendar_today),
      ),
    );
  }

  /// 头像更新页面
  Widget _buildAvatarInputWidget() {
    return Column(
      children: [
        // 大头像展示区域
        GestureDetector(
          onTap: _showImageSourceActionSheet,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 60.h),
            alignment: Alignment.center,
            child: Stack(
              children: [
                _buildAvatarDisplay(),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 56.w,
                    height: 56.w,
                    decoration: BoxDecoration(
                      color: AppColors.primary(context),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.bgPage(context),
                        width: 3.w,
                      ),
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      size: 28.w,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        AppGap.hNormal,

        // 底部选择区域
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.second(
                L10nUtils.selectAvatar,
                color: AppColors.textGray(context),
              ),
              AppGap.hNormal,
              _buildAvatarOptionButton(
                icon: Icons.camera_alt_outlined,
                text: L10nUtils.takePhoto,
                onTap: _pickFromCamera,
              ),
              AppGap.hSmall,
              _buildAvatarOptionButton(
                icon: Icons.photo_library_outlined,
                text: L10nUtils.chooseFromAlbum,
                onTap: _pickFromGallery,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 构建头像显示
  Widget _buildAvatarDisplay() {
    final double avatarSize = 200.w;

    if (_selectedImage != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(avatarSize),
        child: Container(
          width: avatarSize,
          height: avatarSize,
          color: AppColors.primaryLight(context),
          child: Image.file(
            File(_selectedImage!.path),
            fit: BoxFit.cover,
            width: avatarSize,
            height: avatarSize,
          ),
        ),
      );
    }

    if (_avatarUrl != null && _avatarUrl!.isNotEmpty) {
      return AppAvatar(
        imgUrl: _avatarUrl,
        size: avatarSize,
        shape: AppAvatarShape.circle,
      );
    }

    return AppAvatar(size: avatarSize, shape: AppAvatarShape.circle);
  }

  /// 头像选项按钮
  Widget _buildAvatarOptionButton({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.w),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 30.w),
        decoration: BoxDecoration(
          color: AppColors.card(context),
          borderRadius: BorderRadius.circular(16.w),
          border: Border.all(color: AppColors.divider(context), width: 1.w),
        ),
        child: Row(
          children: [
            Icon(icon, size: 36.w, color: AppColors.primary(context)),
            AppGap.wNormal,
            AppText.body(text),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              size: 24.w,
              color: AppColors.textGray(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputWidget() {
    return switch (widget.type) {
      UserInfoUpdateType.nickname => _buildNicknameInputWidget(),
      UserInfoUpdateType.gender => _buildGenderInputWidget(),
      UserInfoUpdateType.birthday => _buildBirthdayInputWidget(),
      UserInfoUpdateType.avatar => _buildAvatarInputWidget(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: AppText(widget.title),
      onSave: _isSaving ? null : _handleSave,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [_buildInputWidget()],
        ),
      ),
    );
  }
}
