import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odk_flutter_template/core/utils/l10n_utils.dart';
import 'package:odk_flutter_template/features/system/service/system_service.dart';
import 'package:odk_flutter_template/widgets/app_page/app_page.dart';
import 'package:odk_flutter_template/widgets/app_widgets/app_widgets.dart';
import 'package:odk_flutter_template/widgets/mixins/mounted_safe_mixin.dart';
import 'package:odk_flutter_template/widgets/smart_dialog/app_toast.dart';

/// 意见反馈页面
///
/// 原生输入框 + 提交按钮，用户可直接提交反馈内容
/// 不使用 WebView，提供更好的用户体验
class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> with MountedSafeMixin {
  final TextEditingController _feedbackController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  /// 反馈内容是否为空
  bool get _isEmpty => _feedbackController.text.trim().isEmpty;

  /// 提交反馈
  Future<void> _submitFeedback() async {
    // 校验内容不为空
    if (_isEmpty) {
      AppToast.showToast(L10nUtils.feedbackContentRequired);
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      // 调用反馈提交 API
      await SystemService().submitFeedback(_feedbackController.text.trim());

      mountedSafeCallback(() {
        AppToast.showNotify(L10nUtils.feedbackSuccess, null);
        // 提交成功后返回上一页
        Navigator.of(context).pop();
      });
    } catch (e) {
      mountedSafeCallback(() {
        AppToast.showToast(L10nUtils.feedbackFailed);
      });
    } finally {
      mountedSafeSetState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: AppText(L10nUtils.feedback),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 反馈输入区域
            _buildFeedbackInput(context),
            AppGap.hLarge,

            // 提交按钮
            _buildSubmitButton(context),
          ],
        ),
      ),
    );
  }

  /// 反馈输入区域
  Widget _buildFeedbackInput(BuildContext context) {
    return AppCard(
      showShadow: false,
      padding: EdgeInsets.zero,
      child: TextField(
        controller: _feedbackController,
        onChanged: (_) => setState(() {}),
        maxLines: 10,
        minLines: 8,
        maxLength: 1000,
        decoration: InputDecoration(
          hintText: L10nUtils.feedbackHint,
          hintStyle: TextStyle(
            fontSize: 28.sp,
            color: AppColors.textGray(context),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(24.w),
          counterStyle: TextStyle(
            fontSize: 24.sp,
            color: AppColors.textGray(context),
          ),
        ),
        style: TextStyle(fontSize: 28.sp, color: AppColors.textMain(context)),
      ),
    );
  }

  /// 提交按钮
  Widget _buildSubmitButton(BuildContext context) {
    return AppLoadingButton(
      text: L10nUtils.feedbackSubmit,
      isLoading: _isSubmitting,
      disabled: _isEmpty,
      onTap: _submitFeedback,
    );
  }
}
