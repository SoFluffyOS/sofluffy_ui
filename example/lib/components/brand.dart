import 'package:flutter/widgets.dart';
import 'package:sofluffy_ui/sofluffy_ui.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'SoFluffyLogo', type: SoFluffyLogo, path: '[Brand]')
Widget logoUseCase(BuildContext context) {
  final size = context.knobs.double.slider(
    label: 'Logo Size',
    initialValue: 80.0,
    min: 32.0,
    max: 160.0,
  );
  final isTransparent = context.knobs.boolean(
    label: 'Transparent Asset',
    initialValue: false,
  );

  return Center(
    child: SoFluffyLogo(
      size: size,
      isTransparent: isTransparent,
    ),
  );
}

@UseCase(
  name: 'SoFluffyLogoWithName',
  type: SoFluffyLogoWithName,
  path: '[Brand]',
)
Widget logoWithNameUseCase(BuildContext context) {
  final name = context.knobs.string(
    label: 'Brand Title',
    initialValue: 'SoFluffy UI',
  );

  return Center(
    child: SoFluffyLogoWithName(
      name: name,
    ),
  );
}
