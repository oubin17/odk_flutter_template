import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

/// 应用缓存管理器
/// 封装缓存大小计算和清理功能
/// 目前项目缓存主要来源：
///   1. CachedNetworkImage 图片缓存（存储在临时目录的 libCachedImageData 子目录）
///   2. 其他临时文件（临时目录下的其他文件）
/// 由于图片缓存目录是临时目录的子目录，计算总大小时只需遍历临时目录即可
class AppCacheManager {
  AppCacheManager._();

  /// 清理时需要保护的目录名列表
  /// 这些目录虽然位于临时目录下，但存储的是用户关键数据，不应被清理
  /// - flutter_secure_storage：加密存储（token 等敏感信息）
  /// - shared_preferences：偏好设置（虽然 Android/iOS 原生存储不在临时目录，
  ///   但部分平台实现可能在临时目录中有缓存文件）
  static const _protectedDirNames = <String>{'flutter_secure_storage'};

  /// 获取缓存总大小（格式化字符串，如 "12.5 MB"）
  static Future<String> getCacheSizeFormatted() async {
    try {
      final totalBytes = await getCacheSize();
      return _formatBytes(totalBytes);
    } catch (e) {
      return '--';
    }
  }

  /// 获取缓存总大小（字节数）
  /// 遍历临时目录计算，已包含 CachedNetworkImage 图片缓存
  static Future<int> getCacheSize() async {
    try {
      final tempDir = await getTemporaryDirectory();
      if (await tempDir.exists()) {
        return await _calculateDirSize(tempDir);
      }
      return 0;
    } catch (e) {
      return 0;
    }
  }

  /// 递归计算目录大小
  static Future<int> _calculateDirSize(Directory dir) async {
    int totalSize = 0;
    try {
      await for (final entity in dir.list(
        recursive: true,
        followLinks: false,
      )) {
        if (entity is File) {
          try {
            totalSize += await entity.length();
          } catch (_) {
            // 文件可能已被删除或无权限访问，跳过
          }
        }
      }
    } catch (_) {
      // 目录遍历异常，返回已计算的大小
    }
    return totalSize;
  }

  /// 清理所有缓存
  /// 只清理已知的缓存目录，保护用户关键数据目录不被误删
  static Future<void> clearCache() async {
    // 1. 清理 CachedNetworkImage 图片缓存（通过 API 清理，确保索引一致）
    await _clearImageCache();

    // 2. 清理临时目录中非保护的缓存文件
    await _clearTempDir();
  }

  /// 清理 CachedNetworkImage 图片缓存
  static Future<void> _clearImageCache() async {
    try {
      final cacheManager = DefaultCacheManager();
      await cacheManager.emptyCache();
    } catch (_) {
      // 清理失败静默处理
    }
  }

  /// 清理临时目录中非保护的缓存文件
  /// 遍历临时目录下的顶层文件和目录，跳过受保护的目录
  static Future<void> _clearTempDir() async {
    try {
      final tempDir = await getTemporaryDirectory();
      if (await tempDir.exists()) {
        await for (final entity in tempDir.list(
          recursive: false,
          followLinks: false,
        )) {
          // 跳过受保护的目录，不清理用户关键数据
          if (entity is Directory &&
              _protectedDirNames.contains(entity.path.split('/').last)) {
            continue;
          }
          try {
            if (entity is File) {
              await entity.delete();
            } else if (entity is Directory) {
              await entity.delete(recursive: true);
            }
          } catch (_) {
            // 单个文件/目录删除失败不影响其他，继续清理
          }
        }
      }
    } catch (_) {
      // 清理失败静默处理
    }
  }

  /// 格式化字节数为可读字符串
  /// 例如：1024 → "1.00 KB"，1048576 → "1.00 MB"
  static String _formatBytes(int bytes) {
    if (bytes <= 0) return '0 B';

    const units = ['B', 'KB', 'MB', 'GB'];
    int unitIndex = 0;
    double size = bytes.toDouble();

    while (size >= 1024 && unitIndex < units.length - 1) {
      size /= 1024;
      unitIndex++;
    }

    return '${size.toStringAsFixed(2)} ${units[unitIndex]}';
  }
}
