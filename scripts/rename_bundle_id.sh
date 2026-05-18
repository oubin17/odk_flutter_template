#!/bin/bash
set -e

# =========================================
#  Bundle ID / 包名 全局重命名工具
#  适用于 Flutter 模板项目，一键替换所有平台的包名
# =========================================
#
# 用法:
#   ./scripts/rename_bundle_id.sh <旧iOS Bundle ID> <新iOS Bundle ID> [旧Android包名] [新Android包名]
#
# 示例:
#   # iOS 和 Android 包名相同（最常见）
#   ./scripts/rename_bundle_id.sh com.example.lushiApp com.odk.myapp
#
#   # iOS 和 Android 包名不同
#   ./scripts/rename_bundle_id.sh com.example.lushiApp com.odk.myapp com.example.odk_flutter_template com.odk.myapp
#

OLD_BUNDLE_ID="${1:?用法: ./rename_bundle_id.sh <旧iOS Bundle ID> <新iOS Bundle ID> [旧Android包名] [新Android包名]}"
NEW_BUNDLE_ID="${2:?用法: ./rename_bundle_id.sh <旧iOS Bundle ID> <新iOS Bundle ID> [旧Android包名] [新Android包名]}"

# Android 的 namespace/applicationId 可能与 iOS Bundle ID 不同
OLD_ANDROID_NS="${3:-$OLD_BUNDLE_ID}"
NEW_ANDROID_NS="${4:-$NEW_BUNDLE_ID}"

echo "========================================="
echo "  Bundle ID 重命名工具"
echo "========================================="
echo "iOS/macOS Bundle ID: $OLD_BUNDLE_ID → $NEW_BUNDLE_ID"
echo "Android Namespace:   $OLD_ANDROID_NS → $NEW_ANDROID_NS"
echo "========================================="
echo ""

# 1. 替换 iOS project.pbxproj
if [ -f "ios/Runner.xcodeproj/project.pbxproj" ]; then
  sed -i '' "s/$OLD_BUNDLE_ID/$NEW_BUNDLE_ID/g" ios/Runner.xcodeproj/project.pbxproj
  echo "✅ ios/Runner.xcodeproj/project.pbxproj"
fi

# 2. 替换 macOS AppInfo.xcconfig
if [ -f "macos/Runner/Configs/AppInfo.xcconfig" ]; then
  sed -i '' "s/$OLD_BUNDLE_ID/$NEW_BUNDLE_ID/g" macos/Runner/Configs/AppInfo.xcconfig
  echo "✅ macos/Runner/Configs/AppInfo.xcconfig"
fi

# 3. 替换 macOS project.pbxproj
if [ -f "macos/Runner.xcodeproj/project.pbxproj" ]; then
  sed -i '' "s/$OLD_BUNDLE_ID/$NEW_BUNDLE_ID/g" macos/Runner.xcodeproj/project.pbxproj
  echo "✅ macos/Runner.xcodeproj/project.pbxproj"
fi

# 4. 替换 Android build.gradle.kts
if [ -f "android/app/build.gradle.kts" ]; then
  sed -i '' "s/$OLD_ANDROID_NS/$NEW_ANDROID_NS/g" android/app/build.gradle.kts
  echo "✅ android/app/build.gradle.kts"
fi

# 5. 替换 Android AndroidManifest.xml
if [ -f "android/app/src/main/AndroidManifest.xml" ]; then
  sed -i '' "s/$OLD_ANDROID_NS/$NEW_ANDROID_NS/g" android/app/src/main/AndroidManifest.xml
  echo "✅ android/app/src/main/AndroidManifest.xml"
fi

# 6. 替换 Android MainActivity.kt（在旧目录中）
OLD_KOTLIN_PATH="android/app/src/main/kotlin/$(echo $OLD_ANDROID_NS | tr '.' '/')"
MAIN_ACTIVITY=""
if [ -f "$OLD_KOTLIN_PATH/MainActivity.kt" ]; then
  MAIN_ACTIVITY="$OLD_KOTLIN_PATH/MainActivity.kt"
elif [ -f "android/app/src/main/kotlin/com/example/lushi_app/MainActivity.kt" ]; then
  MAIN_ACTIVITY="android/app/src/main/kotlin/com/example/lushi_app/MainActivity.kt"
fi
if [ -n "$MAIN_ACTIVITY" ]; then
  sed -i '' "s/$OLD_ANDROID_NS/$NEW_ANDROID_NS/g" "$MAIN_ACTIVITY"
  echo "✅ $MAIN_ACTIVITY"
fi

# 7. 替换 Linux CMakeLists.txt
if [ -f "linux/CMakeLists.txt" ]; then
  sed -i '' "s/$OLD_ANDROID_NS/$NEW_ANDROID_NS/g" linux/CMakeLists.txt
  echo "✅ linux/CMakeLists.txt"
fi

# 8. 替换 Windows Runner.rc 中的公司名
if [ -f "windows/runner/Runner.rc" ]; then
  NEW_COMPANY=$(echo "$NEW_ANDROID_NS" | cut -d'.' -f1-2)
  OLD_COMPANY=$(echo "$OLD_ANDROID_NS" | cut -d'.' -f1-2)
  sed -i '' "s/$OLD_COMPANY/$NEW_COMPANY/g" windows/runner/Runner.rc
  echo "✅ windows/runner/Runner.rc"
fi

# 9. 重命名 Android Kotlin 目录结构
NEW_KOTLIN_PATH="android/app/src/main/kotlin/$(echo $NEW_ANDROID_NS | tr '.' '/')"
if [ -d "$OLD_KOTLIN_PATH" ] && [ "$OLD_KOTLIN_PATH" != "$NEW_KOTLIN_PATH" ]; then
  mkdir -p "$(dirname "$NEW_KOTLIN_PATH")"
  if [ -d "$NEW_KOTLIN_PATH" ]; then
    cp -r "$OLD_KOTLIN_PATH"/* "$NEW_KOTLIN_PATH/" 2>/dev/null || true
  else
    mv "$OLD_KOTLIN_PATH" "$NEW_KOTLIN_PATH"
  fi
  # 清理旧的空目录
  rm -rf "android/app/src/main/kotlin/com/example"
  echo "✅ Android Kotlin 目录: $OLD_KOTLIN_PATH → $NEW_KOTLIN_PATH"
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
echo "  4. 在 Xcode 中重新配置签名（Team + Bundle ID）"
echo "  5. 运行: flutter run -t lib/main_dev.dart"
