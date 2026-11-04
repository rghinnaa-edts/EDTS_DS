# EDTSCoachmark

`EDTSCoachmark` is a full-screen overlay component that guides users through an app's features. It dims the screen, cuts out a spotlight around a target view, and shows a card with a title, description, step counter and buttons, plus an arrow pointing at the target. It supports a single tip (`single`) or a multi-step tour (`multiple`).

---

## Features

- Step-by-step tours driven by an array of `CoachmarkStepConfig`
- Spotlight anchored to a target view, or spanning from a start view to an end view (`endTargetView`)
- Spotlight follows the target live (scrolling, animations) using a `CADisplayLink`
- Card and arrow automatically flip above/below the spotlight depending on available space
- Single (one tip, one button) and multiple (counter + skip/next buttons) types
- Customizable fonts, icon, divider and button colors
- Optional spotlight-free mode for general announcements

## Preview

![Coachmark Preview](https://res.cloudinary.com/dr6cm6n5f/image/upload/c_scale,w_200/q_auto/f_auto/v1775039040/Coachmark_ko1uju.gif)

---

## Installation

Add to your `Podfile`:

```ruby
pod 'EDTS_DS/Coachmark'
```

Then import it wherever you use the component:

```swift
import EDTS_DS
```

This relies on the design token types already available in the pod (`EDTSColor`, `EDTSFont`).

---

## Basic Usage

Always build and show the coachmark on the main thread, after the target views have been laid out.

```swift
DispatchQueue.main.async {
    self.showCoachmark()
}
```

### Show a single step

```swift
func showCoachmark() {
    let coachmark = EDTSCoachmark(frame: .zero)
    coachmark.coachmarkType = CoachmarkType.single.rawValue

    coachmark.configureSteps(steps: [
        CoachmarkStepConfig(
            title: "Tambah Produk Lebih Cepat",
            description: "Pilih karton untuk tambah banyak sekaligus",
            targetView: cardTotalType,
            contentMargin: 24,
            spotlightPadding: 8,
            isTargetAList: true
        )
    ])

    coachmark.show()
}
```

### Show multiple steps

```swift
func showCoachmark() {
    let coachmark = EDTSCoachmark(frame: .zero)

    coachmark.stepConjunction = "dari"
    coachmark.btnOutlinedTint = UIColor.red
    coachmark.btnFilledTint = UIColor.purple

    coachmark.configureSteps(steps: [
        CoachmarkStepConfig(
            title: "Step 1",
            description: "The quick brown fox jumps over the lazy dog",
            targetView: vCard1
        ),
        CoachmarkStepConfig(
            title: "Step 2",
            description: "This step highlights an area from vCard2 down to vCard3",
            targetView: vCard2,
            endTargetView: vCard3
        )
    ])

    coachmark.show()
}
```

### Highlight an area between two views

When `endTargetView` is set, the spotlight covers the union of `targetView` and `endTargetView` with a fixed 16 pt padding.

```swift
CoachmarkStepConfig(
    title: "Ringkasan",
    description: "Area ini menampilkan ringkasan pesanan Anda",
    targetView: vHeader,
    endTargetView: vFooter
)
```

### Show without spotlight

```swift
CoachmarkStepConfig(
    title: "Fitur Baru",
    description: "Kini Anda bisa memesan lebih cepat",
    targetView: vAnchor,   // still used to position the card and arrow
    isHideSpotlight: true
)
```

### Handle dismiss

`onDismiss` is called when the coachmark is closed by the skip button, by the last step's button, or by calling `dismiss()` manually.

```swift
func showCoachmark() {
    let coachmark = EDTSCoachmark(frame: .zero)

    coachmark.onDismiss = {
        print("Coachmark was dismissed")
    }

    coachmark.configureSteps(steps: [
        CoachmarkStepConfig(
            title: "Step 1",
            description: "The quick brown fox jumps over the lazy dog",
            targetView: vCard1
        )
    ])

    coachmark.show()
}
```

---

## Coachmark Types

| Type Name | Value | Description |
| --------- | ----- | ----------- |
| `Multiple` | `"multiple"` | Default. Shows the step counter (e.g. "1 dari 3"), the outlined (skip) button and the filled (next) button |
| `Single` | `"single"` | Shows only the filled button. The step counter, outlined button, icon and divider are hidden |

---

## Methods

| Method | Description |
| ------ | ----------- |
| `configureSteps(steps: [CoachmarkStepConfig])` | Sets the steps and displays the first one. Call this before `show()` |
| `show(animated: Bool = true, completion: (() -> Void)? = nil)` | Adds the coachmark to the key window and plays the intro animation. `completion` runs after the card has faded in. Does nothing if there is no key window |
| `dismiss(animated: Bool = true, completion: (() -> Void)? = nil)` | Closes the coachmark. `onDismiss` is called first, then `completion` |

---

## Properties Reference

### General Properties

| Property Name | Type | Default | Description |
| ------------- | ---- | ------- | ----------- |
| `coachmarkType` | `String` | `CoachmarkType.multiple.rawValue` | Coachmark type (`single`, `multiple`) |
| `stepConjunction` | `String` | `"dari"` | Word between current and total step, rendered as `"1 dari 3"` |
| `onDismiss` | `(() -> Void)?` | `nil` | Closure called after the coachmark is dismissed |

### Title Properties

| Property Name | Type | Default | Description |
| ------------- | ---- | ------- | ----------- |
| `titleFontName` | `String` | `""` | Custom font name for the title (falls back to the system font if empty or not found) |
| `titleFontSize` | `CGFloat` | `18` | Font size for the title |
| `titleFontWeight` | `String` | `FontWeight.regular.rawValue` | Font weight for the title |

### Description Properties

| Property Name | Type | Default | Description |
| ------------- | ---- | ------- | ----------- |
| `descFontName` | `String` | `""` | Custom font name for the description |
| `descFontSize` | `CGFloat` | `14` | Font size for the description |
| `descFontWeight` | `String` | `FontWeight.regular.rawValue` | Font weight for the description |

### Step Counter Properties

| Property Name | Type | Default | Description |
| ------------- | ---- | ------- | ----------- |
| `stepFontName` | `String` | `""` | Custom font name for the step counter |
| `stepFontSize` | `CGFloat` | `14` | Font size for the step counter |
| `stepFontWeight` | `String` | `FontWeight.regular.rawValue` | Font weight for the step counter |

### Icon Properties

| Property Name | Type | Default | Description |
| ------------- | ---- | ------- | ----------- |
| `iconTint` | `UIColor?` | `nil` | Icon tint color |
| `iconBgColor` | `UIColor?` | `nil` | Icon background color (falls back to `EDTSColor.grey20`) |
| `isIconHide` | `Bool` | `false` | Hides the icon and its background; the text moves to the leading edge |

### Divider Properties

| Property Name | Type | Default | Description |
| ------------- | ---- | ------- | ----------- |
| `isDividerHide` | `Bool` | `false` | Hides the divider between content and buttons and tightens the spacing |

### Button Properties

| Property Name | Type | Default | Description |
| ------------- | ---- | ------- | ----------- |
| `btnOutlinedTint` | `UIColor?` | `nil` | Border and label color of the outlined button |
| `btnFilledTint` | `UIColor?` | `nil` | Background color of the filled button |

> **Note:** `isIconHide` and `isDividerHide` are automatically set to `true` when the active `EDTSColor.theme` is `.poinku`. You can still override them after creating the instance.

---

## Step Configuration (`CoachmarkStepConfig`)

### Content

| Parameter | Type | Default | Description |
| --------- | ---- | ------- | ----------- |
| `icon` | `UIImage?` | `nil` | Icon shown beside the text (falls back to the `ic_placeholder` image). Hidden when `isIconHide` is `true` |
| `title` | `String?` | `nil` | Title text |
| `titleAttributted` | `NSAttributedString?` | `nil` | Attributed title, used only when `title` is `nil` |
| `description` | `String?` | `nil` | Description text |
| `descriptionAttributed` | `NSAttributedString?` | `nil` | Attributed description, used only when `description` is `nil` |

### Target and Spotlight

| Parameter | Type | Default | Description |
| --------- | ---- | ------- | ----------- |
| `targetView` | `UIView?` | `nil` | View the spotlight and arrow are anchored to |
| `endTargetView` | `UIView?` | `nil` | Optional end view. The spotlight spans both views (union) with a fixed 16 pt padding |
| `spotlightRadius` | `CGFloat?` | `4` | Corner radius of the spotlight. Also used as outward padding when the target is not a list |
| `spotlightPadding` | `CGFloat?` | `8` | Padding used when `isTargetAList` is `true` (see below) |
| `spotlightPaddingLeft` | `CGFloat?` | `nil` | Overrides the left inset (list targets only) |
| `spotlightPaddingRight` | `CGFloat?` | `nil` | Overrides the right inset (list targets only) |
| `isTargetAList` | `Bool` | `false` | Enables padding-based spotlight sizing, intended for list/row targets |
| `isHideSpotlight` | `Bool` | `false` | Shows the card without the dim overlay and spotlight |

**How the spotlight is sized**

| Case | Spotlight |
| ---- | --------- |
| `endTargetView` set | Union of both targets, expanded by 16 pt on every side. Padding parameters are ignored |
| `isTargetAList = true` | Vertically expanded by `spotlightPadding`. Horizontally **inset** from the target edges by `spotlightPaddingLeft` / `spotlightPaddingRight` (each falls back to `spotlightPadding`) |
| Default | Target frame expanded by `spotlightRadius` on every side. Padding parameters are ignored |

### Layout

| Parameter | Type | Default | Description |
| --------- | ---- | ------- | ----------- |
| `contentMargin` | `CGFloat?` | `24` | Left/right margin between the card and the screen. Card width is `max(320, screenWidth - 2 × contentMargin)` |
| `offsetMargin` | `CGFloat?` | `-1` | Fixed x position of the card. `-1` means "not set": `contentMargin` is used as the x position |

### Buttons

| Parameter | Type | Default | Description |
| --------- | ---- | ------- | ----------- |
| `btnOutlinedText` | `String?` | `nil` | Outlined button text (falls back to `"Tutup"`) |
| `btnFilledText` | `String?` | `nil` | Filled button text (falls back to `"Berikutnya"`) |
| `isBtnOutlinedHide` | `Bool?` | `nil` | Hides the outlined button. `nil` and `false` both show it, except on the last step (see below) |
| `isBtnFilledHide` | `Bool?` | `nil` | Hides the filled button |

---

## Behavior

| Behavior | Description |
| -------- | ----------- |
| Buttons | The outlined button dismisses the coachmark. The filled button goes to the next step, or dismisses on the last step |
| Card position | Shown below the spotlight when there is room, otherwise above it. The arrow flips accordingly |
| Arrow position | Points at the horizontal center of the target, clamped to stay inside the card |
| Target tracking | The spotlight, card and arrow follow the target while it moves (scrolling, animations) |
| Background tap | Tapping the dimmed area does nothing; the coachmark can only be closed with its buttons or `dismiss()` |

---

## Enums Reference

### `CoachmarkType`

```swift
public enum CoachmarkType: String {
    case single = "single"
    case multiple = "multiple"
}
```

### `CoachmarkArrowPosition`

```swift
public enum CoachmarkArrowPosition {
    case top
    case bottom
}
```

---

## Animation Details

| Animation Type | Duration | Easing | Description |
| -------------- | -------- | ------ | ----------- |
| Overlay fade in | `100ms` | Default | Fades the overlay in on `show()` |
| Spotlight intro | `500ms` | `EaseOut` | Expands the spotlight from a small dot at the target's center |
| Card fade in | `200ms` | Default | Card and arrow fade in after the spotlight finishes |
| Step transition | `300ms` | `EaseInOut` | Spotlight morphs to the next target and the card and arrow move |
| Dismiss | `200ms` + `400ms` | `EaseIn` | Card and arrow fade out, then the spotlight collapses to the target's center |

---

*For further customization, you can ask UX Engineer or inherit `EDTSCoachmark` and override its methods, or add additional functionality as required.*
