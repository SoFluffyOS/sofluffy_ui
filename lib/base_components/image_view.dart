import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

class ImageView extends StatelessWidget {
  final dynamic data;
  final String? blurHash;

  final double? size;
  final double? width;
  final double? height;

  final BoxFit? fit;
  final Alignment? alignment;

  final Color? color;

  final String? assetPackage;

  const ImageView(
    this.data, {
    super.key,
    this.size,
    this.width,
    this.height,
    this.fit,
    this.alignment,
    this.color,
    this.blurHash,
    this.assetPackage = 'icons',
  });

  @override
  Widget build(BuildContext context) {
    final url = data;

    if (url is! String) {
      return SizedBox(
        width: size ?? width,
        height: size ?? height,
        child: Shimmer.fromColors(
          baseColor: FluffyColors.shimmerBaseLight,
          highlightColor: FluffyColors.shimmerHighlightLight,
          child: Container(
            color: FluffyColors.white,
          ),
        ),
      );
    }

    if (url.isEmpty) {
      final isDark = context.isDark;
      return SizedBox(
        width: size ?? width,
        height: size ?? height,
        child: Shimmer.fromColors(
          baseColor: isDark
              ? FluffyColors.shimmerBaseDark
              : FluffyColors.shimmerBaseLight,
          highlightColor: isDark
              ? FluffyColors.shimmerHighlightDark
              : FluffyColors.shimmerHighlightLight,
          child: Container(
            color: FluffyColors.white,
          ),
        ),
      );
    }

    if (url.startsWith('/') && !kIsWeb) {
      return Image.file(
        File(url),
        width: size ?? width,
        height: size ?? height,
        fit: fit,
        alignment: alignment ?? Alignment.center,
        color: color,
        errorBuilder: (context, error, stackTrace) => const SizedBox(),
      );
    }

    if (url.startsWith('assets/')) {
      if (url.endsWith('.svg')) {
        return SvgPicture.asset(
          url,
          width: size ?? width,
          height: size ?? height,
          fit: fit ?? BoxFit.cover,
          alignment: alignment ?? Alignment.center,
          colorFilter: color != null
              ? ColorFilter.mode(
                  color!,
                  BlendMode.srcIn,
                )
              : null,
          package: assetPackage,
        );
      }

      return Image.asset(
        url,
        width: size ?? width,
        height: size ?? height,
        fit: fit ?? BoxFit.cover,
        alignment: alignment ?? Alignment.center,
        color: color,
        package: assetPackage,
        errorBuilder: (context, error, stackTrace) => const SizedBox(),
      );
    }

    if (url.endsWith('.svg')) {
      return SvgPicture.network(
        url,
        width: size ?? width,
        height: size ?? height,
        fit: fit ?? BoxFit.cover,
        alignment: alignment ?? Alignment.center,
        colorFilter: color != null
            ? ColorFilter.mode(
                color!,
                BlendMode.srcIn,
              )
            : null,
      );
    }

    return Image.network(
      url,
      width: size ?? width,
      height: size ?? height,
      fit: fit ?? BoxFit.cover,
      alignment: alignment ?? Alignment.center,
      color: color,
      errorBuilder: (context, error, stackTrace) => const SizedBox(),
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }

        return SizedBox(
          width: size ?? width,
          height: size ?? height,
          child: Shimmer.fromColors(
            baseColor: FluffyColors.shimmerBaseLight,
            highlightColor: FluffyColors.shimmerHighlightLight,
            child: Container(
              color: FluffyColors.white,
            ),
          ),
        );
      },
    );
  }
}
