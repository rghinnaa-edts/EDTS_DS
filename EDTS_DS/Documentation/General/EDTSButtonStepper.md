# EDTSButtonStepper
The `EDTSButtonStepper` component is a customizable stepper component for incrementing and decrementing numeric values through an intuitive, interactive interface.

## Preview
| Type | Variant `Blue` | Variant `White` |
|----------|-----|-----|
| `Icon` | ![Button Stepper Preview](https://res.cloudinary.com/dr6cm6n5f/image/upload/c_scale,w_100/v1772091335/icon-blue_f742s3.jpg)  | ![Button Stepper Preview](https://res.cloudinary.com/dr6cm6n5f/image/upload/c_scale,w_100/v1772091335/icon-white_lojajh.jpg) |
| `Number` | ![Button Stepper Preview](https://res.cloudinary.com/dr6cm6n5f/image/upload/c_scale,w_100/v1772091335/number-blue_svztcl.jpg) | ![Button Stepper Preview](https://res.cloudinary.com/dr6cm6n5f/image/upload/c_scale,w_100/v1772091335/number-white_thgfzy.jpg) |
| `Stepper` | ![Button Stepper Preview](https://res.cloudinary.com/dr6cm6n5f/image/upload/c_scale,w_200/v1772091338/stepper-blue_zp0eyq.gif) | ![Button Stepper Preview](https://res.cloudinary.com/dr6cm6n5f/image/upload/c_scale,w_200/v1772091338/stepper-white_vyu4b0.gif) |
| `Collapsible` | ![Button Stepper Preview](https://res.cloudinary.com/dr6cm6n5f/image/upload/c_scale,w_200/v1772167459/collapsible-blue_gcthuf.gif) | ![Button Stepper Preview](https://res.cloudinary.com/dr6cm6n5f/image/upload/c_scale,w_200/v1772167459/collapsible-white_hbvjak.gif) |

## Parameters
All parameters are `@IBInspectable`, so they can be set from Interface Builder or in code.

| Parameters                | Description                                                              | Data Type                   |  Default Value               |
|---------------------------|--------------------------------------------------------------------------|-----------------------------|------------------------------|
| `stepperVariant`          | Variant appearance of the button stepper                                 | Enum String                 | `StepperVariant.blue`        |
| `stepperType`             | Type of the button stepper                                               | Enum String                 | `StepperType.stepper`        |
| `textQuantity`            | Value of the quantity                                                    | Int                         | `0`                          |
| `textQuantityMultiple`    | Step value added on "+" and subtracted on "−"                            | Int                         | `1`                          |
| `textQuantityColor`       | Text color of the quantity label (types `stepper` and `collapsible`)     | UIColor                     | `nil`                        |
| `bgColor`                 | Background color of the button stepper                                   | UIColor                     | `nil`                        |
| `btnMinusColor`           | Minus icon color of the button stepper                                   | UIColor                     | `nil`                        |
| `btnMinusBackgroundColor` | Background color of the minus icon                                       | UIColor                     | `nil`                        |
| `btnPlusColor`            | Plus icon color of the button stepper                                    | UIColor                     | `nil`                        |
| `btnPlusBackgroundColor`  | Background color of the plus icon                                        | UIColor                     | `nil`                        |
| `btnIconColor`            | Icon color of the stepper type "Icon"                                    | UIColor                     | `nil`                        |
| `btnIconBackgroundColor`  | Background color of the stepper type "Icon"                              | UIColor                     | `nil`                        |
| `btnNumberColor`          | Text color of the stepper type "Number"                                  | UIColor                     | `nil`                        |
| `btnNumberBackgroundColor`| Background color of the stepper type "Number"                            | UIColor                     | `nil`                        |
| `borderWidth`             | Border width of the button stepper                                       | CGFloat                     | `-1` (use variant default)   |
| `borderColor`             | Border color of the button stepper                                       | UIColor                     | `nil`                        |
| `cornerRadius`            | Corner radius of the button stepper                                      | CGFloat                     | `-1` (fully rounded)         |
| `isDisabled`              | Disables the whole button stepper                                        | Bool                        | `false`                      |
| `isPlusDisabled`          | Disables only the "+" button (e.g. when a maximum quantity is reached)   | Bool                        | `false`                      |

`nil` color values fall back to the default color of the selected variant. A `borderWidth` of `-1` uses the variant default (`0` for `blue`, `1` for `white`).

#### Stepper Variant

| Variant Name | Value | Description |
|--------------|-------|-------------|
| blue | `blue` | Type of appearance blue |
| white | `white` | Type of appearance white |

#### Stepper Type

| Type Name | Value | Description |
|-----------|-------|-------------|
| stepper | `stepper` | Default type of button stepper |
| collapsible | `collapsible` | Type of button that shows button stepper and button icon as a trigger for show and hide the stepper |
| icon | `icon` | Type of button that shows icon only |
| number | `number` | Type of button that shows number only |

## Public Members

| Member | Type | Description |
|--------|------|-------------|
| `delegate` | `EDTSButtonStepperDelegate?` | Receives button actions (weak reference) |
| `isStepperExpanded` | `Bool` (read-only) | `true` when a `collapsible` stepper is currently expanded |
| `onExpansionChanged` | `((Bool) -> Void)?` | Called when a `collapsible` stepper finishes expanding (`true`) or collapsing (`false`) |
| `collapse()` | `func` | Collapses an expanded `collapsible` stepper with animation. Does nothing for other types or when already collapsed |

---

## Installation
To use the `EDTSButtonStepper` component, please follow these steps.

For now, it's available only when you add the Swift class file and the XIB into your project. They are placed at `EDTS_DS/Views/Components/General/ButtonStepper`. Add `EDTSButtonStepper.swift` and `EDTSButtonStepper.xib` into your project.

The component loads the XIB named `EDTSButtonStepper` from the bundle of the class, and the plus/minus icons (`ic_plus`, `ic_minus`) from the `EDTS_DS` bundle, so make sure both are available.

### Usage
1. If you're using a view in storyboard, set its class to `EDTSButtonStepper`.
2. Add the `IBOutlet` of type `EDTSButtonStepper`.
```swift
@IBOutlet public weak var btnStepper: EDTSButtonStepper!

btnStepper.delegate = self

btnStepper.stepperVariant = StepperVariant.blue.rawValue
btnStepper.stepperType = StepperType.collapsible.rawValue
btnStepper.textQuantity = productQty
btnStepper.textQuantityMultiple = 1
btnStepper.isDisabled = false

// Optional
btnStepper.isPlusDisabled = productQty >= maxQty
btnStepper.btnPlusColor = EDTSColor.blue60
btnStepper.onExpansionChanged = { isExpanded in
    print("Stepper expanded:", isExpanded)
}

// Collapse programmatically (collapsible type only)
btnStepper.collapse()
```

3. Conform to the delegate:
```swift
extension MyViewController: EDTSButtonStepperDelegate {
    func didSelectButtonCollapsible(show isShow: Bool) { }
    func didSelectButtonMinus(qty quantity: Int) { }
    func didSelectButtonPlus(qty quantity: Int) { }
}
```

## Delegate Protocol
```swift
@MainActor
public protocol EDTSButtonStepperDelegate: AnyObject {
    func didSelectButtonCollapsible(show isShow: Bool)
    func didSelectButtonMinus(qty quantity: Int)
    func didSelectButtonPlus(qty quantity: Int)
}
```

| Delegate | Description |
|----------|------------|
| `didSelectButtonCollapsible` | Called when the collapsible stepper is expanded (`true`) or collapsed (`false`), including via `collapse()` |
| `didSelectButtonMinus` | Called when the minus button is tapped, with the new quantity |
| `didSelectButtonPlus` | Called when the plus button is tapped, with the new quantity |

## Animation

`EDTSButtonStepper` has two animations: the **quantity roll** (every type that shows a number) and the **expand / collapse** transition (type `collapsible` only). There is no property to turn them off.

### Quantity Roll

| Property | Value | Notes |
|---|---|---|
| Effect | Vertical slide | Old value slides out and the new value slides in, inside a clipped slot |
| Target | `lblQty`, `lblNumber` | Quantity label (`stepper`, `collapsible`) and number label (`number`) |
| Direction | Up / Down | Up when the quantity increases, down when it decreases |
| Duration | `0.25s` | Per quantity change |
| Curve | `easeOut` | |
| Trigger | Tap on "+" or "−" | Setting `textQuantity` from code updates the text without animation |

> The roll is skipped when Reduce Motion is enabled, when the label is hidden or not on screen, or when the new text equals the current text.

### Expand (Collapsible)

Triggered by tapping the trigger button while collapsed. The stepper grows from the trigger's width to the full width, anchored to the trailing edge.

| Step | Animates | Duration | Curve | Notes |
|---|---|---|---|---|
| 1 | Background width, from trigger width to full width | `0.25s` | `easeIn` | Frame-based animation on `containerBackground` |
| 2 | `alpha` of minus, quantity and plus: `0 → 1`. Trigger: `1 → 0` | `0.2s` | `easeInOut` | Starts after step 1 finishes |

Total duration is about `0.45s`. If `textQuantity` is `0`, it is set to `1` when the stepper expands.

### Collapse (Collapsible)

Triggered by tapping the trigger while expanded, tapping minus when the quantity is `1` or less, or calling `collapse()`.

| Step | Animates | Duration | Curve | Notes |
|---|---|---|---|---|
| 1 | `alpha` of minus, quantity and plus: `1 → 0`. Trigger: `0 → 1` | `0.1s` | `easeIn` | |
| 2 | Background width, from full width to trigger width | `0.25s` | `easeInOut` | Starts after step 1 finishes. Controls are hidden when it completes |

Total duration is about `0.35s`.

### Callback Timing

| Callback / Property | When it updates | Notes |
|---|---|---|
| `didSelectButtonCollapsible(show:)` | When the expand or collapse **starts** | Does not wait for the animation to finish |
| `onExpansionChanged` | When the animation **finishes** | Only fires if the expanded state actually changed |
| `isStepperExpanded` | When the animation **finishes** | Still returns the previous value while animating |

### Notes
- Default value of Variant is `Blue`.
- Default value of Type is `Stepper`.
- **Disabled states take priority over custom colors.** While `isDisabled` is `true` (or `isPlusDisabled` is `true` for the plus button), custom colors such as `btnPlusColor` and `btnPlusBackgroundColor` are ignored and the disabled style is shown instead.
- **Minus button at zero.** When `textQuantity` is `0` and `btnMinusColor` is not set, the minus icon uses the disabled color.
- **Plus and minus icon colors** are applied as the button's foreground color. Set `btnPlusColor` / `btnMinusColor` for the icon, and `btnPlusBackgroundColor` / `btnMinusBackgroundColor` for the circle behind it.
- **Animation.** See the [Animation](#animation) section for the quantity roll and the collapsible expand / collapse timings.
- **Collapsible type.** Tapping the trigger when `textQuantity` is `0` sets the quantity to `1`. Tapping minus at a quantity of `1` or less collapses the stepper.
- **Icon and Number types** have a fixed size of 32×32.

---

*For further customization, inherit `EDTSButtonStepper` and override its layout methods, or contact the UX Engineering team.*
