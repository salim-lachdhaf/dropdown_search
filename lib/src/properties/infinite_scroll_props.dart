import 'package:material_ui/material_ui.dart';

typedef InfiniteScrollBuilder = Widget Function(BuildContext, int loadedItems);
typedef LoadingMoreErrorBuilder = Widget Function(BuildContext context,
    String searchEntry, dynamic exception, LoadProps loadProps);

class InfiniteScrollProps {
  final LoadProps loadProps;
  final InfiniteScrollBuilder? loadingMoreBuilder;
  final LoadingMoreErrorBuilder? errorBuilder;

  const InfiniteScrollProps({
    this.loadingMoreBuilder,
    this.loadProps = const LoadProps(),
    this.errorBuilder,
  });
}

class LoadProps {
  final int skip;
  final int take;

  const LoadProps({
    this.skip = 0,
    this.take = 50,
  })  : assert(skip >= 0),
        assert(take > 1);

  LoadProps copy({int? skip, int? take}) {
    return LoadProps(skip: skip ?? this.skip, take: take ?? this.take);
  }
}
