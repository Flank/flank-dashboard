import 'package:flutter/material.dart';
import 'package:selection_menu/components_configurations.dart';
import 'package:selection_menu/selection_menu.dart';

typedef DropdownItemBuilder<T> = Widget Function(BuildContext context, T item);

/// A dropdown menu widget.
class DropdownMenu<T> extends StatelessWidget {
  /// A [Curve] of the menu opening animation.
  final Curve menuAnimationCurve;

  /// A [Duration] of the menu opening animation.
  final Duration menuAnimationDuration;

  /// A list of items to select from.
  final List<T> items;

  /// A height of the item in items list.
  final double itemHeight;

  /// An [AnimationBuilder] needed to build the dropdown menu widget.
  ///
  /// Should call the [AnimationComponentData.opened] once menu opening finished
  /// and [AnimationComponentData.closed] once menu closing finished
  final AnimationBuilder menuBuilder;

  /// A [DropdownItemBuilder] needed to build a single dropdown menu item.
  final DropdownItemBuilder<T> itemBuilder;

  /// A [DropdownItemBuilder] needed to build a dropdown button.
  final DropdownItemBuilder<T> buttonBuilder;

  /// A [ValueChanged] callback called when selecting an item from the list.
  final ValueChanged<T> onItemSelected;

  /// An initially selected item index in the given [items] list.
  final int initiallySelectedItemIndex;

  /// An [EdgeInsets] representing an empty space around the dropdown menu.
  final EdgeInsets menuPadding;

  /// Creates a [DropdownMenu] widget.
  ///
  /// If [items] is not specified, an empty list used.
  /// If the [menuAnimationCurve] is null the [Curves.linear] used.
  /// If the [menuAnimationDuration] is null the empty [Duration] used.
  /// If the [itemHeight] is null the [kMinInteractiveDimension] used.
  /// If the [menuPadding] is null the [EdgeInsets.zero] used.
  ///
  /// [itemBuilder], [buttonBuilder], and [menuBuilder] must not be null.
  const DropdownMenu({
    Key key,
    @required this.itemBuilder,
    @required this.buttonBuilder,
    @required this.menuBuilder,
    this.onItemSelected,
    this.initiallySelectedItemIndex,
    List<T> items,
    double itemHeight,
    Curve menuAnimationCurve,
    Duration menuAnimationDuration,
    EdgeInsets menuPadding,
  })  : items = items ?? const [],
        menuAnimationCurve = menuAnimationCurve ?? Curves.linear,
        menuAnimationDuration = menuAnimationDuration ?? const Duration(),
        itemHeight = itemHeight ?? kMinInteractiveDimension,
        menuPadding = menuPadding ?? EdgeInsets.zero,
        assert(itemBuilder != null),
        assert(buttonBuilder != null),
        assert(menuBuilder != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SelectionMenu<T>(
      itemsList: items ?? [],
      initiallySelectedItemIndex: initiallySelectedItemIndex,
      itemBuilder: (_, item, onItemSelected) {
        return GestureDetector(
          onTap: onItemSelected,
          child: itemBuilder(context, item),
        );
      },
      onItemSelected: (item) => onItemSelected?.call(item),
      componentsConfiguration: DropdownComponentsConfiguration(
        menuAnimationCurves: MenuAnimationCurves(
          forward: menuAnimationCurve,
          reverse: menuAnimationCurve,
        ),
        menuAnimationDurations: MenuAnimationDurations(
          forward: menuAnimationDuration,
          reverse: menuAnimationDuration,
        ),
        menuPositionAndSizeComponent: MenuPositionAndSizeComponent(
          builder: (data) {
            return MenuPositionAndSize(
              positionOffset: Offset.zero,
              constraints: BoxConstraints.loose(
                Size(
                  data?.triggerPositionAndSize?.size?.width ?? 0.0,
                  items.length * itemHeight,
                ),
              ),
            );
          },
        ),
        animationComponent: AnimationComponent(
          builder: (data) {
            return Padding(
              padding: menuPadding,
              child: menuBuilder(data),
            );
          },
        ),
        listViewComponent: ListViewComponent(
          builder: (data) {
            return ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: data.itemCount,
              itemBuilder: data.itemBuilder,
            );
          },
        ),
        triggerComponent: TriggerComponent(
          builder: (data) {
            return GestureDetector(
              onTap: data.triggerMenu,
              child: buttonBuilder(context, data.selectedItem as T),
            );
          },
        ),
      ),
    );
  }
}
