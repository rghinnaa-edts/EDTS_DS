# EDTSToast

`EDTSToast` is a customizable notification banner component that supports two states (`info` and `danger`), optional leading icons, action buttons (text or icon), and swipe-to-dismiss gestures. It is managed globally via `EDTSToastManager`, which handles toast presentation, dismissal, animation, and replacement of currently displayed toasts.

## Preview

### 1. Toast State Variation

| Feature / Variation | Preview |
| ------------------- | ------- |
| **Info State** | ![Toast Info State](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1772523777/toast-info_digyta.gif) |
| **Danger State** | ![Toast Danger State](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1772523777/toast-danger_go9qf9.gif) |

### 2. Toast Show Animation
| Show Animation | Preview | Top | Bottom |
| ------------------- | ------- | ------- | ------- |
| **Fade** | ![Toast Fade Animation](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1772523778/fade_jplpho.gif) |  |  |
| **Slide** | ![Toast Slide  Animation](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1772523778/slide-bottom_pdrpaa.gif) | ![Toast Slide  Animation](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1772523777/slide-top_jdyhae.gif) | ![Toast Slide  Animation](https://res.cloudinary.com/dacnnk5j4/image/upload/w_300,c_scale,q_auto,f_auto/v1772523778/slide-bottom_pdrpaa.gif) |

### 3. Toast Dismiss Animation
| Dismiss Animation | Preview | Top | Bottom | Right |
| ------------------- | ------- | ------- | ------- | ------- |
| **Swipe** | ![Toast Swipe Animation](https://res.cloudinary.com/dacnnk5j4/image/upload/w_800,c_scale,q_auto,f_auto/v1772523777/swipe-right_ap3k6c.gif) | ![Toast Swipe Animation](https://res.cloudinary.com/dacnnk5j4/image/upload/w_800,c_scale,q_auto,f_auto/v1772523777/swipe-up_anychh.gif) | ![Toast Swipe Animation](https://res.cloudinary.com/dacnnk5j4/image/upload/w_800,c_scale,q_auto,f_auto/v1772523777/swipe-down_oaf87i.gif) | ![Toast Swipe Animation](https://res.cloudinary.com/dacnnk5j4/image/upload/w_800,c_scale,q_auto,f_auto/v1772523777/swipe-right_ap3k6c.gif) |

## Basic Usage

### 1. Add to Layout

**Swift (Storyboard/XIB):**
```swift
// Add UIView from Interface Builder
// Set Custom Class to EDTSToast in Identity Inspector
```

**Swift (Programmatic via ToastManager):**
```swift
EDTSToastManager.toast.show(rootView: view, configure:  { toast in
    toast.toastState = "info"
    toast.label = "Your changes have been saved."
    toast.iconLeading = UIImage(systemName: "checkmark.circle.fill")
})
```

### 2. Initialize with Full Configuration

```swift
EDTSToastManager.toast.show(
    rootView: view,
    duration: .long,
    horizontalPadding: 16.0,
    offsetY: .bottom(60.0),
    animation: .fade,
    swipeDirection: .horizontal,
    onButtonTap: {
        print("Action tapped")
    },
    configure: { toast in
        toast.toastState = "danger"
        toast.label = "Something went wrong. Please try again."
        toast.iconLeading = UIImage(systemName: "exclamationmark.triangle.fill")

        // Optional: Add text action button
        toast.configureButton { btn in
            btn.label = "Retry"
        }
    }
)
```

### 3. Dismiss Manually

```swift
EDTSToastManager.toast.dismiss(animated: true)
```

---

## Toast States

| State Name | Value | Description |
| ---------- | ----- | ----------- |
| `Info` | `"info"` | Default neutral notification (grey background) |
| `Danger` | `"danger"` | Destructive or error notification (red background) |

---

## EDTSToastManager

`EDTSToastManager` is a singleton that manages the display lifecycle of `Toast` components.

### `show()` Parameters

| Parameter | Type | Default | Description |
| --------- | ---- | ------- | ----------- |
| `rootView` | `UIView` | Required | The parent view to attach the toast to |
| `duration` | `EDTSToastDuration` | `.long` | How long the toast is visible before auto-dismissing |
| `horizontalPadding` | `CGFloat` | `16.0` | Leading and trailing margin from the root view edges |
| `offsetY` | `EDTSToastOffsetDirection` | `.bottom(60.0)` | Vertical anchor and offset from the safe area |
| `animation` | `EDTSToastAnimation` | `.fade` | Animation style for show/dismiss transitions |
| `swipeDirection` | `EDTSToastSwipeDirection` | `.horizontal` | Swipe gesture direction for dismissal |
| `onButtonTap` | `(() -> Void)?` | `nil` | Closure called when the action button is tapped |
| `configure` | `((EDTSToast) -> Void)?` | `nil` | Closure to configure the toast instance |

---

## Properties Reference

### Text Properties

| Property Name | Type | Default | Description |
| ------------- | ---- | ------- | ----------- |
| `label` | `String?` | `nil` | Text displayed in the toast body |
| `labelAttributed` | `NSAttributedString?` | `nil` | Attributed text for the toast body (overrides `label`) |
| `labelColor` | `UIColor?` | `EDTSColor.white` | Text color |
| `fontName` | `String` | `System font` | Custom font name (falls back to system font if not found) |
| `fontSize` | `CGFloat` | `12.0` | Font size |
| `fontWeight` | `String` | `"regular"` | Font weight (`ultralight`, `thin`, `light`, `regular`, `medium`, `semibold`, `bold`, `heavy`, `black`) |

### Icon Properties

| Property Name | Type | Default | Description |
| ------------- | ---- | ------- | ----------- |
| `iconLeading` | `UIImage?` | `nil` | Leading icon image (shows icon when set, hides when nil) |
| `iconTintColorLeading` | `UIColor?` | `EDTSColor.white` | Tint color for the leading icon |
| `iconSize` | `CGFloat` | `16.0` | Width and height of the leading icon |

### Appearance Properties

| Property Name | Type | Default | Description |
| ------------- | ---- | ------- | ----------- |
| `toastState` | `String?` | `"info"` | Toast state (`info`, `danger`) |
| `bgColor` | `UIColor?` | State-dependent | Background color (overrides state default when set) |
| `cornerRadius` | `CGFloat` | `8.0` | Corner radius of the toast container |
| `borderWidth` | `CGFloat` | `0.0` | Border width |
| `borderColor` | `UIColor?` | `nil` | Border color |
| `spacing` | `CGFloat` | `8.0` | Spacing between icon, label, and button |

### Padding Properties

| Property Name | Type | Default | Description |
| ------------- | ---- | ------- | ----------- |
| `paddingTop` | `CGFloat` | `16.0` | Top inset inside the toast container |
| `paddingBottom` | `CGFloat` | `16.0` | Bottom inset inside the toast container |
| `paddingLeading` | `CGFloat` | `16.0` | Leading inset inside the toast container |
| `paddingTrailing` | `CGFloat` | `16.0` | Trailing inset inside the toast container |

### Shadow Properties

| Property Name | Type | Default | Description |
| ------------- | ---- | ------- | ----------- |
| `shadowOpacity` | `Float` | `1.0` | Shadow opacity |
| `shadowRadius` | `CGFloat` | `4.0` | Shadow blur radius |
| `shadowOffset` | `CGSize` | `CGSize(width: 0, height: 2)` | Shadow offset |
| `shadowColor` | `UIColor?` | `rgba(112, 114, 125, 0.4)` | Shadow color |

---

## State-Specific Styling

| State | Background | Text Color | Icon Tint |
| ----- | ---------- | ---------- | --------- |
| `info` | `grey60` | `white` | `white` |
| `danger` | `errorStrong` | `white` | `white` |

---

## Action Buttons

EDTSToast supports two optional action button types. Only one should be used at a time. Both buttons fire `delegate?.didSelectButton(_:)`. When using `EDTSToastManager`, the provided `onButtonTap` closure is executed when the button is tapped.

| Text Button | Icon Button |
| ----- | ---------- |
| Use this when the button is displayed as text. | Use this when the button is displayed as an icon |
| Use `configureButton(_:)` to attach a [`KlikIDM_DSButton`](https://github.com/rghinnaa-edts/KlikIDM_DS/blob/main/KlikIDM_DS/Documentation/KlikIDM_DSButton.md):<br><br>`toast.configureButton { btn in`<br>`    btn.label = "Undo"`<br>`}` | Use `configureIconButton(_:)` to attach an [`IconButton`](https://github.com/rghinnaa-edts/KlikIDM_DS/blob/main/KlikIDM_DS/Documentation/IconButton.md):<br><br>`toast.configureIconButton { btn in`<br>`    btn.icon = UIImage(systemName: "xmark")`<br>`}` |

---

## Swipe to Dismiss

Configure swipe direction via `EDTSToastManager.show()`:

```swift
EDTSToastManager.toast.show(
    rootView: view,
    swipeDirection: .horizontal  // or .vertical
) { toast in ... }
```

Swipe gesture directions are resolved based on `swipeDirection` and `offsetY`:

| `swipeDirection` | `offsetY` | Swipe Gesture |
| ---------------- | --------- | ------------- |
| `.horizontal` | Any | Swipe right |
| `.vertical` | `.bottom` | Swipe down |
| `.vertical` | `.top` | Swipe up |

---

## Enums Reference

### `EDTSToastDuration`

| Case | Duration |
| ---- | -------- |
| `.short` | `1.5s` |
| `.long` | `2.75s` |
| `.indefinite` | Does not auto-dismiss |
| `.custom(TimeInterval)` | User-defined duration |

### `EDTSToastAnimation`

| Case | Description |
| ---- | ----------- |
| `.fade` | Fades in with a scale-up effect; fades out |
| `.slide` | Slides in/out from the edge defined by `offsetY` |

### `EDTSToastOffsetDirection`

| Case | Description |
| ---- | ----------- |
| `.top(CGFloat)` | Anchors toast to the top safe area with given offset |
| `.bottom(CGFloat)` | Anchors toast to the bottom safe area with given offset |

### `EDTSToastSwipeDirection`

| Case | Description |
| ---- | ----------- |
| `.horizontal` | Swipe right to dismiss |
| `.vertical` | Swipe up or down based on `offsetY` |

---

## Animation Details

### Show Animations

| Animation | Type | Duration | Easing | Description |
| --------- | ---- | -------- | ------ | ----------- |
| Fade In (opacity) | `fade` | `150ms` | `Linear` | Fades toast from 0 to 1 alpha |
| Scale In | `fade` | `150ms` | `LinearOutSlowIn` | Scales toast from 80% to 100% |
| Slide In | `slide` | `250ms` | `EaseInOut` | Slides toast from screen edge to position |

### Dismiss Animations

| Animation | Type | Duration | Easing | Description |
| --------- | ---- | -------- | ------ | ----------- |
| Fade Out | `fade` | `75ms` | `Linear` | Fades toast from full opacity to 0 |
| Slide Out | `slide` | `250ms` | `EaseInOut` | Slides toast back off screen edge |
| Swipe Out | Both | `250ms` | `EaseInOut` | Slides toast off screen in swipe direction |

---

## Delegate Protocol

```swift
@MainActor
public protocol EDTSToastDelegate: AnyObject {
    func didSelectButton(_ toast: EDTSToast)
    func didSwipeToast(_ toast: EDTSToast, direction: UISwipeGestureRecognizer.Direction)
}
```

`EDTSToastManager` conforms to `EDTSToastDelegate` internally and handles both events automatically. Manual delegate assignment is only needed when using `EDTSToast` outside of `EDTSToastManager`.

---

## Notes

- Calling `EDTSToastManager.toast.show(...)` while a toast is already visible immediately dismisses the current toast (without animation) before showing the new one
- When `duration` is `.indefinite`, the toast must be dismissed manually via `EDTSToastManager.toast.dismiss()`
- Only one toast can be displayed at a time
- Showing a new toast automatically removes the currently displayed toast before presenting the new one

*For further customization, you can ask UX Engineer or inherit `EDTSToast` and override its methods, or add additional functionality as required.*
