import 'package:flutter/material.dart';

class HoverBuilder extends StatefulWidget {
  const HoverBuilder({
    required this.builder,
    super.key,
  });

  final Widget Function(BuildContext context, bool isHovered) builder;

  @override
  HoverBuilderState createState() => HoverBuilderState();
}

class HoverBuilderState extends State<HoverBuilder> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => _onHoverChanged(enabled: true),
      onExit: (event) => _onHoverChanged(enabled: false),
      child: widget.builder(context, _isHovered),
    );
  }

  void _onHoverChanged({required bool enabled}) {
    setState(() {
      _isHovered = enabled;
    });
  }
}