# StraggeredCollectionLayout

`StraggeredCollectionLayout` is a custom `UICollectionViewLayout` subclass that arranges items in a Pinterest-style staggered (masonry) grid, distributing items across a configurable number of columns and placing each new item into the shortest column.

## Preview

| Feature / Variation | Preview |
| -------------------- | ------- |
| **Staggered Grid Layout** | *(add preview asset)* |

## Basic Usage

### 1. Add to Collection View

**Swift (Programmatic):**
```swift
let layout = StraggeredCollectionLayout()
let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
view.addSubview(collectionView)
```

### 2. Configure Columns & Padding

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
| `collectionView(_:heightForItemAt:width:)` | Returns the item's content height for a given column width. Called once per item during `prepare()`. If not implemented (or `delegate` is `nil`), each item defaults to a height of `300pt`. |

## Configuration

`configure(numberOfColumns:cellPadding:)` is the primary entry point for customizing the layout. It must be called before the collection view first lays out its content (or followed by `invalidateLayout()` / a reload) for changes to take effect.

| Parameter | Type | Default | Description |
| --------- | ---- | ------- | ----------- |
| `numberOfColumns` | `Int` | `2` | Number of columns to distribute items across |
| `cellPadding` | `CGFloat` | `6` | Padding applied around each cell, both between columns and vertically between stacked items |

**Example:**
```swift
layout.configure(numberOfColumns: 2)              // Uses default cellPadding of 6
layout.configure(numberOfColumns: 4, cellPadding: 4)
```

## Properties Reference

### General Properties

| Property Name | Type | Description |
| -------------- | ---- | ----------- |
| `delegate` | `StraggeredCollectionLayoutDelegate?` | Supplies per-item heights used during layout calculation |

## Notes

- Layout is single-section only — `prepare()` iterates `collectionView.numberOfItems(inSection: 0)` and does not account for additional sections
- Item heights are only queried once per `prepare()` call; if content driving those heights changes, the layout must be invalidated (e.g. `collectionView.collectionViewLayout.invalidateLayout()`) to pick up new values

---

*For further customization, you can ask UX Engineer or inherit `StraggeredCollectionLayout` and override its methods, or add additional functionality as required.*
