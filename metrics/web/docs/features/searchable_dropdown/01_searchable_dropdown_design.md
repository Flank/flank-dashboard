# Searchable dropdown design

## TL;DR

A `Searchable Dropdown` is a UI component that allows the user to search and select the items from the specific list of items. We can utilize the `Searchable Dropdown` instead of a regular `Dropdown` if the list is quite long, making it easier for the end-user to interact with the app, as he or she can start typing their request and immediately see all matching options.

## Metrics Web Application

To create a reusable and customizable widget, we should implement the base `SearchableDropdown` widget, that is then can be used for module-specific widget implementation. For that, we should use the [`selection_menu` package](https://pub.dev/packages/selection_menu), as it provides highly customizable components. Consider the following sub-section describing the `Selection Menu` package and its components needed to build the `SearchableDropdown` widget. 

### Selection Menu Package

The main widget this package provides is a highly customizable `SelectionMenu<T>` widget. The `SelectionMenu<T>` widget is separated into parts called `Components`. Each `Component` stands for a specific part of a `SelectionMenu<T>` widget, e.g. the `ListViewComponent` defines a list for items within the dropdown. The `Components` are provided with the [`ComponentsConfiguration` class](https://pub.dev/documentation/selection_menu/latest/components_configurations/ComponentsConfiguration-class.html).

Here is a table of main `SelectionMenu` components we should use to implement the `SearchableDropdown` widget:

Component | Description | Link
----------| ----------- | -----
`TriggerComponent` | Defines a trigger that opens the dropdown. | [API documentation](https://pub.dev/documentation/selection_menu/latest/components_configurations/TriggerComponent-class.html)
`MenuPositionAndSizeComponent`| Defines dropdown's position, size, and constraints. | [API documentation](https://pub.dev/documentation/selection_menu/latest/components_configurations/MenuPositionAndSizeComponent-class.html)
`AnimationComponent` | Defines a container for the dropdown. | [API documentation](https://pub.dev/documentation/selection_menu/latest/components_configurations/AnimationComponent-class.html)
`ListViewComponent` | Defines a scrollable list of items within the dropdown. | [API documentation](https://pub.dev/documentation/selection_menu/latest/components_configurations/ListViewComponent-class.html)

### Base Widget

Now, let's implement the `base` `SearchableDropdown` widget. Here is a [document](https://github.com/Flank/flank-dashboard/blob/master/metrics/web/docs/03_widget_structure_organization.md) that describes widget implementation in the Metrics Web Application.

Consider the following class diagram that describes the `SearchableDropdown` widget structure
and how it interacts with the `selection_menu` package.  
![Widget class diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/Flank/flank-dashboard/raw/master/metrics/web/docs/features/searchable_dropdown/diagrams/searchable_dropdown_widget_class_diagram.puml)

Consider the following table that describes each `SearchableDropdown` field:

Parameter | Type | Description                                                          
--------- | ---- | -----------
`searchBarBuilder` | `SearchBarBuilder` | A builder for a search bar.                  
`dropdownMenuBuilder` | `DropdownMenuBuilder` | A builder for a dropdown menu that is a container for items to display.                 
`itemBuilder` | `DropdownItemBuilder` | A builder for an item within the `Dropdown` that represents a single search match. 
`dropdownMenuController` | `SelectionMenuController` | A controller that allows triggering the dropdown's menu to open or close.
`onDropdownMenuStateChanged` | `ValueChanged<MenuState>` | A callback that is called when the dropdown menu state changed, e.g. the dropdown menu closes or opens.
`items` | `List<T>` | A list of items to display. 
`maxVisibleItems` | `int` | A number of visible search items.
`onItemSelected` | `VoidCallback` | A callback that is called when an item is selected.
`itemHeight` | `double` | A height of a single item in a dropdown.
`searchBarPadding` | `EdgeInsets` | A padding of a search bar.
`dropdownPadding` | `EdgeInsets` | A padding of a dropdown.
`closeDropdownOnTapOutside` | `bool` | Indicates whether to close the dropdown on tap outside.

### `ProjectGroupsSearchableDropdown`
After the base widget is implemented, let's examine the utilization of the newly created `SearchableDropdown` widget to implement, for example, the `ProjectGroupsSearchableDropdown` widget and its custom behaviour.

#### Managing Dropdown menu state

To be able to easily open or close the Dropdown component programmatically, we need to define the `dropdownController` within this widget and to track the current state of the Dropdown. Consider the following code that illustrates it

``` dart
/// Keeps the current state of the dropdown menu. Initially is closed.
MenuState _dropdownMenuState = MenuState.closed;

/// Opens or closes the dropdown menu.
final SelectionMenuController _dropdownMenuController = SelectionMenuController();

@override
Widget build(BuildContext context) {
    return SearchableDropdown(
        dropdownMenuController: _dropdownMenuController,
        onDropdownMenuStateChanged: (state) => _dropdownMenuState = state,
    );
}

/// Opens menu.
void _openMenu() {
    if(_dropdownMenuState != MenuState.closed) return;

    _dropdownMenuController.trigger();
}

/// Closes menu.
void _closeMenu() {
    if(_dropdownMenuState != MenuState.opened) return;

    _dropdownMenuController.trigger();
}
```

#### Search Bar Component Focus Management

The `Search Bar Component` will be built using the [MetricsTextFormField widget](https://github.com/Flank/flank-dashboard/blob/master/metrics/web/lib/common/presentation/widgets/metrics_text_form_field.dart). Currently, it lacks some functionality to control the focus behaviour of this field. So, we should add a `focusNode` parameter to the `MetricsTextFormField` widget.

First of all, we need to open the `Dropdown Menu` and select all text when we focus the `Search Bar` and close the `Dropdown Menu` when the `Search Bar` unfocuses. To do that, let's create a `FocusNode`, pass it to the `Search Bar` and track its state changes. For the text selection feature, we should pass a `TextEditingController` to the `Search Bar`. Consider the following code example:

``` dart
/// A [FocusNode] of the [MetricsTextFormField] within the search component.
FocusNode _searchBarFocusNode;

/// A [TextEditingController] of the [MetricsTextFormField] within the search component.
final _searchBarTextController = TextEditingController();

@override
void initState() {
    _searchBarFocusNode = FocusNode();
    _searchBarFocusNode.addListener(_searchBarFocusNodeListener);
}

@override
Widget build(BuildContext context) {
    return SearchableDropdown(
        searchBarBuilder: (_) {
            return MetricsTextFormField(
                focusNode: _searchBarFocusNode,
                controller: _searchBarTextController
            );
        }
    );
}

/// Tracks the [_searchBarFocusNode] state changes.
void _searchBarFocusNodeListener() {
    final isFocused = focusNode.hasFocus;

    if (isFocused) {
      _selectAllSearchBarText();
        
      _openMenu();
    } else {
      _closeMenu()
    }
}

/// Selects all text and moves cursor to the end of search bar text input.
void _selectAllSearchBarText() {
    _searchBarTextController.selection = TextSelection(
      baseOffset: 0,
      extentOffset: _searchBarTextController.text.length,
    );
}
```

The next complex `Search Bar` behaviour is unfocusing when the user taps anywhere outside. For that, find the most top-level widget, wrap it within the `TappableArea` or the `GestureDetector` widget, and include the following code to the `onTap` callback:

``` dart
/// Requests focus to a new instance of the [FocusNode].
FocusScope.of(context).requestFocus(FocusNode());
```

So, when the user taps outside, the `_searchBarFocusNodeListener` handles the focus loss and closes the `Dropdown Menu`.

#### Handling keyboard events

When the user presses the `Enter` key, the first item within the list should be selected. To track the keyboard events, we can use the `KeyboardShortcuts` widget. Consider the following code:

``` dart
/// Defines the required set of keys to press.
final _enterKey = LogicalKeySet(LogicalKeyboardKey.enter);

@override
Widget build(BuildContext context) {
    return KeyboardShortcuts (
        keysToPress: _enterKey,
        onKeysPressed: _onEnterKeyPressed,
        child: SomeChild(),
    );
}

void _onEnterKeyPressed() {
    final item = notifier.searchableDropdownItems.first;

    notifier.selectProjectGroup(item);
}
```

#### Empty results behaviour

The `ProjectGroupsSearchableDropdown` must have special behaviour when the search results are empty. Consider the following statements:
- When the results are empty, and the user presses anywhere except the input, the text within the `Search Bar Component` goes to the previous state.
- When the results are empty, and the user presses enter, nothing happens.

To satisfy the first rule, consider the following code:

``` dart
/// Called when the search bar component is unfocused.
void _fillSearchBarWithSelectedItem() {
    final selectedItemName = notifier.selectedProjectGroup?.name ?? '';

    _searchBarTextController.value = selectedItemName;
}
```

This method is called whenever the `Search Bar Component` unfocuses. Consider the following cases:
- If the `Search Bar Component` unfocuses after the user selects an item from the Dropdown, this method will fill the `Search Bar Component` with the new project group name. 
- If the `Search Bar Component` unfocuses after the user taps anywhere outside, this method uses the previous selection.

To meet the second rule, we need to add the following check to the `_onEnterKeyPressed`:

``` dart

void _onEnterKeyPressed() {
    final items = notifier.searchableDropdownItems;

    if(items.isEmpty) return;

    // other logic goes here
}
```

Consider the following class diagram that describes the `ProjectGroupsSearchableDropdown` widget structure
and how it interacts with the `SearchableDropdown` widget.  
![Widget class diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/Flank/flank-dashboard/raw/master/metrics/web/docs/features/searchable_dropdown/diagrams/project_groups_searchable_dropdown_widget_class_diagram.puml)

# Testing
> How will the project be tested?

The widgets will be unit- and widget-tested using the core [flutter_test](https://api.flutter.dev/flutter/flutter_test/flutter_test-library.html) package.

For [`selection_menu`](https://pub.dev/packages/selection_menu) package we will need to implement tests and create PR.
