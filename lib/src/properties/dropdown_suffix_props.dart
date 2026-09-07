import 'package:dropdown_search/dropdown_search.dart';
import 'package:material_ui/material_ui.dart';

class DropdownSuffixProps {
  final ClearButtonProps? clearButtonProps;
  final DropdownButtonProps? dropdownButtonProps;
  final TextDirection? direction;

  const DropdownSuffixProps({
    this.clearButtonProps,
    this.dropdownButtonProps,
    this.direction,
  });
}
