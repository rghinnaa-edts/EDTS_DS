# EDTSFlowLayout

`EDTSFlowLayout` is a custom `UICollectionViewFlowLayout` subclass that supports three layout modes, each with its own manually-computed attribute layout: a single-column vertical stack, a single-row horizontal stack, and a fixed-column grid (items arranged into evenly-sized columns with row-based vertical stacking, wrapping to a new row every `columns` items).

## Preview

| Feature / Variation | Preview |
| -------------------- | ------- |
| **Vertical Mode** | ![Vertical Mode](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1784874442/left_aligned_vertical_rqdgxi.gif) |
| **Horizontal Mode** | ![Horizontal Mode](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1785824882/left_aligned_horizontal_brsfzo.gif) |
| **Grid Mode** | ![Grid Mode](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1784874441/left_aligned_grid_nysvvr.gif) |

## Basic Usage

### 1. Add to Collection View

**Swift (Programmatic):**
```swift
let layout = EDTSFlowLayout()
let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
view.addSubview(collectionView)
```

### 2. Select a Mode

```swift
// Single-column vertical stack (default)
layout.mode = .vertical

// Single-row horizontal stack
layout.mode = .horizontal

// Fixed 3-column grid
layout.mode = .grid(columns: 3)
```

### 3. Provide Item Sizes (via UICollectionViewDelegateFlowLayout)

```swift
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: 120, height: 40)
    }
}
```

> **Note:** If the delegate does not implement `sizeForItemAt` (or the collection view's delegate doesn't conform to `UICollectionViewDelegateFlowLayout`), items fall back to a size with zero height and, in grid mode, a width equal to the computed column width.

## `Mode` Enum

```swift
enum Mode {
    case vertical
    case horizontal
    case grid(columns: Int)
}
```

| Case | Description |
| ---- | ----------- |
| `.vertical` | Default mode. Sets `scrollDirection` to `.vertical` and stacks items into a single column, one item per row (equivalent to `.grid(columns: 1)`) |
| `.horizontal` | Sets `scrollDirection` to `.horizontal` and lays items out left-to-right in a single row, spaced by `minimumInteritemSpacing` |
| `.grid(columns: Int)` | Sets `scrollDirection` to `.vertical` and arranges items into a fixed number of evenly-sized columns, wrapping to a new row every `columns` items |

## Properties Reference

### General Properties

| Property Name | Type | Access | Default | Description |
| -------------- | ---- | ------ | ------- | ----------- |
| `mode` | `Mode` | public | `.vertical` | Selects between single-column, single-row, and fixed-column grid layout behavior. Changing it updates `scrollDirection` to match and calls `invalidateLayout()` |

---

*For further customization, you can ask UX Engineer or inherit `EDTSFlowLayout` and override its methods, or add additional functionality as required.*
