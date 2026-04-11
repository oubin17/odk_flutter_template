// dart format width=120

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/widgets.dart';

class $LibGen {
  const $LibGen();

  /// Directory path: lib/config
  $LibConfigGen get config => const $LibConfigGen();
}

class $AssetsLauncherIconGen {
  const $AssetsLauncherIconGen();

  /// File path: assets/launcher_icon/launcher.png
  AssetGenImage get launcher => const AssetGenImage('assets/launcher_icon/launcher.png');

  /// List of all assets
  List<AssetGenImage> get values => [launcher];
}

class $AssetsLoginGen {
  const $AssetsLoginGen();

  /// File path: assets/login/login_regist.jpg
  AssetGenImage get loginRegist => const AssetGenImage('assets/login/login_regist.jpg');

  /// List of all assets
  List<AssetGenImage> get values => [loginRegist];
}

class $AssetsProfileGen {
  const $AssetsProfileGen();

  /// File path: assets/profile/admin.jpg
  AssetGenImage get admin => const AssetGenImage('assets/profile/admin.jpg');

  /// File path: assets/profile/employee.jpg
  AssetGenImage get employee => const AssetGenImage('assets/profile/employee.jpg');

  /// List of all assets
  List<AssetGenImage> get values => [admin, employee];
}

class $AssetsSplashGen {
  const $AssetsSplashGen();

  /// File path: assets/splash/splash.jpg
  AssetGenImage get splash => const AssetGenImage('assets/splash/splash.jpg');

  /// List of all assets
  List<AssetGenImage> get values => [splash];
}

class $AssetsVectorsGen {
  const $AssetsVectorsGen();

  /// File path: assets/vectors/logo.svg
  String get logo => 'assets/vectors/logo.svg';

  /// List of all assets
  List<String> get values => [logo];
}

class $LibConfigGen {
  const $LibConfigGen();

  /// Directory path: lib/config/keys
  $LibConfigKeysGen get keys => const $LibConfigKeysGen();
}

class $LibConfigKeysGen {
  const $LibConfigKeysGen();

  /// File path: lib/config/keys/public_key.pem
  String get publicKey => 'lib/config/keys/public_key.pem';

  /// List of all assets
  List<String> get values => [publicKey];
}

class Assets {
  const Assets._();

  static const $AssetsLauncherIconGen launcherIcon = $AssetsLauncherIconGen();
  static const $AssetsLoginGen login = $AssetsLoginGen();
  static const AssetGenImage logo = AssetGenImage('assets/logo.jpg');
  static const $AssetsProfileGen profile = $AssetsProfileGen();
  static const $AssetsSplashGen splash = $AssetsSplashGen();
  static const $AssetsVectorsGen vectors = $AssetsVectorsGen();
  static const $LibGen lib = $LibGen();

  /// List of all assets
  static List<AssetGenImage> get values => [logo];
}

class AssetGenImage {
  const AssetGenImage(this._assetName, {this.size, this.flavors = const {}, this.animation});

  final String _assetName;

  final Size? size;
  final Set<String> flavors;
  final AssetGenImageAnimation? animation;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class AssetGenImageAnimation {
  const AssetGenImageAnimation({required this.isAnimation, required this.duration, required this.frames});

  final bool isAnimation;
  final Duration duration;
  final int frames;
}
