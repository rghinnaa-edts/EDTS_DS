# EDTSProgressTracker

`EDTSProgressTracker` is a customizable progress bar component that supports single-lap and multi-lap progress (values that exceed `maxValue`), an optional trailing indicator dot, an optional lap-count badge, gradient backgrounds, a simplified loading mode, a continuous intermittent (indeterminate) animation mode, and debounced/queued fill animations so rapid value updates animate smoothly instead of janking.

## Preview

| Feature / Variation | Description |
| -------------------- | ----------- |
| **Single-Lap** | ![Single-Lap Progress Tracker](https://res.cloudinary.com/dacnnk5j4/image/upload/w_500,c_scale,q_auto,f_auto/v1783924407/progress_tracker_limit_100_w6rw42.gif) |
| **Multi-Lap** | ![Multi-Lap Progress Tracker](https://res.cloudinary.com/dacnnk5j4/image/upload/w_500,c_scale,q_auto,f_auto/v1783924410/progress_tracker_limit_500_dte4bz.gif) |
| **Intermittent-Stretch** | ![Intermittent-Stretch Progress Tracker](https://res.cloudinary.com/dacnnk5j4/image/upload/w_500,c_scale,q_auto,f_auto/v1784535807/stretch_crpiqe.gif) |
| **Intermittent-Fixed** | ![Intermittent-Fixed Progress Tracker](https://res.cloudinary.com/dacnnk5j4/image/upload/w_500,c_scale,q_auto,f_auto/v1784535807/fixed_kpuqma.gif) |

## Anatomy

![Progress Tracker Anatomy](https://res.cloudinary.com/dacnnk5j4/image/upload/w_1000,c_scale,q_auto,f_auto/v1784182909/Docs_n1dare.png)

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
- `limitValue` caps the maximum value the tracker will accept (values above it are clamped). Setting `limitValue` above `maxValue` is what enables multi-lap / badge behavior; if `limitValue` is not greater than `maxValue`, the **badge** stays hidden even if `isHasBadge` is `true` — however, the full-track (completed-lap) layer still becomes visible whenever `value` reaches a multiple of `maxValue`, regardless of `limitValue`.
- Rapid, successive value changes within a 300ms window are debounced. If several updates land in the same debounce window (or the jump between the last processed value and the new target exceeds two laps), intermediate lap animations are compressed into a single "spam" animation instead of animating every lap individually, keeping the UI responsive.
- All lap/partial-fill animations are queued and run sequentially (`animationQueue`), so overlapping updates never interrupt an in-flight animation.
- Setting `isLoadingState` to `true` switches the tracker into a simplified loading mode: it cancels any pending debounce timer and queued animations, hides the full-track (lap) layer, and forces `limitValue` to `maxValue`. While active, `value` changes bypass the debounced multi-lap logic and animate as a single interruptible fill instead.
- Setting `isIntermittentState` to `true` starts a continuous, looping fill animation that ignores `value` entirely (useful for indeterminate progress); its visual style is controlled by `intermittentAnimationType`. Setting it back to `false` stops the animation and resets the fill.

## Properties Reference

### General Properties

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `value` | `CGFloat` | `0.0` | Current progress value. Automatically clamped to `limitValue` and triggers a debounced fill animation. |
| `maxValue` | `CGFloat` | `100.0` | The value that represents one full "lap" of the track. |
| `limitValue` | `CGFloat` | `100.0` | Maximum value the tracker will accept; values above are clamped. Set above `maxValue` to enable multi-lap / badge behavior. |
| `isLoadingState` | `Bool` | `false` | Switches the tracker into a simplified loading mode (see Progress Behavior above): clears any queued/debounced animations, hides the full-track layer, and pins `limitValue` to `maxValue`. |

### Intermittent Animation Properties

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `isIntermittentState` | `Bool` | `false` | Starts/stops a continuous looping fill animation that ignores `value`, using the style set in `intermittentAnimationType`. |
| `intermittentAnimationType` | `String` | `"stretch"` | Style of the looping animation while `isIntermittentState` is `true`. `"stretch"` grows the fill from empty to full track width, then shrinks it back down. `"fixed"` slides a fixed-width bar (1/3 of the track width) across the track. Backed by the `IntermittentAnimationType` enum (`stretch`, `fixed`); unrecognized values fall back to `stretch`. |

### Track Properties

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `trackTintColor` | `UIColor?` | `white` (theme-dependent) | Track background color (ignored if gradient is set) |
| `trackTintColorStart` | `UIColor?` | `nil` | Start color for track gradient background |
| `trackTintColorEnd` | `UIColor?` | `nil` | End color for track gradient background |
| `trackColorOrientation` | `String?` | `"horizontal"` | Gradient direction for track: `"horizontal"` or `"vertical"` |
| `trackHeight` | `CGFloat` | `-1.0` | Height of the track; only applied when `>= 0` |
| `trackCornerRadius` | `CGFloat` | `-1.0` | Corner radius for track, full-track, and fill views; when `< 0`, corners are fully circular (pill shape) |
| `trackPaddingTop` | `CGFloat` | `-1.0` | Top inset applied to the full-track and fill views; only applied when `>= 0` |
| `trackPaddingBottom` | `CGFloat` | `-1.0` | Bottom inset applied to the full-track and fill views; only applied when `>= 0` |
| `trackPaddingLeading` | `CGFloat` | `-1.0` | Leading inset applied to the full-track and fill views; only applied when `>= 0` |
| `trackPaddingTrailing` | `CGFloat` | `-1.0` | Trailing inset applied to the full-track view; only applied when `>= 0` |

### Track Fill Properties

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `trackFillTintColor` | `UIColor?` | `clear` | Fill background color (ignored if gradient is set) |
| `trackFillTintColorStart` | `UIColor?` | `skyblueLeading` | Start color for fill gradient background |
| `trackFillTintColorEnd` | `UIColor?` | `skyblueTrailing` | End color for fill gradient background |
| `trackFillColorOrientation` | `String?` | `"horizontal"` | Gradient direction for fill: `"horizontal"` or `"vertical"` |

### Track Full (Completed Lap) Properties

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `trackFullTintColor` | `UIColor?` | `nil` | Background color shown once a lap is completed (ignored if gradient is set) |
| `trackFullTintColorStart` | `UIColor?` | `nil` | Start color for full-track gradient background |
| `trackFullTintColorEnd` | `UIColor?` | `nil` | End color for full-track gradient background |
| `trackFullColorOrientation` | `String?` | `"horizontal"` | Gradient direction for full-track: `"horizontal"` or `"vertical"` |

> **Note:** The full-track (completed-lap) layer becomes visible whenever the current lap reaches 100%. The lap-count **badge**, however, only appears when `isHasBadge` is `true` **and** `limitValue > maxValue`.

### Track Inner Shadow Properties

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `trackInnerShadowOpacity` | `Float` | `0.0` | Inner shadow opacity for the track |
| `trackInnerShadowRadius` | `CGFloat` | `0.0` | Inner shadow blur radius for the track |
| `trackInnerShadowOffset` | `CGSize` | `.zero` | Inner shadow offset for the track |
| `trackInnerShadowColor` | `UIColor?` | `black` | Inner shadow color for the track |

### Indicator Properties

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `isHasIndicator` | `Bool` | `false` | Shows/hides the trailing indicator dot |
| `indicatorTintColor` | `UIColor?` | `clear` | Indicator background color (ignored if gradient is set) |
| `indicatorTintColorStart` | `UIColor?` | `skyblueLeading` | Start color for indicator gradient background |
| `indicatorTintColorEnd` | `UIColor?` | `skyblueTrailing` | End color for indicator gradient background |
| `indicatorColorOrientation` | `String?` | `"horizontal"` | Gradient direction for indicator: `"horizontal"` or `"vertical"` |
| `indicatorSize` | `CGFloat` | `8` | Width/height of the indicator dot |
| `indicatorCornerRadius` | `CGFloat` | `-1.0` | Corner radius of the indicator; when `< 0`, the indicator is fully circular |

### Badge Properties

| Property Name | Type | Default | Description |
| -------------- | ---- | ------- | ----------- |
| `isHasBadge` | `Bool` | `false` | Shows/hides the lap-count badge (also requires `limitValue > maxValue` to display) |
| `badgeLabel` | `String?` | `nil` | Custom badge text |
| `badgeLabelAttributed` | `NSAttributedString?` | `nil` | Attributed badge text |
| `badgeLabelColor` | `UIColor?` | `white` | Badge label text color |
| `badgeFontName` | `String` | `""` (system font) | Custom font name for badge label (falls back to system font if not found) |
| `badgeFontSize` | `CGFloat` | `8` | Font size for badge label |
| `badgeFontWeight` | `String?` | `"bold"` | Font weight for badge label (`ultralight`, `thin`, `light`, `regular`, `medium`, `semibold`, `bold`, `heavy`, `black`) |
| `badgeTintColor` | `UIColor?` | `clear` | Badge background color (ignored if gradient is set) |
| `badgeTintColorStart` | `UIColor?` | `skyblueLeading` | Start color for badge gradient background |
| `badgeTintColorEnd` | `UIColor?` | `skyblueTrailing` | End color for badge gradient background |
| `badgeColorOrientation` | `String?` | `"horizontal"` | Gradient direction for badge: `"horizontal"` or `"vertical"` |
| `badgeSize` | `CGFloat` | `16` | Minimum width/height of the badge (grows to fit text + padding) |
| `badgeCornerRadius` | `CGFloat` | `-1.0` | Corner radius of the badge; when `< 0`, the badge is fully circular |
| `badgePaddingTop` | `CGFloat` | `2` | Top inset inside the badge |
| `badgePaddingBottom` | `CGFloat` | `2` | Bottom inset inside the badge |
| `badgePaddingLeading` | `CGFloat` | `4` | Leading inset inside the badge |
| `badgePaddingTrailing` | `CGFloat` | `4` | Trailing inset inside the badge |

> **Note:** If `badgeLabel` and `badgeLabelAttributed` are both left `nil`, the badge label is generated automatically on each completed lap (`x1`, `x2`, `x3`, ...). Setting either property disables the auto-generated lap text.

## Theme-Dependent Default Styling

On initialization, `EDTSProgressTracker` applies one of two default styles depending on `EDTSColor.theme`:

| Theme | Track Padding | Full Track Color | Track Color | Indicator | Badge | Inner Shadow |
| ----- | -------------- | ----------------- | ------------ | --------- | ----- | ------------- |
| `.klikIDM` | `1pt` all sides | `blue30` | `grey20` | Enabled | Enabled | Single inner shadow, `10%` opacity, `2pt` radius |
| `.poinku` | `0pt` all sides | `nil` | `white` | Disabled | Disabled | Dual inner shadow (top `8%`/`2pt` and bottom `10%`/`2pt`) |

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
| `Intermittent Stretch (Grow/Shrink)` | `700ms` grow + `700ms` shrink | `EaseInOut` | Fill grows from empty to the full track width, then its leading edge catches up to shrink it back to zero width; repeats continuously while `isIntermittentState` is `true` and `intermittentAnimationType` is `"stretch"` |
| `Intermittent Fixed (Grow/Slide/Shrink)` | `2100ms` total (`700ms` × 3), split proportionally across each segment | `Linear` | A fixed-width bar (1/3 of the track width) grows in from the leading edge, slides across the track, then shrinks off the trailing edge; repeats continuously while `intermittentAnimationType` is `"fixed"` |

## Notes

- Multi-lap / badge behavior requires `limitValue` to be set greater than `maxValue` — otherwise the **badge** layer stays hidden even if `isHasBadge` is `true`.

*For further customization, you can ask UX Engineer or inherit `EDTSProgressTracker` and override its methods, or add additional functionality as required.*
