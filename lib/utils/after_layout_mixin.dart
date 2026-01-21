import 'package:flutter/widgets.dart';

mixin AfterLayoutMixin<T extends StatefulWidget> on State<T> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.endOfFrame.then(
      (_) {
        if (!mounted) {
          return;
        }
        afterFirstLayout(context);
      },
    );
  }

  void afterFirstLayout(BuildContext context);
}
