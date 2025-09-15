import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final double? size;
  final bool isTransparent;

  const Logo({
    super.key,
    this.size,
    this.isTransparent = false,
  });

  @override
  Widget build(BuildContext context) {
    return ImageView(
      isTransparent
          ? DesignSystemAssets.images.logoTransparent
          : DesignSystemAssets.images.logo,
      size: size ?? Spacing.d80,
      assetPackage: kDesignSystemPackageName,
    );
  }
}

class LogoWithName extends StatelessWidget {
  final String name;

  const LogoWithName({
    super.key,
    this.name = '',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: context.theme.primaryColor,
            shape: BoxShape.circle,
          ),
          child: ImageView(
            DesignSystemAssets.images.logoTransparent,
            size: Spacing.d64,
            assetPackage: kDesignSystemPackageName,
          ),
        ),
        Spacing.h8,
        Text.rich(
          TextSpan(
            text: 'SoFluffy',
            children: [
              TextSpan(
                text: ' $name',
                style: TextStyle(
                  color: context.theme.colorScheme.primary.withValues(
                    alpha: 0.5,
                  ),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          style: TextStyle(
            fontSize: Spacing.d36,
            color: context.theme.colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        Spacing.h16,
      ],
    );
  }
}

class LogoWithNameSmaller extends StatelessWidget {
  final String name;

  const LogoWithNameSmaller({
    super.key,
    this.name = '',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: context.theme.primaryColor,
            shape: BoxShape.circle,
          ),
          child: ImageView(
            DesignSystemAssets.images.logoTransparent,
            size: Spacing.d48,
            assetPackage: kDesignSystemPackageName,
          ),
        ),
        Spacing.h4,
        Text.rich(
          TextSpan(
            text: 'SoFluffy',
            children: [
              TextSpan(
                text: ' $name',
                style: TextStyle(
                  color: context.theme.colorScheme.primary.withValues(
                    alpha: 0.5,
                  ),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          style: TextStyle(
            fontSize: Spacing.d24,
            color: context.theme.colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        Spacing.h8,
      ],
    );
  }
}
