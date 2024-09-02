class InfiniteScrollProps {
  final int skip;
  final int take;

  const InfiniteScrollProps({
    this.skip = 0,
    this.take = 50,
  })  : assert(skip >= 0),
        assert(take > 1);

  InfiniteScrollProps copy({int? skip, int? take}) {
    return InfiniteScrollProps(skip: skip ?? this.skip, take: take ?? this.take);
  }
}
