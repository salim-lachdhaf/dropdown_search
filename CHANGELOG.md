## [7.0.0-pre4] - 2024.02.16
* #### New Feature:
  * Add adaptive platform Ui feature: `Material`, `Cupertino` and `Adaptive`
  * Add `autocomplete` new popup mode
  * add `transitionBuilder`, `transitionDuration`, `reverseTransitionDuration` to `menuProps`

    ```dart
      transitionDuration: Duration(milliseconds: 500),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      }
    ```
    
  * add new property `animationBuilder` to `DropdownButtonProps`, examples of uses
   ```dart
      /* Example 1: animation with only one icon ("iconClosed") like rotation */
      animationBuilder: (child, isOpen) {
        return AnimatedRotation(
          turns: isOpen ? .5 : 0,
          duration: Duration(milliseconds: 400),
          child: child,
        );
      }
    ```

    ```dart
      /* Example 2 : animation with two icons like switch */
      dropdownButtonProps: DropdownButtonProps(
        iconClosed: Icon(Icons.arrow_drop_down),
        iconOpened: Icon(Icons.arrow_drop_up),
        animationBuilder: (child, isOpen) {
          return AnimatedSwitcher(
            switchOutCurve: Curves.easeIn,
            switchInCurve: Curves.easeIn,
            duration: Duration(milliseconds: 400),
            child: child,
          );
        },
      )
    ```
  * add new property `layoutDelegate` to `MenuProps` and `CupertinoMenuProps`, you can extend
    [`SingleChildLayoutDelegate`](https://api.flutter.dev/flutter/rendering/SingleChildLayoutDelegate-class.html)
    to create your own positioning strategy
     
    example of use
    ```dart
      layoutDelegate: (context, padding, position) => _PopupMenuRouteLayout(context, position)
    
      class _PopupMenuRouteLayout extends SingleChildLayoutDelegate {
        final RelativeRect position;
        final BuildContext context;
    
        const _PopupMenuRouteLayout(this.context, this.position);
    
      @override
      BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
        // pick any properties from the context to calculate proper constraints
        final mediaQuery = MediaQuery.of(context);
        final keyBoardHeight = mediaQuery.viewInsets.bottom;
        final safeArea = mediaQuery.padding;
    
        return BoxConstraints(/* calculate new constraints based on your needs */);
      }
    
        @override
        Offset getPositionForChild(Size size, Size childSize) {
          // The position where the child should be placed.
        }
    
        @override
        bool shouldRelayout(covariant SingleChildLayoutDelegate oldDelegate) => false;
      }
    ``` 
  * add `SuggestionsProps` to `popupProps`
  * add `builder` property for `SuggestionsProps` to override the hole suggestion widget
  * add properties to `scrollView` and `wrap` widget for selected items in multiSelection mode
  * `Chips` are fully customizable in multiSelection and suggestions
  * replace `padding` in `searchFieldProps` with `containerBuilder`
  * add `onDisplayed` callback to `popupProps`
  * add `errorBuilder` for `InfiniteScrollProps`
  * add possibility to reload item using `myGlobalKey.currentState?.reloadItems(String filter)` or `myGlobalKey.currentState?.loadMoreItems(String filter, int skip)`
  * add `textProps` to have an ability to pass default text props through the context to `selectedItem` 
  * add new property for TextFieldProps
  * add the ability to listen to focus changes using `onFocusChange`
  * add new callbacks `onBeforeClear` and `onClear` to handle dropdown clear button action
  
* #### Breaking changes
  * change `onChanged` to `onSelected`
  * `PopupPropsMultiSelection` changed to `MultiSelectionPopupProps` 
  * `suggestedItemsProps` is placed inside `SuggestionsProps`
  * `Semantics` is removed from searchBox, to add it use `containerBuilder` like this you have full access to Semantic properties.

* #### Fix bugs:
  * `BottomSheet` background color [726](https://github.com/salim-lachdhaf/searchable_dropdown/issues/726)

## [6.0.1] - 2024.09.21
* #### New Feature:
  * add `Semantics` to searchBox to support voiceOver/TalkBack ...
 
* #### Fix bugs:
  * duplicated GlobalKey issue [672](https://github.com/salim-lachdhaf/searchable_dropdown/issues/672)
  * multiSelection chips height issue [602](https://github.com/salim-lachdhaf/searchable_dropdown/issues/602)
  * hint and dropdownBuilder issue [515](https://github.com/salim-lachdhaf/searchable_dropdown/issues/515)


## [6.0.0] - 2024.09.14

* #### New features:
    * infinite list / lazy loading
    * add click properties to the dropdown
    * add custom mode
    * dropdown button can be changed depending on state (opened/closed)
    * add property `cacheItems` for popupProps
    * add property `onItemLoaded`
    * adding new properties for a lot of widget (scrollBar, modal, bottomSheet,...)
    * add to possibility to change position of ```clearButton``` and ```dropdownButton```
      using ```direction``` property

* #### Breaking changes :
    * `AsyncItems` and `items` are replaced by `items:(filter, infiniteScrollProps)`
    * Add `isDisabled` to `itemBuilder` params
    * `FavoriteItems` renamed to `SuggestedItems`
    * `isFilterOnline` renamed to `disableFilter`
    * `selectionWidget` renamed to `checkBoxBuilder`
    * `dropdownDecoratorProps` renamed to `decoratorProps`
    * `clearButtonProps` and `dropdownButtonProps` are placed to `suffixProps`
* #### Fix bugs:
    * Search delay issue [542](https://github.com/salim-lachdhaf/searchable_dropdown/issues/542),
    * Multiselection triggers didChange
      issue [668](https://github.com/salim-lachdhaf/searchable_dropdown/issues/668),
    * ModalBottomSheet Keyboard
      issue [650](https://github.com/salim-lachdhaf/searchable_dropdown/issues/650),
    * ScrollBar padding top
      issue [512](https://github.com/salim-lachdhaf/searchable_dropdown/issues/512)
    * Disabled color issue [553](https://github.com/salim-lachdhaf/searchable_dropdown/issues/553)
    * MultiSelection overflow
      issue [526](https://github.com/salim-lachdhaf/searchable_dropdown/issues/526)
    * Popup does not close after dropdown dispose
      issue [554](https://github.com/salim-lachdhaf/searchable_dropdown/issues/554)
    * Suffix space issue [670](https://github.com/salim-lachdhaf/searchable_dropdown/issues/670)

## [5.0.6] - 2023.02.26

* Fix bugs
    * [542](https://github.com/salim-lachdhaf/searchable_dropdown/issues/542)
    * [485](https://github.com/salim-lachdhaf/searchable_dropdown/issues/485)
* fix lint errors
* add 'textDirection' in multiSelection mode to handle checkbox alignment
* add useSafeArea for modal

* ## [5.0.5] - 2022.12.05
* Fix analysis warning and formatting issues

## [5.0.4] - 2022.12.05

* Fix
  bugs: [510](https://github.com/salim-lachdhaf/searchable_dropdown/issues/510), [439](https://github.com/salim-lachdhaf/searchable_dropdown/issues/439), [513](https://github.com/salim-lachdhaf/searchable_dropdown/issues/513), [514](https://github.com/salim-lachdhaf/searchable_dropdown/issues/514)
* add new properties to dropdownButton and clearDropdownButton: 'style', 'isSelected', '
  selectedIcon', 'onPressed'

## [5.0.3] - 2022.09.22

* Fix bugs
* update Readme file

## [5.0.2] - 2022.06.04

* add `interceptCallBacks` for popupProps

## [5.0.1] - 2022.05.29

* Fix code format

## [5.0.0] - 2022.05.29

* Replace ScrollBar with RawScrollBar (adding new properties)
* move ``showClearButton`` into ``ClearButtonProps``
* move all dropdownDecoration props into ``dropdownDecoratorProps``
* replace ``IconButtonProps`` with DropdownButtonProps and ``ClearButtonProps`` for ``clearButtonProps``
  and dropdownButtonProps
* add a full custom container for the pop `containerBuilder` to ``popup_props``
* add `isVisible` prop to `DropdownButtonProps`
* change `validationMultiSelectionWidget` to `validationWidgetBuilder`

## [4.0.1] - 2022.05.17

* fix fit issue in single Selection mode
* fix isOnlineFilter issue

## [4.0.0] - 2022.05.16

* Breaking changes:
    - onFind to AsyncItem
    - isFilteredOnline to isFilterOnline
    - replace all popup customization with popupProps
    - change default mode to MENU
    - remove 'dropdownBuilderSupportsNullItem' because now we support nullSafety
    - remove safeArea settings, the popup should always shown in safeArea

* update readme.md
* improve menu mode
* improve dialog mode
* fix large text in chips in multiSelection mode
* fix bug [84](https://github.com/salim-lachdhaf/searchable_dropdown/issues/84)
* add new mode BOTTOM_SHEET
* support Flutter v3

## [3.0.1] - 2022.04.15

* breaking changes:
    - remove `hint` and `label` properties, use `dropdownSearchDecoration` instead
    - remove `showAsSuffixIcons` property, now always are as suffixIcon
    - replace '`clearButtonSplashRadius`' and '`clearButtonBuilder`' into one property '`IconButtonProps`'
    - replace '`dropdownButtonSplashRadius`' and '`dropdownButtonBuilder`' into one property '
      `IconButtonProps`'
* fix issue [380](https://github.com/salim-lachdhaf/searchable_dropdown/issues/380)

## [2.0.1] - 2021.11.15

* improve performance
* add "popupCustomMultiSelectionWidget" option

## [2.0.0]

* fix bug [284](https://github.com/salim-lachdhaf/searchable_dropdown/issues/284)
* breaking changes
    - add "isSelected" option to FavoriteItemsBuilder
    - change onChange to onChanged in multiSelection mode

## [1.0.4] - 2021.10.17

* fix some bugs

## [1.0.3] - 2021.10.02

* new feature : change searchBox query programmatically using EditTextController
* fix some bugs

## [1.0.0] - 2021.09.08

* new feature : multiSelection mode
* breaking changes :
    - searchBoxDecoration removed: replaced by searchFieldProps _ autoFocusSearchBox removed :
      replaced by searchFieldProps _ searchBoxStyle removed : replaced by searchFieldProps _
      searchBoxController removed : replaced by searchFieldProps

          - showSelectedItem replaced by showSelectedItems

## [0.6.3] - 2021.06.03

* fix analyser issues

## [0.6.2] - 2021.06.13

* prop that passes all props to search field
* fix issues [169](https://github.com/salim-lachdhaf/searchable_dropdown/issues/169)
* fix issues [163](https://github.com/salim-lachdhaf/searchable_dropdown/issues/163)
* new Feature "dropdown
  BaseStyle" [178](https://github.com/salim-lachdhaf/searchable_dropdown/issues/178)
* new Feature "popup scrollView"
* Ignore pointers in itemBuilder & cursor in web
* Added property to customize DropdownButton Splash Radius
* added property to set up the splash radius for clear button and for dropdown button in
  dropdown_search
* @thanks [Vasiliy](https://github.com/vasilich6107)

## [0.6.1] - 2021.05.02

* added property to set up the popup safe area
* fixed `null safety` issues

## [0.6.0] - 2021.03.27

* fixed `null safety` issues after initial migration
* migrated example to `null safety`
* allowed `http` traffic for Android to make async requests work

## [0.5.0] - 2021.03.23

* Migrating to null-safety @thx [nizarhdt](https://github.com/nizarhdt)
* add new feature: favorites items @thx [nizarhdt](https://github.com/nizarhdt)
* fix bugs

## [0.4.9] - 2021.02.22

* fix bug filterOnline [#116](https://github.com/salim-lachdhaf/searchable_dropdown/issues/116)
* Add onBeforeChange CallBack @thanks [Vasiliy](https://github.com/vasilich6107)
* Add onPopupDismiss CallBack @thanks [Vasiliy](https://github.com/vasilich6107)
* search delay feature @thanks [Vasiliy](https://github.com/vasilich6107)
* BottomSheet scrolling behavior improvement @thanks [Vasiliy](https://github.com/vasilich6107)
* fix bug update selectedItem
* added an ability to override the clear and dropdown icon buttons with builder
* `suffixIcons` adds an ability to switch icon management through the `suffixIcon`
  of `InputDecoration`

## [0.4.8] - 2020.11.20

* fix bug caused by last flutter SDK breaking
  changes [#69](https://github.com/salim-lachdhaf/searchable_dropdown/issues/69)
* Add a getter for the selected item
* Add a getter to check if the DropDownSearch is focused or not

## [0.4.7] - 2020.10.30

* fix bug default
  selectedItem [#56](https://github.com/salim-lachdhaf/searchable_dropdown/issues/56)

## [0.4.6] - 2020.10.30

* Invoke the dropdown programmatically
* change dropdownSearch selected value programmatically
* fix issue [#25](https://github.com/salim-lachdhaf/searchable_dropdown/issues/25)
* fix issue [#36](https://github.com/salim-lachdhaf/searchable_dropdown/issues/36)
* fix issue [#51](https://github.com/salim-lachdhaf/searchable_dropdown/issues/51)
* fix issue [#55](https://github.com/salim-lachdhaf/searchable_dropdown/issues/55)

## [0.4.5] - 2020.10.21

* replace autoValidate by autoValidateMode
* pass searchWord to loadingBuilder/emptyBuilder/errorBuilder
* add searchBoxController to be used as default filter for example

## [0.4.4] - 2020.07.06

* fix bug

## [0.4.3] - 2020.06.04

* remove `dropDownSearchDecoration` duplication
* add `popupBarrierColor` feature

## [0.4.2] - 2020.05.23

* add `popupItemDisabled` feature, to manage popupItems accessibility

## [0.4.1] - 2020.05.17

* handle dark and light theme
* handle dropdownBuilder if item is Null

## [0.4.0] - 2020.05.15

* add dropdown icon customization
* add clear button icon customization

## [0.3.9] - 2020.05.12

* manage default border color

## [0.3.8] - 2020.05.11

* fix issue: default selected item

## [0.3.7] - 2020.05.10

* update description

## [0.3.6] - 2020.05.10

* update description

## [0.3.5] - 2020.05.10

* fix issue

## [0.3.4] - 2020.05.10

* Integrate material design
* make DropdownSearch as item of a form
* manage validation form

## [0.3.4] - 2020.05.01

* fix bug error widget

## [0.3.2] - 2020.05.01

* add autoFocus searchBox feature

## [0.3.1] - 2020.04.29

* fix bug: filter items
* fix menu mode background color

## [0.3.0] - 2020.04.29

* fix bug: empty items online

## [0.2.9] - 2020.04.29

# Added callbacks

* emptyBuilder
* loadingBuilder
* errorBuilder

# Improvement

* improve Menu mode
* improve bottomSheet mode

## [0.2.8] - 2020.04.24

* minor improvement

## [0.2.7] - 2020.04.24

* minor improvement

## [0.2.6] - 2020.04.23

* Health suggestions

## [0.2.5] - 2020.04.23

* Add showSelected option

## [0.2.4] - 2020.04.14

* Improve performance

## [0.2.3] - 2020.04.13

* Improve performance

## [0.2.2] - 2020.04.13

* BugFix

## [0.2.1] - 2020.04.01

* BugFix

## [0.2.0] - 2020.04.01

* Update README.md

## [0.1.9] - 2020.04.01

* Update README.md

## [0.1.8] - 2020.04.01

* Add catch error
* Add Feature : Filter Function as parameter
* Add Feature : enable/disable
* Add Feature : add three mode : Menu, BottomSheet and Dialog
* Add Feature : manageable height

## [0.1.7] - 2020.03.29

* Bug fix

## [0.1.6] - 2020.03.29

* Bug fix

## [0.1.5] - 2020.03.29

* Replace Stream by valueNotifier

## [0.1.4] - 2020.03.29

* Replace Stream by valueNotifier

## [0.1.3] - 2020.03.28

* possibility to load filter online once

## [0.1.2] - 2020.03.27

* improve performance

## [0.1.1] - 2020.03.26

* bloc bug fix

## [0.1.0] - 2020.03.25

* bug fix publication

## [0.0.1] - 2020.03.24

* First publication
