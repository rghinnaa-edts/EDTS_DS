# EDTS_DS Animation

This document covers the collection of animation helpers used across `EDTS_DS` for adding motion and visual feedback to views. It covers three areas: gradient/neon border effects and pulsing glow effects on `UIView`, a reusable "floating away" animation via `AnimationHelper`, and scroll-triggered entrance animations (scale and fade) for `UICollectionView` cells.

## Table of Contents

- [UIView Extensions](#uiview-extensions)
  - [startAnimationGradientBorder / stopAnimationGradientBorder](#startanimationgradientborder--stopanimationgradientborder)
  - [startAnimationNeonPulse / stopAnimationNeonPulse](#startanimationneonpulse--stopanimationneonpulse)
- [AnimationHelper](#animationhelper)
  - [animateFloating](#animatefloating)
- [Scroll Animations](#scroll-animations)
  - [animateScale](#animatescale)
  - [animateFade](#animatefade)

---

## Preview
| Feature / Variation | Preview |
| -------------------- | ------- |
| **Gradient Border** | *(add preview asset)* |
| **Neon Pulse** | *(add preview asset)* |
| **Floating Animation** | *(add preview asset)* |
| **Scroll Scale Animation** | *(add preview asset)* |
| **Scroll Fade Animation** | *(add preview asset)* |

---

## UIView Extensions

### startAnimationGradientBorder / stopAnimationGradientBorder

Adds an animated, rotating gradient border around a view by masking a `CAGradientLayer` with a `CAShapeLayer` stroke path, then continuously animating the gradient's `startPoint`/`endPoint` around the corners. `stopAnimationGradientBorder` smoothly fades the border back down to a single solid color before it disappears.

```swift
func startAnimationGradientBorder(
    width: CGFloat = 2,
    colors: [UIColor] = [EDTSColor.white, EDTSColor.blue30],
    duration: TimeInterval = 2.0
)

func stopAnimationGradientBorder(withDuration duration: TimeInterval = 0.5)
```

| Parameter | Type | Default | Description |
| --------- | ---- | ------- | ----------- |
| `width` | `CGFloat` | `2` | Stroke width of the border |
| `colors` | `[UIColor]` | `[EDTSColor.white, EDTSColor.blue30]` | Gradient colors used for the border |
| `duration` | `TimeInterval` | `2.0` (start) / `0.5` (stop) | Duration of one full rotation loop (start) or the fade-out transition (stop) |

**Example:**
```swift
cardView.startAnimationGradientBorder(width: 3, colors: [EDTSColor.blue30, EDTSColor.white], duration: 1.5)

// Later, when the loading state ends
cardView.stopAnimationGradientBorder()
```

---

### startAnimationNeonPulse / stopAnimationNeonPulse

Creates a pulsing glow effect by animating the view's `CALayer` shadow radius and opacity back and forth indefinitely, simulating a neon light effect.

```swift
func startAnimationNeonPulse(
    color: CGColor = EDTSColor.blue30.cgColor,
    duration: TimeInterval = 1.0
)

func stopAnimationNeonPulse()
```

| Parameter | Type | Default | Description |
| --------- | ---- | ------- | ----------- |
| `color` | `CGColor` | `EDTSColor.blue30.cgColor` | Shadow (glow) color |
| `duration` | `TimeInterval` | `1.0` | Duration of one pulse cycle (radius/opacity animate up then autoreverse back down) |

**Example:**
```swift
notificationDot.startAnimationNeonPulse(color: EDTSColor.errorStrong.cgColor, duration: 1.2)

// Stop pulsing, e.g. once the notification is read
notificationDot.stopAnimationNeonPulse()
```

---

## AnimationHelper

A small class wrapping a single composite "floating away" animation — commonly used for effects like a "+1" or reward icon drifting upward, scaling, and fading out before being dismissed.

```swift
public class AnimationHelper {
    public init()
    
    public func animateFloating(
        view: UIView,
        distance: CGFloat,
        duration: TimeInterval,
        onEnd: @escaping () -> Void
    )
}
```

### animateFloating

| Parameter | Type | Description |
| --------- | ---- | ----------- |
| `view` | `UIView` | The view to animate |
| `distance` | `CGFloat` | Vertical distance (in points) the view floats upward, measured from its current `center.y` |
| `duration` | `TimeInterval` | Base duration used to derive the timing of all three concurrent animations |
| `onEnd` | `@escaping () -> Void` | Called once the animation sequence fully completes |

**Example:**
```swift
let helper = AnimationHelper()

helper.animateFloating(view: rewardBadge, distance: 80, duration: 1.0) {
    rewardBadge.removeFromSuperview()
}
```

---

## Scroll Animations

Free functions (not extensions) intended to be called from a `UIScrollViewDelegate`'s `scrollViewDidScroll` to animate `UICollectionView` cells into view as they first become visible. Both functions share module-level state (`lastContentOffset`, `visibleCellsBeforeScroll`) to track which cells have already been animated and the scroll direction.

### animateScale

```swift
public func animateScale(_ collectionView: UICollectionView, _ scrollView: UIScrollView)
```

| Parameter | Type | Description |
| --------- | ---- | ----------- |
| `collectionView` | `UICollectionView` | The collection view whose visible cells should be animated |
| `scrollView` | `UIScrollView` | The scroll view being observed (typically the same instance as `collectionView`) |

**Example:**
```swift
func scrollViewDidScroll(_ scrollView: UIScrollView) {
    animateScale(myCollectionView, scrollView)
}
```

---

### animateFade

```swift
public func animateFade(_ collectionView: UICollectionView, _ scrollView: UIScrollView)
```

| Parameter | Type | Description |
| --------- | ---- | ----------- |
| `collectionView` | `UICollectionView` | The collection view whose visible cells should be animated |
| `scrollView` | `UIScrollView` | The scroll view being observed (typically the same instance as `collectionView`) |

**Example:**
```swift
func scrollViewDidScroll(_ scrollView: UIScrollView) {
    animateFade(myCollectionView, scrollView)
}
```

---

*For further customization, you can ask UX Engineer or extend these methods, or add additional functionality as required.*
