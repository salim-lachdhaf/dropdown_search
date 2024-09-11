import 'package:flutter/material.dart';

import '../../dropdown_search.dart';

class SuggestedItemProps<T> {
  ///show or hide favorites items
  final bool showSuggestedItems;

  ///to customize favorites chips
  final FavoriteItemsBuilder<T>? suggestedItemBuilder;

  ///favorites items list
  final SuggestedItems<T>? suggestedItems;

  ///favorite items alignment
  final MainAxisAlignment suggestedItemsAlignment;

  final ClickProps itemClickProps;

  final ScrollProps scrollProps;

  const SuggestedItemProps({
    this.suggestedItemBuilder,
    this.suggestedItems,
    this.suggestedItemsAlignment = MainAxisAlignment.start,
    this.showSuggestedItems = false,
    this.itemClickProps = const ClickProps(),
    this.scrollProps = const ScrollProps(scrollDirection: Axis.horizontal),
  });
}
