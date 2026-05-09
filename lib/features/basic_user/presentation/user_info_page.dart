import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:odk_flutter_template/core/utils/enum_utils.dart';
import 'package:odk_flutter_template/core/utils/l10n_utils.dart';
import 'package:odk_flutter_template/features/basic_user/data/models/user_query/gender_enum.dart';
import 'package:odk_flutter_template/features/basic_user/presentation/user_info_update_page.dart';
import 'package:odk_flutter_template/gen/assets.gen.dart';
import 'package:odk_flutter_template/providers/user/user_provider.dart';
import 'package:odk_flutter_template/routes/app_router.dart';
import 'package:odk_flutter_template/routes/navigator_utils.dart';
import 'package:odk_flutter_template/widgets/app_widgets/app_widgets.dart';
import 'package:odk_flutter_template/widgets/appbar/app_bar.dart';
import 'package:provider/provider.dart';

class UserInfoPage extends StatelessWidget {
  const UserInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage(context),
      appBar: BasicAppBar(title: AppText(L10nUtils.profile)),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          // 👇 关键：从 Provider 中拿最新的用户数据
          final user = userProvider.userEntity;
          return Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: ListView(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              children: [
                Divider(height: 1.h, color: AppColors.divider(context)),

                AppListItem(
                  // left: AppText.second("头像"),
                  title: L10nUtils.avatar,
                  right: Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: AppAvatar(
                      assetPath: user?.isAdmin == true
                          ? Assets.images.profile.admin.path
                          : Assets.images.profile.employee.path,
                      size: 80.w,
                    ),
                  ),
                  showArrow: false,
                  // desc: "1.0.0",
                ),
                Divider(height: 1.h, color: AppColors.divider(context)),
                AppListItem(
                  // left: AppText.second("头像"),
                  title: L10nUtils.nickname,
                  right: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: AppText(
                      user?.userProfile?.userName ?? "",
                      size: 26.sp,
                    ),
                  ),
                  // desc: "1.0.0",
                  onTap: () {
                    NavigatorUtils.pushNamed(
                      RouteNames.userInfoUpdate,
                      queryParameters: {
                        'title': L10nUtils.nickname,
                        'value': user?.userProfile?.userName ?? "",
                        'type': UserInfoUpdateType.nickname.index.toString(),
                      },
                    );
                    // Fluttertoast.showToast(msg: "操作成功！");
                  },
                ),
                Divider(height: 1.h, color: AppColors.divider(context)),
                AppListItem(
                  // left: AppText.second("头像"),
                  title: L10nUtils.gender,
                  right: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: AppText(
                      GenderEnum.fromCode(user?.userProfile?.gender ?? ""),
                      size: 26.sp,
                    ),
                  ),
                  // desc: "1.0.0",
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
                Divider(height: 1.h, color: AppColors.divider(context)),
                AppListItem(
                  title: L10nUtils.birthday,
                  right: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: AppText(
                      user?.userProfile?.birthDay ?? "",
                      size: 26.sp,
                    ),
                  ),
                  // desc: "1.0.0",
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
                Divider(height: 1.h, color: AppColors.divider(context)),
                AppListItem(
                  title: L10nUtils.phoneNumber,
                  right: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: AppText(
                      user?.accessToken.tokenValue ?? "",
                      size: 26.sp,
                    ),
                  ),
                  showArrow: false,
                  // desc: "1.0.0",
                  onTap: () {},
                ),
                Divider(height: 1.h, color: AppColors.divider(context)),
              ],
            ),
          );
        },
      ),
    );
  }
}
