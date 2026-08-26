import 'package:flutter/widgets.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';

class SoFluffyLogo extends StatelessWidget {
  final double? size;
  final bool isTransparent;

  const SoFluffyLogo({
    super.key,
    this.size,
    this.isTransparent = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.fluffyTheme.colors.primary,
        shape: BoxShape.circle,
      ),
      child: ImageView(
        isTransparent
            ? FluffyAssets.images.logoTransparent
            : FluffyAssets.images.logo,
        size: size ?? Spacing.d80,
        assetPackage: kSofluffyUiPackageName,
      ),
    );
  }
}

class SoFluffyLogoWithName extends StatelessWidget {
  final String name;

  const SoFluffyLogoWithName({
    super.key,
    this.name = '',
  });

  @override
  Widget build(BuildContext context) {
    final primary = context.fluffyTheme.colors.primary;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: primary,
            shape: BoxShape.circle,
          ),
          child: ImageView(
            FluffyAssets.images.logoTransparent,
            size: Spacing.d64,
            assetPackage: kSofluffyUiPackageName,
          ),
        ),
        Spacing.h8,
        Flexible(
          child: Text.rich(
            TextSpan(
              text: 'SoFluffy',
              children: [
                TextSpan(
                  text: ' $name',
                  style: TextStyle(
                    color: primary.withValues(
                      alpha: 0.5,
                    ),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            style: TextStyle(
              fontSize: Spacing.d36,
              color: primary,
              fontWeight: FontWeight.w600,
              overflow: TextOverflow.ellipsis,
            ),
            maxLines: 1,
          ),
        ),
        Spacing.h16,
      ],
    );
  }
}

class SoFluffyLogoWithNameSmaller extends StatelessWidget {
  final String name;

  const SoFluffyLogoWithNameSmaller({
    super.key,
    this.name = '',
  });

  @override
  Widget build(BuildContext context) {
    final primary = context.fluffyTheme.colors.primary;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: primary,
            shape: BoxShape.circle,
          ),
          child: ImageView(
            FluffyAssets.images.logoTransparent,
            size: Spacing.d48,
            assetPackage: kSofluffyUiPackageName,
          ),
        ),
        Spacing.h4,
        Flexible(
          child: Text.rich(
            TextSpan(
              text: 'SoFluffy',
              children: [
                TextSpan(
                  text: ' $name',
                  style: TextStyle(
                    color: primary.withValues(
                      alpha: 0.5,
                    ),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            style: TextStyle(
              fontSize: Spacing.d24,
              color: primary,
              fontWeight: FontWeight.w600,
              overflow: TextOverflow.ellipsis,
            ),
            maxLines: 1,
          ),
        ),
        Spacing.h8,
      ],
    );
  }
}
