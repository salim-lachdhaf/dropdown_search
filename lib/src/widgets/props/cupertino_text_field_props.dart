import 'dart:ui' as ui show BoxHeightStyle, BoxWidthStyle;

import 'package:dropdown_search/src/properties/base_text_field_props.dart';
import 'package:dropdown_search/src/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';

///check [CupertinoTextField] properties

const Border _kDefaultRoundedBorder = Border(
  top: kCupertinoBorderSide,
  bottom: kCupertinoBorderSide,
  left: kCupertinoBorderSide,
  right: kCupertinoBorderSide,
);

const BoxDecoration _kDefaultRoundedBorderDecoration = BoxDecoration(
  color: kCupertinoTextFieldBG,
  border: _kDefaultRoundedBorder,
  borderRadius: kCupertinoBorderRadius,
);

class CupertinoTextFieldProps extends BaseTextFieldProps {
  final FocusNode? focusNode;
  final bool enableIMEPersonalizedLearning;
  final Clip clipBehavior;
  final SmartDashesType? smartDashesType;
  final SmartQuotesType? smartQuotesType;
  final EditableTextContextMenuBuilder? contextMenuBuilder;
  final BoxDecoration? decoration;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final TextDirection? textDirection;
  final bool autofocus;
  final String obscuringCharacter;
  final bool obscureText;
  final bool autocorrect;
  final bool enableSuggestions;
  final int maxLines;
  final int minLines;
  final bool expands;
  final bool readOnly;
  final bool? showCursor;
  final int? maxLength;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final List<TextInputFormatter>? inputFormatters;
  final bool enabled;
  final double cursorWidth;
  final double? cursorHeight;
  final Radius cursorRadius;
  final Color? cursorColor;
  final ui.BoxHeightStyle selectionHeightStyle;
  final ui.BoxWidthStyle selectionWidthStyle;
  final Brightness? keyboardAppearance;
  final EdgeInsets scrollPadding;
  final bool enableInteractiveSelection;
  final TextSelectionControls? selectionControls;
  final DragStartBehavior dragStartBehavior;
  final GestureTapCallback? onTap;
  final ScrollPhysics? scrollPhysics;
  final ScrollController? scrollController;
  final Iterable<String>? autofillHints;
  final String? restorationId;
  final ContentInsertionConfiguration? contentInsertionConfiguration;
  final bool cursorOpacityAnimates;
  final TextMagnifierConfiguration? magnifierConfiguration;
  final TapRegionCallback? onTapOutside;
  final bool stylusHandwritingEnabled;
  final TapRegionCallback? onTapUpOutside;
  final CrossAxisAlignment crossAxisAlignment;
  final UndoHistoryController? undoController;
  final SpellCheckConfiguration? spellCheckConfiguration;
  final ValueChanged<String>? onSelected;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onSubmitted;

  final EdgeInsetsGeometry padding;
  final OverlayVisibilityMode clearButtonMode;
  final String? clearButtonSemanticLabel;
  final Object groupId;
  final String? placeholder;
  final TextStyle? placeholderStyle;
  final Widget? prefix;
  final OverlayVisibilityMode prefixMode;
  final Widget? suffix;
  final OverlayVisibilityMode suffixMode;
  final bool? selectAllOnFocus;

  const CupertinoTextFieldProps({
    this.groupId = EditableText,
    this.padding = const EdgeInsets.all(7.0),
    this.clearButtonMode = OverlayVisibilityMode.never,
    this.clearButtonSemanticLabel,
    this.placeholder,
    this.placeholderStyle = const TextStyle(
      fontWeight: FontWeight.w400,
      color: CupertinoColors.placeholderText,
    ),
    this.prefix,
    this.prefixMode = OverlayVisibilityMode.always,
    this.suffix,
    this.suffixMode = OverlayVisibilityMode.always,
    super.controller,
    super.containerBuilder,
    this.onSubmitted,
    this.onEditingComplete,
    this.onSelected,
    this.decoration = _kDefaultRoundedBorderDecoration,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.style,
    this.strutStyle,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.textDirection,
    this.readOnly = false,
    this.contextMenuBuilder = _defaultContextMenuBuilder,
    this.showCursor,
    this.autofocus = false,
    this.obscuringCharacter = '•',
    this.obscureText = false,
    this.autocorrect = true,
    this.smartDashesType,
    this.smartQuotesType,
    this.enableSuggestions = true,
    this.maxLines = 1,
    this.minLines = 1,
    this.expands = false,
    this.maxLength,
    this.maxLengthEnforcement,
    this.inputFormatters,
    this.enabled = true,
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.cursorRadius = const Radius.circular(2.0),
    this.cursorColor,
    this.selectionHeightStyle = ui.BoxHeightStyle.tight,
    this.selectionWidthStyle = ui.BoxWidthStyle.tight,
    this.keyboardAppearance,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.dragStartBehavior = DragStartBehavior.start,
    this.enableInteractiveSelection = true,
    this.selectionControls,
    this.onTap,
    this.scrollController,
    this.scrollPhysics,
    this.autofillHints,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
    this.enableIMEPersonalizedLearning = true,
    this.focusNode,
    this.contentInsertionConfiguration,
    this.cursorOpacityAnimates = true,
    this.magnifierConfiguration,
    this.onTapOutside,
    this.spellCheckConfiguration,
    this.undoController,
    this.stylusHandwritingEnabled =
        EditableText.defaultStylusHandwritingEnabled,
    this.onTapUpOutside,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.selectAllOnFocus,
  });

  static Widget _defaultContextMenuBuilder(
      BuildContext context, EditableTextState editableTextState) {
    return CupertinoAdaptiveTextSelectionToolbar.editableText(
      editableTextState: editableTextState,
    );
  }
}
