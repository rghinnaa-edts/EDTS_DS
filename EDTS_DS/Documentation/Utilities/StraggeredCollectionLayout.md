# StraggeredCollectionLayout

`StraggeredCollectionLayout` is a custom `UICollectionViewLayout` subclass that arranges items in a Pinterest-style staggered (masonry) grid, distributing items across a configurable number of columns and placing each new item into the shortest column.

## Preview

| Feature / Variation | Preview |
| -------------------- | ------- |
| **Staggered Grid Layout** | ![Staggered Grid Layout](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1784874441/staggerd_qpxley.gif) |

## Basic Usage

### 1. Add to Collection View

**Swift (Programmatic):**
```swift
let layout = StraggeredCollectionLayout()
let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
view.addSubview(collectionView)
```

### 2. Configure Columns, Padding, & Spacing

```swift
layout.configure(numberOfColumns: 3, cellPadding: 8)
```

### 3. Implement Delegate

```swift
layout.delegate = self

extension ViewController: StraggeredCollectionLayoutDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        heightForItemAt indexPath: IndexPath,
        width: CGFloat
    ) -> CGFloat {
        // Return the intrinsic content height for the item at this index path,
        // given the calculated column width
        return items[indexPath.item].calculatedHeight(for: width)
    }
}
```

## Delegate Protocol

### StraggeredCollectionLayoutDelegate

```swift
public protocol StraggeredCollectionLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath, width: CGFloat) -> CGFloat
}
```

| Method | Description |
| ------ | ----------- |
| `collectionView(_:heightForItemAt:width:)` | Returns the item's content height for a given column width. Called once per item during `prepare()`. The method is required for any type conforming to the protocol. If `delegate` is `nil`, each item defaults to a height of `300pt`. |

## Configuration

`configure(numberOfColumns:cellPadding:horizontalSpacing:verticalSpacing:)` is the primary entry point for customizing the layout. It must be called before the collection view first lays out its content (or followed by `invalidateLayout()` / a reload) for changes to take effect.

| Parameter | Type | Default | Description |
| --------- | ---- | ------- | ----------- |
| `numberOfColumns` | `Int` | `2` | Number of columns to distribute items across |
| `cellPadding` | `CGFloat` | `6` | Outer padding around the whole grid (left, right, top and bottom edges of the content). Also used to derive the default spacing between items when `horizontalSpacing` / `verticalSpacing` are not provided |
| `horizontalSpacing` | `CGFloat?` | `nil` | Horizontal gap between columns. When `nil`, falls back to `cellPadding * 2` |
| `verticalSpacing` | `CGFloat?` | `nil` | Vertical gap between stacked items within a column. When `nil`, falls back to `cellPadding * 2` |

**Example:**
```swift
layout.configure(numberOfColumns: 2)                    // cellPadding 6, item gaps default to 12
layout.configure(numberOfColumns: 4, cellPadding: 4)    // item gaps default to 8
layout.configure(numberOfColumns: 3,
                 cellPadding: 8,
                 horizontalSpacing: 10,
                 verticalSpacing: 16)                   // explicit gaps
```

### Column Width Calculation

The width of each column is derived from the available content width (collection view width minus horizontal `contentInset`):

```
columnWidth = (contentWidth - cellPadding * 2 - horizontalSpacing * (numberOfColumns - 1)) / numberOfColumns
```

This value is the `width` passed to the delegate's `heightForItemAt` method.

## Properties Reference

### General Properties

| Property Name | Type | Description |
| -------------- | ---- | ----------- |
| `delegate` | `StraggeredCollectionLayoutDelegate?` | Supplies per-item heights used during layout calculation |

## Notes

- Layout is single-section only — `prepare()` iterates `collectionView.numberOfItems(inSection: 0)` and does not account for additional sections
- Items are placed one by one: the first item goes into the first column, and each following item goes into the column that is currently shortest (the leftmost one when columns are tied)
- Item heights are only queried once per `prepare()` call; if content driving those heights changes, the layout must be invalidated (e.g. `collectionView.collectionViewLayout.invalidateLayout()`) to pick up new values

---

*For further customization, you can ask UX Engineer or inherit `StraggeredCollectionLayout` and override its methods, or add additional functionality as required.*
