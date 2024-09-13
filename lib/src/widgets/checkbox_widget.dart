import 'package:dropdown_search/dropdown_search.dart';
import 'package:dropdown_search/src/widgets/custom_inkwell.dart';
import 'package:flutter/material.dart';

typedef WidgetCheckBox = Widget Function(BuildContext context, bool isChecked);

class CheckBoxWidget extends StatefulWidget {
  final ClickProps clickProps;
  final WidgetCheckBox? layout;
  final WidgetCheckBox? checkBox;
  final bool isChecked;
  final bool isDisabled;
  final ValueChanged<bool?>? onChanged;
  final bool interceptCallBacks;
  final TextDirection textDirection;

  CheckBoxWidget({
    super.key,
    required this.clickProps,
    this.isChecked = false,
    this.isDisabled = false,
    this.layout,
    this.checkBox,
    this.interceptCallBacks = false,
    this.textDirection = TextDirection.ltr,
    required this.onChanged,
  });

  @override
  State<CheckBoxWidget> createState() => _CheckBoxWidgetState();
}

class _CheckBoxWidgetState extends State<CheckBoxWidget> {
  final ValueNotifier<bool> isCheckedNotifier = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    isCheckedNotifier.value = widget.isChecked;
  }

  @override
  void didUpdateWidget(covariant CheckBoxWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isChecked != oldWidget.isChecked) {
      isCheckedNotifier.value = widget.isChecked;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: widget.textDirection,
      child: ValueListenableBuilder(
        valueListenable: isCheckedNotifier,
        builder: (ctx, bool v, w) {
          var w = Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              widget.layout != null ? Expanded(child: widget.layout!(context, v == true)) : SizedBox.shrink(),
              widget.checkBox != null
                  ? widget.checkBox!(context, v == true)
                  : Checkbox(value: v, onChanged: widget.isDisabled ? null : (b) {}),
            ],
          );

          if (widget.interceptCallBacks) {
            return w;
          } else {
            return CustomInkWell(
              clickProps: widget.clickProps,
              onTap: widget.isDisabled
                  ? null
                  : () {
                      isCheckedNotifier.value = !v;
                      if (widget.onChanged != null) widget.onChanged!(v);
                    },
              child: IgnorePointer(child: ExcludeFocus(child: w)),
            );
          }
        },
      ),
    );
  }
}
