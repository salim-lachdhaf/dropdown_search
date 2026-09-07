import 'package:dropdown_search/src/widgets/props/safe_area_props.dart';
import 'package:material_ui/material_ui.dart';

class CustomSafeArea extends StatelessWidget {
  final Widget child;
  final SafeAreaProps props;

  const CustomSafeArea({required this.child, required this.props});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: child,
      top: props.top,
      right: props.right,
      bottom: props.bottom,
      left: props.left,
      minimum: props.minimum,
      maintainBottomViewPadding: props.maintainBottomViewPadding,
    );
  }
}
