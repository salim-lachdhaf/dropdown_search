import 'dart:ui' as ui show BoxHeightStyle, BoxWidthStyle;

import 'package:dropdown_search/src/properties/base_text_field_props.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///check [TextField] properties
class TextFieldProps extends BaseTextFieldProps {
  final FocusNode? focusNode;
  final bool enableIMEPersonalizedLearning;
  final Clip clipBehavior;
  final SmartDashesType? smartDashesType;
  final SmartQuotesType? smartQuotesType;
  final EditableTextContextMenuBuilder? contextMenuBuilder;
  final InputDecoration decoration;
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
  final AppPrivateCommandCallback? onAppPrivateCommand;
  final List<TextInputFormatter>? inputFormatters;
  final bool? enabled;
  final double cursorWidth;
  final double? cursorHeight;
  final Radius? cursorRadius;
  final Color? cursorColor;
  final ui.BoxHeightStyle selectionHeightStyle;
  final ui.BoxWidthStyle selectionWidthStyle;
  final Brightness? keyboardAppearance;
  final EdgeInsets scrollPadding;
  final bool enableInteractiveSelection;
  final TextSelectionControls? selectionControls;
  final DragStartBehavior dragStartBehavior;
  final GestureTapCallback? onTap;
  final MouseCursor? mouseCursor;
  final InputCounterWidgetBuilder? buildCounter;
  final ScrollPhysics? scrollPhysics;
  final ScrollController? scrollController;
  final Iterable<String>? autofillHints;
  final String? restorationId;
  final bool canRequestFocus;
  final WidgetStatesController? statesController;
  final ContentInsertionConfiguration? contentInsertionConfiguration;
  final Color? cursorErrorColor;
  final bool? cursorOpacityAnimates;
  final bool? ignorePointers;
  final TextMagnifierConfiguration? magnifierConfiguration;
  final TapRegionCallback? onTapOutside;
  final bool stylusHandwritingEnabled;
  final UndoHistoryController? undoController;
  final SpellCheckConfiguration? spellCheckConfiguration;
  final ValueChanged<String>? onSelected;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onSubmitted;
  final bool onTapAlwaysCalled;
  final Object groupId;
  final TapRegionUpCallback? onTapUpOutside;
  final bool? selectAllOnFocus;
  final List<Locale>? hintLocales;

  const TextFieldProps({
    this.groupId = EditableText,
    super.controller,
    super.containerBuilder,
    this.onSubmitted,
    this.onTapAlwaysCalled = false,
    this.onEditingComplete,
    this.onSelected,
    this.decoration = const InputDecoration(border: OutlineInputBorder()),
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
    this.onAppPrivateCommand,
    this.inputFormatters,
    this.enabled,
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorColor,
    this.selectionHeightStyle = ui.BoxHeightStyle.tight,
    this.selectionWidthStyle = ui.BoxWidthStyle.tight,
    this.keyboardAppearance,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.dragStartBehavior = DragStartBehavior.start,
    this.enableInteractiveSelection = true,
    this.selectionControls,
    this.onTap,
    this.mouseCursor,
    this.buildCounter,
    this.scrollController,
    this.scrollPhysics,
    this.autofillHints,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
    this.enableIMEPersonalizedLearning = true,
    this.focusNode,
    this.canRequestFocus = true,
    this.statesController,
    this.contentInsertionConfiguration,
    this.cursorErrorColor,
    this.cursorOpacityAnimates,
    this.ignorePointers,
    this.magnifierConfiguration,
    this.onTapOutside,
    this.stylusHandwritingEnabled = EditableText.defaultStylusHandwritingEnabled,
    this.spellCheckConfiguration,
    this.undoController,
    this.onTapUpOutside,
    this.hintLocales,
    this.selectAllOnFocus,
  });

  static Widget _defaultContextMenuBuilder(BuildContext context, EditableTextState editableTextState) {
    return AdaptiveTextSelectionToolbar.editableText(
      editableTextState: editableTextState,
    );
  }
}
