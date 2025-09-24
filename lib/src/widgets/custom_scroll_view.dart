import 'package:dropdown_search/src/widgets/props/scroll_props.dart';
import 'package:flutter/material.dart';

class CustomSingleScrollView extends StatelessWidget {
  final ScrollProps scrollProps;
  final Widget child;

  const CustomSingleScrollView({
    super.key,
    this.scrollProps = const ScrollProps(),
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollProps.controller,
      padding: scrollProps.padding,
      clipBehavior: scrollProps.clipBehavior,
      dragStartBehavior: scrollProps.dragStartBehavior,
      hitTestBehavior: scrollProps.hitTestBehavior,
      keyboardDismissBehavior: scrollProps.keyboardDismissBehavior,
      physics: scrollProps.physics,
      scrollDirection: Axis.vertical,
      reverse: scrollProps.reverse,
      primary: scrollProps.primary,
      restorationId: scrollProps.restorationId,
      child: child,
    );
  }
}
