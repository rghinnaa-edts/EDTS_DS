# EDTSProgressTracker

`EDTSProgressTracker` is a customizable progress bar component that supports single-lap and multi-lap progress (values that exceed `maxValue`), an optional trailing indicator dot, an optional lap-count badge, gradient backgrounds, and debounced/queued fill animations so rapid value updates animate smoothly instead of janking.

## Preview

| Feature / Variation | Description |
| -------------------- | ----------- |
| **Single-Lap** | Lorem ipsum dolor sit amet |
| **Multi-Lap** | Lorem ipsum dolor sit amet |

## Basic Usage

### 1. Add to Layout

**Swift (Storyboard/XIB):**
```swift
// Add UIView from Interface Builder
// Set Custom Class to EDTSProgressTracker in Identity Inspector
```

**Swift (Programmatic):**
```swift
let progressTracker = EDTSProgressTracker(frame: .zero)
view.addSubview(progressTracker)
```

### 2. Initialize in Code

```swift
// Configure the progress tracker
progressTracker.maxValue = 100
progressTracker.limitValue = 300      // allows progress beyond maxValue (multi-lap)
progressTracker.isHasIndicator = true
progressTracker.isHasBadge = true

// Set initial value (value / max value) position
progressTracker.value = 45
```

## Progress Behavior

`EDTSProgressTracker` treats `maxValue` as the length of a single "lap" of the track. Setting `value` higher than `maxValue` completes one or more laps:

- Each time `value` crosses a multiple of `maxValue`, the fill animates to 100%, the badge (if enabled) updates its lap count label (`x1`, `x2`, ...) and pulses, and the fill then resets to animate the remaining partial lap.
- `limitValue` caps the maximum value the tracker will accept (values above it are clamped). Setting `limitValue` above `maxValue` is what enables multi-lap / badge behavior; if `limitValue` is not greater than `maxValue`, the badge and full-track-complete styling stay hidden even if `isHasBadge` is `true`.
- Rapid, successive value changes within a 300ms window are debounced. If several updates land in the same debounce window (or the jump between the last processed value and the new target exceeds two laps), intermediate lap animations are compressed into a single "spam" animation instead of animating every lap individually, keeping the UI responsive.
- All lap/partial-fill animations are queued and run sequentially (`animationQueue`), so overlapping updates never interrupt an in-flight animation.

## Properties Reference

### General Properties

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `value` | `CGFloat` | `0.0` | Current progress value. Automatically clamped to `limitValue` and triggers a debounced fill animation. |
| `maxValue` | `CGFloat` | `100.0` | The value that represents one full "lap" of the track. |
| `limitValue` | `CGFloat` | `100.0` | Maximum value the tracker will accept; values above are clamped. Set above `maxValue` to enable multi-lap / badge behavior. |

### Track Properties

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `trackTintColor` | `UIColor?` | `white` (theme-dependent) | Track background color (ignored if gradient is set) |
| `trackTintColorStart` | `UIColor?` | `nil` | Start color for track gradient background |
| `trackTintColorEnd` | `UIColor?` | `nil` | End color for track gradient background |
| `trackColorOrientation` | `String?` | `"horizontal"` | Gradient direction for track: `"horizontal"` or `"vertical"` |
| `trackHeight` | `CGFloat` | `-1.0` (unset) | Height of the track; only applied when `>= 0` |
| `trackCornerRadius` | `CGFloat` | `-1.0` (unset) | Corner radius for track, full-track, and fill views; when `< 0`, corners are fully circular (pill shape) |
| `trackPaddingTop` | `CGFloat` | `-1.0` (unset) | Top inset applied to the full-track and fill views; only applied when `>= 0` |
| `trackPaddingBottom` | `CGFloat` | `-1.0` (unset) | Bottom inset applied to the full-track and fill views; only applied when `>= 0` |
| `trackPaddingLeading` | `CGFloat` | `-1.0` (unset) | Leading inset applied to the full-track and fill views; only applied when `>= 0` |
| `trackPaddingTrailing` | `CGFloat` | `-1.0` (unset) | Trailing inset applied to the full-track view; only applied when `>= 0` |

### Fill Properties

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `fillTintColor` | `UIColor?` | `clear` | Fill background color (ignored if gradient is set) |
| `fillTintColorStart` | `UIColor?` | `skyblueLeading` | Start color for fill gradient background |
| `fillTintColorEnd` | `UIColor?` | `skyblueTrailing` | End color for fill gradient background |
| `fillColorOrientation` | `String?` | `"horizontal"` | Gradient direction for fill: `"horizontal"` or `"vertical"` |

### Full Track (Completed Lap) Properties

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `fullTrackTintColor` | `UIColor?` | `nil` | Background color shown once a lap is completed (ignored if gradient is set) |
| `fullTrackTintColorStart` | `UIColor?` | `nil` | Start color for full-track gradient background |
| `fullTrackTintColorEnd` | `UIColor?` | `nil` | End color for full-track gradient background |
| `fullTrackColorOrientation` | `String?` | `"horizontal"` | Gradient direction for full-track: `"horizontal"` or `"vertical"` |

> **Note:** The full-track layer (and its fade-in animation) is only shown between laps when `limitValue > maxValue` **and** a full-track color (solid or gradient) is set.

