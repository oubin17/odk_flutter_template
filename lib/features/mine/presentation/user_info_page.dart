import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odk_flutter_template/core/utils/l10n_utils.dart';
import 'package:odk_flutter_template/features/basic_user/data/models/user_query/gender_enum.dart';
import 'package:odk_flutter_template/features/mine/presentation/user_info_update_page.dart';
import 'package:odk_flutter_template/gen/assets.gen.dart';
import 'package:odk_flutter_template/providers/user/user_provider.dart';
import 'package:odk_flutter_template/routes/app_router.dart';
import 'package:odk_flutter_template/routes/navigator_utils.dart';
import 'package:odk_flutter_template/widgets/app_page/app_page.dart';
import 'package:odk_flutter_template/widgets/app_widgets/app_widgets.dart';
import 'package:provider/provider.dart';

class UserInfoPage extends StatelessWidget {
  const UserInfoPage({super.key});

  /// 分组内分割线
  Widget _buildDivider(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: Divider(height: 1.h, color: AppColors.divider(context)),
    );
  }

  /// 头像分组
  Widget _buildAvatarContext(BuildContext context, user) {
    return AppListItem(
      title: L10nUtils.avatar,
      right: Padding(
        padding: const EdgeInsets.only(right: 20.0),
        child: AppAvatar(
          imgUrl:
              (user?.userProfile?.avatarUrl != null &&
                  user!.userProfile!.avatarUrl!.isNotEmpty)
              ? user.userProfile!.avatarUrl
              : null,
          assetPath:
              (user?.userProfile?.avatarUrl == null ||
                  user!.userProfile!.avatarUrl!.isEmpty)
              ? (user?.isAdmin == true
                    ? Assets.images.profile.admin.path
                    : Assets.images.profile.employee.path)
              : null,
          size: 80.w,
        ),
      ),
      onTap: () => NavigatorUtils.pushNamed(
        RouteNames.userInfoUpdate,
        queryParameters: {
          'title': L10nUtils.avatar,
          'value': user?.userProfile?.avatarUrl ?? "",
          'type': UserInfoUpdateType.avatar.index.toString(),
        },
      ),
    );
  }

  /// 基本信息分组（昵称、性别、生日）
  Widget _buildBasicInfoContext(BuildContext context, user) {
    return Column(
      children: [
        AppListItem(
          title: L10nUtils.nickname,
          right: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: AppText(user?.userProfile?.userName ?? "", size: 26.sp),
          ),
          onTap: () {
            NavigatorUtils.pushNamed(
              RouteNames.userInfoUpdate,
              queryParameters: {
                'title': L10nUtils.nickname,
                'value': user?.userProfile?.userName ?? "",
                'type': UserInfoUpdateType.nickname.index.toString(),
              },
            );
          },
        ),
        _buildDivider(context),
        AppListItem(
          title: L10nUtils.gender,
          right: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: AppText(
              GenderEnum.fromCode(user?.userProfile?.gender ?? ""),
              size: 26.sp,
            ),
          ),
          onTap: () {
            NavigatorUtils.pushNamed(
              RouteNames.userInfoUpdate,
              queryParameters: {
                'title': L10nUtils.gender,
                'value': user?.userProfile?.gender.toString() ?? "",
                'type': UserInfoUpdateType.gender.index.toString(),
              },
            );
          },
        ),
        _buildDivider(context),
        AppListItem(
          title: L10nUtils.birthday,
          right: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: AppText(user?.userProfile?.birthDay ?? "", size: 26.sp),
          ),
          onTap: () {
            NavigatorUtils.pushNamed(
              RouteNames.userInfoUpdate,
              queryParameters: {
                'title': L10nUtils.birthday,
                'value': user?.userProfile?.birthDay ?? "",
                'type': UserInfoUpdateType.birthday.index.toString(),
              },
            );
          },
        ),
      ],
    );
  }

  /// 账号信息分组（手机号）
  Widget _buildAccountContext(BuildContext context, user) {
    return AppListItem(
      title: L10nUtils.phoneNumber,
      right: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: AppText(user?.accessToken.tokenValue ?? "", size: 26.sp),
      ),
      showArrow: false,
      onTap: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: AppText(L10nUtils.profile),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          final user = userProvider.userEntity;
          return ListView(
            children: [
              // 头像
              AppCard(
                showShadow: false,
                padding: EdgeInsets.zero,
                child: _buildAvatarContext(context, user),
              ),

              AppGap.h(24),

              // 基本信息
              AppCard(
                showShadow: false,
                padding: EdgeInsets.zero,
                child: _buildBasicInfoContext(context, user),
              ),

              AppGap.h(24),

              // 账号信息
              AppCard(
                showShadow: false,
                padding: EdgeInsets.zero,
                child: _buildAccountContext(context, user),
              ),
            ],
          );
        },
      ),
    );
  }
}
