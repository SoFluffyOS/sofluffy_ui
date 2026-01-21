import 'package:flutter/widgets.dart';

class MultiStreamBuilder<T> extends StatelessWidget {
  final List<Stream<T>> streams;
  final Widget Function(BuildContext, List<T?>) builder;

  const MultiStreamBuilder({
    super.key,
    required this.streams,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return _buildStreamBuilders(context, 0, []);
  }

  Widget _buildStreamBuilders(
    BuildContext context,
    int index,
    List<T?> snapshotData,
  ) {
    if (index >= streams.length) {
      // All streams have been built, call the builder with collected data
      return builder(context, snapshotData);
    }

    return StreamBuilder<T>(
      stream: streams[index],
      builder: (context, snapshot) {
        final updatedData = List<T?>.from(snapshotData)..add(snapshot.data);
        return _buildStreamBuilders(context, index + 1, updatedData);
      },
    );
  }
}