### Indicator Properties

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `isHasIndicator` | `Bool` | `false` | Shows/hides the trailing indicator dot |
| `indicatorTintColor` | `UIColor?` | `clear` | Indicator background color (ignored if gradient is set) |
| `indicatorTintColorStart` | `UIColor?` | `skyblueLeading` | Start color for indicator gradient background |
| `indicatorTintColorEnd` | `UIColor?` | `skyblueTrailing` | End color for indicator gradient background |
| `indicatorColorOrientation` | `String?` | `"horizontal"` | Gradient direction for indicator: `"horizontal"` or `"vertical"` |
| `indicatorSize` | `CGFloat` | `8` | Width/height of the indicator dot |
| `indicatorCornerRadius` | `CGFloat` | `-1.0` (unset) | Corner radius of the indicator; when `< 0`, the indicator is fully circular |

### Badge Properties

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `isHasBadge` | `Bool` | `false` | Shows/hides the lap-count badge (also requires `limitValue > maxValue` to display) |
| `badgeLabel` | `String?` | `nil` | Custom badge text (overrides the auto-generated `xN` lap label) |
| `badgeLabelAttributed` | `NSAttributedString?` | `nil` | Attributed badge text (overrides `badgeLabel` and the auto-generated `xN` lap label) |
| `badgeLabelColor` | `UIColor?` | `white` | Badge label text color |
| `badgeFontName` | `String` | `""` (system font) | Custom font name for badge label (falls back to system font if not found) |
| `badgeFontSize` | `CGFloat` | `8` | Font size for badge label |
| `badgeFontWeight` | `String?` | `"bold"` | Font weight for badge label (`ultralight`, `thin`, `light`, `regular`, `medium`, `semibold`, `bold`, `heavy`, `black`) |
| `badgeTintColor` | `UIColor?` | `clear` | Badge background color (ignored if gradient is set) |
| `badgeTintColorStart` | `UIColor?` | `skyblueLeading` | Start color for badge gradient background |
| `badgeTintColorEnd` | `UIColor?` | `skyblueTrailing` | End color for badge gradient background |
| `badgeColorOrientation` | `String?` | `"horizontal"` | Gradient direction for badge: `"horizontal"` or `"vertical"` |
| `badgeSize` | `CGFloat` | `16` | Minimum width/height of the badge (grows to fit text + padding) |
| `badgeCornerRadius` | `CGFloat` | `-1.0` (unset) | Corner radius of the badge; when `< 0`, the badge is fully circular |
| `badgePaddingTop` | `CGFloat` | `2` | Top inset inside the badge |
| `badgePaddingBottom` | `CGFloat` | `2` | Bottom inset inside the badge |
| `badgePaddingLeading` | `CGFloat` | `4` | Leading inset inside the badge |
| `badgePaddingTrailing` | `CGFloat` | `4` | Trailing inset inside the badge |

> **Note:** If `badgeLabel` and `badgeLabelAttributed` are both left `nil`, the badge label is generated automatically on each completed lap (`x1`, `x2`, `x3`, ...). Setting either property disables the auto-generated lap text.

### Inner Shadow Properties

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `trackInnerShadowOpacity` | `Float` | `0.0` | Inner shadow opacity for the track |
| `trackInnerShadowRadius` | `CGFloat` | `0.0` | Inner shadow blur radius for the track |
| `trackInnerShadowOffset` | `CGSize` | `.zero` | Inner shadow offset for the track |
| `trackInnerShadowColor` | `UIColor?` | `black` | Inner shadow color for the track |

## Theme-Dependent Default Styling

On initialization, `EDTSProgressTracker` applies one of two default styles depending on `EDTSColor.theme`:

| Theme | Track Padding | Full Track Color | Track Color | Indicator | Badge | Inner Shadow |
| ----- | -------------- | ----------------- | ------------ | --------- | ----- | ------------- |
| `.klikIDM` | `1pt` all sides | `blue30` | `grey20` | Enabled | Enabled | Single inner shadow, `10%` opacity, `2pt` radius |
| `.poinku` | `0pt` all sides | `nil` | `white` | Disabled | Disabled | Dual inner shadow (top `8%`/`2pt` and bottom `10%`/`2pt`) |

> When theme is `.poinku`, setting `limitValue` greater than `maxValue` automatically sets `fullTrackTintColor` to `blue10`; setting it back to `maxValue` or below resets `fullTrackTintColor` to `clear`.

## Animation Details

| Animation Type | Duration | Easing | Description |
| -------------- | -------- | ------ | ----------- |
| `Value Debounce` | `300ms` | — | Rapid successive `value` updates are debounced before triggering fill animations |
| `Fill Width (Partial)` | `800ms` | `EaseInOut` | Animates the fill width to the target value within the current lap |
| `Fill Width (Lap Complete)` | `800ms` | `EaseInOut` | Animates the fill to 100% width when a lap is completed |
| `Indicator Scale Down` | `200ms` | `EaseInOut` | Scales the indicator dot down to near-zero before the fill animates |
| `Indicator Scale Up` | `200ms` | `EaseInOut` | Scales the indicator dot back up to full size once the fill animation completes |
| `Badge Scale Up` | `200ms` | `EaseInOut` | Scales the badge in from zero on the first completed lap |
| `Badge Pulse` | `200ms` + `200ms` | `EaseInOut` | Scales the badge up to `110%` then back to `100%` on each subsequent completed lap |
| `Full Track Fade` | `400ms` | `EaseInOut` | Cross-fades the fill out and the full-track (completed) layer in between laps |

## Notes

- Multi-lap / badge behavior requires `limitValue` to be set greater than `maxValue` — otherwise the tracker behaves as a standard single-pass progress bar and the full-track/badge layers stay hidden.

*For further customization, you can ask UX Engineer or inherit `EDTSProgressTracker` and override its methods, or add additional functionality as required.*
