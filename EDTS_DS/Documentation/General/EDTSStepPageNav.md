# EDTSStepPageNav

The `EDTSStepPageNav` component is a 3-step progress indicator built for UIKit. It displays a horizontal timeline with step badges, titles, and animated progress dividers, highlighting the active step and animating the connector between completed steps.

## Features

- Fixed 3-step timeline layout (step badges + titles + connecting dividers)
- Automatic highlight color for the active and completed steps
- Animated progress fill on the divider when advancing between steps
- Bounce (scale) animation on the step badge when it becomes active/completed
- `IBOutlet`-based assembly via a companion XIB for Interface Builder layout

---

## Preview

![StepPageNav Preview](https://res.cloudinary.com/dr6cm6n5f/image/upload/c_scale,w_300/v1750737061/Step_Page_Navigation_gpwfuk.gif)

---

## Installation

Add to your project:
- `EDTSStepPageNav.swift`
- `EDTSStepPageNav.xib`

Both files are located at `EDTS_DS/Views/Components/General/EDTSStepPageNav`.

1. Add `EDTSStepPageNav.swift` and `EDTSStepPageNav.xib` to your project.
2. In your storyboard, add a `UIView` (recommended height: `16pt`) and set its custom class to `EDTSStepPageNav`.
3. Connect it to an `IBOutlet` in your view controller.
4. Configure it as shown in [Usage](#usage).

---

## Usage

### Basic

```swift
@IBOutlet var vStep: EDTSStepPageNav!

private func setupStep() {
    vStep.title = ["Isi Data Diri", "Verifikasi", "Buat PIN"]
    vStep.currentStep = 1 // fill with the current page number: 1, 2, or 3
}
```

### Full Code Example

See `EDTS_DS_Prototype/Views/Pages/Poinku/Register/Register1ViewController.swift` for a complete implementation.

---

## Public Interface

### Content

| Property | Type | Default | Description |
|---|---|---|---|
| `title` | `[String]` | `[]` | Titles displayed under each step badge. Must contain exactly 3 entries — assigned in order to step 1, 2, and 3 |
| `currentStep` | `Int` | `0` | The active step number (`1`, `2`, or `3`). Setting this value re-runs `setupUI()` and triggers the step/divider animation |

> Both `title` and `currentStep` are required for correct rendering; there is no default fallback presentation when they are unset.

---

## Step State Behavior

| `currentStep` | Step 1 | Step 2 | Step 3 | Divider 1 | Divider 2 |
|---|---|---|---|---|---|
| `1` | `blue30` (active, bounces) | `grey40` | `grey40` | `0%` | `0%` |
| `2` | `blue30` | `blue30` (animates to active, bounces) | `grey40` | Animates `0% → 100%` | `0%` |
| other (`3`+) | `blue30` | `blue30` | `blue30` (animates to active, bounces) | `100%` | Animates `0% → 100%` |

---

*For further customization, inherit `EDTSStepPageNav` and override its setup methods, or contact the UX Engineering team.*
