import 'package:flutter/material.dart';

typedef InfiniteScrollBuilder = Widget Function(BuildContext, int loadedItems);

class InfiniteScrollProps {
  final LoadProps loadProps;
  final InfiniteScrollBuilder? loadingMoreBuilder;

  const InfiniteScrollProps({
    this.loadingMoreBuilder,
    this.loadProps = const LoadProps(),
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
