#!/bin/bash
set -e

# =========================================
#  Flutter 项目名称全局重命名工具
#  替换包名、导入路径、Web 显示名称等
# =========================================
#
# 用法:
#   ./scripts/rename_project_name.sh <新项目名称> [新显示名称]
#
# 示例:
#   # 新项目名称: my_flutter_app，新显示名称自动从项目名转换
#   ./scripts/rename_project_name.sh my_flutter_app
#
#   # 新项目名称: my_flutter_app，新显示名称: My Flutter App
#   ./scripts/rename_project_name.sh my_flutter_app "My Flutter App"
#

OLD_PROJECT_NAME="odk_flutter_template"
OLD_DISPLAY_NAME="ODK Flutter Template"

NEW_PROJECT_NAME="${1:?用法: ./rename_project_name.sh <新项目名称> [新显示名称]}"

# 如果没有提供新显示名称，从项目名称自动转换
if [ -z "$2" ]; then
  # 将下划线转换为空格，然后将每个单词首字母大写
  NEW_DISPLAY_NAME=$(echo "$NEW_PROJECT_NAME" | sed 's/_/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2));}1')
else
  NEW_DISPLAY_NAME="$2"
fi

echo "========================================="
echo "  Flutter 项目重命名工具"
echo "========================================="
echo "旧项目名称: $OLD_PROJECT_NAME"
echo "旧显示名称: $OLD_DISPLAY_NAME"
echo "新项目名称: $NEW_PROJECT_NAME"
echo "新显示名称: $NEW_DISPLAY_NAME"
echo "========================================="
echo ""

# 1. 替换 pubspec.yaml 中的 name
if [ -f "pubspec.yaml" ]; then
  sed -i '' "s/^name: $OLD_PROJECT_NAME$/name: $NEW_PROJECT_NAME/" pubspec.yaml
  echo "✅ pubspec.yaml"
fi

# 2. 替换所有 Dart 文件中的 package 导入
echo "正在替换 Dart 文件中的导入路径..."
find lib -type f -name "*.dart" -exec sed -i '' "s/package:$OLD_PROJECT_NAME/package:$NEW_PROJECT_NAME/g" {} \;
echo "✅ lib/ 目录下的 Dart 文件"

# 3. 替换 web/manifest.json
if [ -f "web/manifest.json" ]; then
  sed -i '' "s/\"name\": \"$OLD_PROJECT_NAME\"/\"name\": \"$NEW_DISPLAY_NAME\"/" web/manifest.json
  sed -i '' "s/\"short_name\": \"$OLD_PROJECT_NAME\"/\"short_name\": \"$NEW_PROJECT_NAME\"/" web/manifest.json
  echo "✅ web/manifest.json"
fi

# 4. 替换 web/index.html
if [ -f "web/index.html" ]; then
  sed -i '' "s/content=\"$OLD_DISPLAY_NAME\"/content=\"$NEW_DISPLAY_NAME\"/" web/index.html
  sed -i '' "s/apple-mobile-web-app-title\" content=\"$OLD_PROJECT_NAME\"/apple-mobile-web-app-title\" content=\"$NEW_DISPLAY_NAME\"/" web/index.html
  sed -i '' "s/<title>$OLD_PROJECT_NAME<\/title>/<title>$NEW_DISPLAY_NAME<\/title>/" web/index.html
  echo "✅ web/index.html"
fi

# 5. 替换国际化文件中的显示名称
if [ -f "lib/l10n/app_localizations_en.dart" ]; then
  sed -i '' "s/appTitle => '$OLD_DISPLAY_NAME'/appTitle => '$NEW_DISPLAY_NAME'/" lib/l10n/app_localizations_en.dart
  echo "✅ lib/l10n/app_localizations_en.dart"
fi

if [ -f "lib/l10n/app_localizations.dart" ]; then
  sed -i '' "s/'ODK Flutter Template'/'ODK Flutter Template'/g" lib/l10n/app_localizations.dart
  # 更精确地替换
  sed -i '' "s/ODK Flutter Template/$NEW_DISPLAY_NAME/g" lib/l10n/app_localizations.dart
  echo "✅ lib/l10n/app_localizations.dart"
fi

# 6. 替换 arb 文件
if [ -f "lib/l10n/app_en.arb" ]; then
  sed -i '' "s/\"appTitle\": \"$OLD_DISPLAY_NAME\"/\"appTitle\": \"$NEW_DISPLAY_NAME\"/" lib/l10n/app_en.arb
  echo "✅ lib/l10n/app_en.arb"
fi

if [ -f "lib/l10n/app_zh.arb" ]; then
  sed -i '' "s/\"appTitle\": \"$OLD_DISPLAY_NAME\"/\"appTitle\": \"$NEW_DISPLAY_NAME\"/" lib/l10n/app_zh.arb
  echo "✅ lib/l10n/app_zh.arb"
fi

echo ""
echo "========================================="
echo "  ✅ 全部替换完成！"
echo "========================================="
echo ""
echo "📌 后续步骤："
echo "  1. 清理构建缓存: flutter clean"
echo "  2. 重新获取依赖: flutter pub get"
echo "  3. iOS 需重新 pod install: cd ios && pod install"
echo "  4. 重新生成国际化代码: flutter gen-l10n"
echo "  5. 在 Xcode 中重新配置签名（Team + Bundle ID）"
echo "  6. 运行: flutter run"
echo ""
echo "⚠️  注意：如果需要同时修改 Bundle ID，请运行:"
echo "    ./scripts/rename_bundle_id.sh <旧Bundle ID> <新Bundle ID>"
