import 'package:flutter/material.dart';

import '../../dropdown_search.dart';

class InfiniteScrollProps {
  final int skip;
  final int take;

  const InfiniteScrollProps({
    this.skip = 0,
    this.take = 50,
  })  : assert(skip >= 0),
        assert(take > 1);
}
