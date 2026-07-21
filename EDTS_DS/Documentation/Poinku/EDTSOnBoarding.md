# EDTSOnBoarding

The `EDTSOnBoarding` component is a self-contained, auto-scrolling onboarding carousel built for UIKit. It presents a series of full-bleed slides (image, title, description) with infinite looping, eased auto-advance, and a synced page indicator — used to introduce new users to an app, product, or service on first launch.

## Features

- Infinite, seamless looping between slides (first/last slides are wrapped internally)
- Auto-advances every 3 seconds using an eased (`easeInOutQuad`) custom scroll animation driven by `CADisplayLink`
- Auto-scroll automatically pauses while the user is dragging and resumes after the scroll settles
- Animated title/description transitions (fade + slide-up) on every page change
- Gradient fade overlay behind the title/description content for legibility over images
- Page indicator (`EDTSPageControl`) kept in sync with both auto-scroll and manual drag progress
- `IBOutlet`-based assembly via XIB, ready to drop into a storyboard `UIView`

---

## Preview

![OnBoarding Preview](https://res.cloudinary.com/dr6cm6n5f/image/upload/c_scale,w_300/v1745818109/WhatsApp_GIF_2025-04-28_at_12.27.44_nlgmkt.gif)

---

## Installation

Add the following files to your project. They live at `EDTS_DS/Views/Components/Poinku/OnBoarding/OnBoardingV1`:

- `EDTSOnBoarding.swift` — the onboarding container view
- `EDTSOnBoarding.xib` — its layout (collection view, page control, title/description labels, gradient container)
- `EDTSOnBoardingCell.swift` — the individual slide cell
- `EDTSOnBoardingCell.xib` — its layout (`ivSlide` image view)
- `EDTSOnBoardingSlide.swift` — the slide data model
- `EDTSPageControl` — the page indicator component used by `EDTSOnBoarding`
- Your onboarding image assets (e.g. `onboarding`, `onboarding2`, `onboarding3`)

Then:

1. Add a `UIView` to your View Controller's storyboard and set its class to `EDTSOnBoarding`.
2. Connect it to an `IBOutlet` in your View Controller.
3. Assign `slides` (see [Usage](#usage) below).
4. Call `viewWillAppear()` / `viewWillDisappear()` from the corresponding View Controller lifecycle methods (see [Lifecycle](#lifecycle)).
5. For a seamless look, lay the view out edge-to-edge behind the system bars.

---

## Usage

### Basic

```swift
@IBOutlet var onBoarding: EDTSOnBoarding!

private func setupSlides() {
    onBoarding.slides = [
        EDTSOnBoardingSlide(
            image: UIImage(named: "onboarding"),
            title: "Kumpulkan Poin dan Stamp Buat Dapetin Kejutan!",
            description: "Kumpulkan poin serta stamp dari setiap transaksi dan tukarkan dengan kupon menarik di sini!"),
        EDTSOnBoardingSlide(
            image: UIImage(named: "onboarding2"),
            title: "Dapetin Diskon, Bonus, Sampai Gratisan!",
            description: "Jangan lupa untuk gunakan kupon untuk mendapatkan banyak keuntungan!"),
        EDTSOnBoardingSlide(
            image: UIImage(named: "onboarding3"),
            title: "Semakin Sering Belanja, Semakin Untung!",
            description: "Makin sering kamu belanja semakin banyak bonus, serta diskon yang bisa kamu dapetin.")
    ]
}
```

### Lifecycle

`EDTSOnBoarding` does not start or stop its auto-scroll timer on its own — call these from your View Controller:

```swift
override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    onBoarding.viewWillAppear()
}

override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    onBoarding.viewWillDisappear()
}
```

- `viewWillAppear()` starts the auto-scroll timer and stops any running display link.
- `viewWillDisappear()` stops the auto-scroll timer, stops the display link, and clears the internal slide arrays.

### Full Code Example

See `EDTS_DS_Prototype/Views/Pages/Poinku/OnBoarding/OnBoardingViewController.swift` for a complete implementation.

---

## Public Interface

### `EDTSOnBoardingSlide`

```swift
public struct EDTSOnBoardingSlide {
    public init(image: UIImage?, title: String, description: String)
}
```

| Parameter | Type | Description |
|---|---|---|
| `image` | `UIImage?` | Image displayed full-bleed for the slide |
| `title` | `String` | Slide headline, shown in `lblTitle` |
| `description` | `String` | Slide body copy, shown in `lblDesc` |

### `EDTSOnBoarding`

| Property | Type | Default | Description |
|---|---|---|---|
| `slides` | `[EDTSOnBoardingSlide]` | `[]` | The slides to display. Setting this rebuilds the wrapped (looping) slide list, resets the collection view to the first real slide, and resets the page control |
| `currentPage` | `Int` | `0` | Index into the internal wrapped slide array reflecting the currently displayed page. Managed internally during scrolling/auto-advance |

### Methods

```swift
public func viewWillAppear()
public func viewWillDisappear()
```

| Method | Description |
|---|---|
| `viewWillAppear()` | Call from your View Controller's `viewWillAppear`. Starts the auto-scroll timer |
| `viewWillDisappear()` | Call from your View Controller's `viewWillDisappear`. Stops the auto-scroll timer and display link, and clears cached slide data |

### `EDTSOnBoardingCell`

```swift
public static let identifier: String

public func setup(_ image: UIImage?)
```

| Member | Description |
|---|---|
| `identifier` | Reuse identifier used internally when registering/dequeuing the cell |
| `setup(_:)` | Assigns the slide image to `ivSlide` with `.scaleAspectFill` content mode |

`prepareForReuse()` is overridden internally to clear `ivSlide.image` between reuses.

---

*For further customization, inherit `EDTSOnBoarding` and override its setup methods, or contact the UX Engineering team.*
