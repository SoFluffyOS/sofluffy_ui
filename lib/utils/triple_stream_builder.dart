import 'package:flutter/widgets.dart';

class TripleStreamBuilder<T1, T2, T3> extends StatelessWidget {
  final (Stream<T1>, Stream<T2>, Stream<T3>) streams;
  final Function(BuildContext, (T1?, T2?, T3?)) builder;

  const TripleStreamBuilder({
    super.key,
    required this.streams,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    final (stream1, stream2, stream3) = streams;
    return StreamBuilder<T1>(
      stream: stream1,
      builder: (context, snapshot1) {
        return StreamBuilder<T2>(
          stream: stream2,
          builder: (context, snapshot2) {
            return StreamBuilder<T3>(
              stream: stream3,
              builder: (context, snapshot3) {
                return builder(context, (
                  snapshot1.data,
                  snapshot2.data,
                  snapshot3.data,
                ));
              },
            );
          },
        );
      },
    );
  }
}
