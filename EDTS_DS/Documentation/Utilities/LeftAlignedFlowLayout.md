# LeftAlignedFlowLayout

`LeftAlignedFlowLayout` is a custom `UICollectionViewFlowLayout` subclass that supports two layout modes: a left-aligned flow (items wrap and pack against the leading edge, like left-aligned tags/chips) and a fixed-column grid (items arranged into evenly-sized columns with row-based vertical stacking).

## Preview

| Feature / Variation | Preview |
| -------------------- | ------- |
| **Vertical Mode** | ![Vertical Mode](https://res.cloudinary.com/dacnnk5j4/image/upload/w_400,c_scale,q_auto,f_auto/v1784874442/left_aligned_vertical_rqdgxi.gif) |
| **Grid Mode** | ![Grid Mode](https://res.cloudinary.com/dacnnk5j4/image/upload/w_400,c_scale,q_auto,f_auto/v1784874441/left_aligned_grid_nysvvr.gif) |

## Basic Usage

### 1. Add to Collection View

**Swift (Programmatic):**
```swift
let layout = LeftAlignedFlowLayout()
let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
view.addSubview(collectionView)
```

### 2. Select a Mode

```swift
// Left-aligned flow (default)
layout.mode = .vertical

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

## `Mode` Enum

```swift
enum Mode {
    case vertical
    case grid(columns: Int)
}
```

| Case | Description |
| ---- | ----------- |
| `.vertical` | Default mode. Falls back to standard `UICollectionViewFlowLayout` flow behavior, but re-packs each row's items against the **left edge** instead of flow layout's default justified spacing |
| `.grid(columns: Int)` | Arranges items into a fixed number of evenly-sized columns, wrapping to a new row every `columns` items |

## Properties Reference

### General Properties

| Property Name | Type | Access | Default | Description |
| -------------- | ---- | ------ | ------- | ----------- |
| `mode` | `Mode` | public | `.vertical` | Selects between left-aligned flow and fixed-column grid layout behavior |

`LeftAlignedFlowLayout` also inherits all standard `UICollectionViewFlowLayout` properties (`sectionInset`, `minimumInteritemSpacing`, `minimumLineSpacing`, `itemSize`, etc.), which continue to drive both modes' spacing and insets.

---

*For further customization, you can ask UX Engineer or inherit `LeftAlignedFlowLayout` and override its methods, or add additional functionality as required.*
