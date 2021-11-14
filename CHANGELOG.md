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
        - searchBoxDecoration removed: replaced by searchFieldProps
        _ autoFocusSearchBox removed : replaced by searchFieldProps
        _ searchBoxStyle removed : replaced by searchFieldProps
        _ searchBoxController removed : replaced by searchFieldProps

        - showSelectedItem replaced by showSelectedItems

## [0.6.3] - 2021.06.03
* fix analyser issues

## [0.6.2] - 2021.06.13
* prop that passes all props to search field
* fix issues [169](https://github.com/salim-lachdhaf/searchable_dropdown/issues/169)
* fix issues [163](https://github.com/salim-lachdhaf/searchable_dropdown/issues/163)
* new Feature "dropdown BaseStyle" [178](https://github.com/salim-lachdhaf/searchable_dropdown/issues/178)
* new Feature "popup scrollView"
* Ignore pointers in itemBuilder & cursor in web
* Added property to customize DropdownButton Splash Radius
* added property to set up the splash radius for clear button and for dropdown button in dropdown_search
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
* `suffixIcons` adds an ability to switch icon management through the `suffixIcon` of `InputDecoration` 

## [0.4.8] - 2020.11.20
* fix bug caused by last flutter SDK breaking changes [#69](https://github.com/salim-lachdhaf/searchable_dropdown/issues/69)
* Add a getter for the selected item
* Add a getter to check if the DropDownSearch is focused or not

## [0.4.7] - 2020.10.30
* fix bug default selectedItem [#56](https://github.com/salim-lachdhaf/searchable_dropdown/issues/56)

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
