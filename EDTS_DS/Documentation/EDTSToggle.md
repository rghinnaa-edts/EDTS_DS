# EDTSToggle

The `EDTSToggle` component is a lightweight, animated on/off switch built for UIKit. It supports a sliding indicator with spring-based animation, optional state-specific icons, fully customizable sizing and colors, and `IBDesignable` support for Interface Builder assembly.

## Features

- Animated on/off states with spring-based indicator transition
- Configurable track and indicator colors for both `off` and `on` states
- Optional icon swap between `off` and `on` states
- Fully adjustable sizing: track width, indicator size, and indicator padding
- Configurable drop shadow on the track container
- `IBDesignable` / `IBInspectable` support for Interface Builder assembly
- Proper `intrinsicContentSize` tracking for use inside `UIStackView`

---

## Preview

### By State

| State | Preview |
|---|---|
| `off` | _Add preview image_ |
| `on` | _Add preview image_ |
| `on` (with icon) | _Add preview image_ |

---

## Installation

Add to your project:
- `EDTSToggle.swift`
- `EDTSToggle.xib`

---

## Usage

### Basic

```swift
toggle.isActive = false
toggle.delegate = self
```

### With Active State

```swift
toggle.trackTintColor = EDTSColor.grey30
toggle.trackActiveTintColor = EDTSColor.blue50
toggle.isActive = true
```

### With Icons

```swift
toggle.icon = UIImage(named: "ic_moon")
toggle.iconActive = UIImage(named: "ic_sun")
toggle.isActive = false
```

### Custom Sizing

```swift
toggle.trackWidth = 52
toggle.indicatorSize = 20
toggle.indicatorPadding = 3
```

---

## Public Interface

### Content

| Property | Type | Default | Description |
|---|---|---|---|
| `icon` | `UIImage?` | `nil` | Image displayed inside the indicator while the toggle is `off` |
| `iconActive` | `UIImage?` | `nil` | Image displayed inside the indicator while the toggle is `on` |

### State

| Property | Type | Default | Description |
|---|---|---|---|
| `isActive` | `Bool` | `false` | Current on/off state of the toggle. Setting this updates the internal state and animates the transition |

### Colors

| Property | Type | Default | Description |
|---|---|---|---|
| `trackTintColor` | `UIColor` | `EDTSColor.grey30` | Track background color while `off` |
| `trackActiveTintColor` | `UIColor` | `EDTSColor.blue50` | Track background color while `on` |
| `indicatorColor` | `UIColor` | `EDTSColor.white` | Indicator (knob) color while `off` |
| `indicatorActiveColor` | `UIColor` | `EDTSColor.white` | Indicator (knob) color while `on` |

### Sizing

| Property | Type | Default | Description |
|---|---|---|---|
| `trackWidth` | `CGFloat` | `44` | Width of the track container |
| `indicatorSize` | `CGFloat` | `16` | Width and height of the indicator (knob) |
| `indicatorPadding` | `CGFloat` | `2` | Inset between the indicator and the edge of the track. Also used to derive track height (`indicatorSize + indicatorPadding * 2`) |

### Shadow

| Property | Type | Default | Description |
|---|---|---|---|
| `shadowOpacity` | `Float` | `0.0` | Opacity of the track container drop shadow |
| `shadowOffset` | `CGSize` | `.zero` | Offset of the track container drop shadow |
| `shadowRadius` | `CGFloat` | `0.0` | Blur radius of the track container drop shadow |
| `shadowColor` | `UIColor?` | `.black` | Color of the track container drop shadow |

> Note: the indicator (knob) itself always renders with a fixed built-in shadow (`opacity: 0.15`, `offset: (0, 1)`, `radius: 3.0`, `color: EDTSColor.grey50`), separate from the configurable track shadow above.

---

## Delegate

```swift
@MainActor
public protocol EDTSToggleDelegate: AnyObject {
    func didTapToggle(active isActive: Bool, _ alertbox: EDTSToggle)
}
```

Assign `toggle.delegate` to receive a callback whenever the user taps the track. The toggle flips its own internal state and animates before notifying the delegate of the new `isActive` value.

---

## Animation

Triggered when the toggle state changes (via tap or by setting `isActive`).

| Property | Value | Notes |
|---|---|---|
| Duration | `0.25s` | Spring-based animation |
| Damping | `0.75` | `usingSpringWithDamping` |
| Initial Velocity | `0.4` | `initialSpringVelocity` |
| Curve | `curveEaseInOut` | UIKit easing curve option |
| Indicator Position | `indicatorPadding` → `trackWidth - indicatorSize - indicatorPadding` | Leading constraint slides the indicator across the track |
| Track / Indicator Color | `off` color → `on` color | Animated alongside the position change |

---

*For further customization, inherit `EDTSToggle` and override its setup methods, or contact the UX Engineering team.*
