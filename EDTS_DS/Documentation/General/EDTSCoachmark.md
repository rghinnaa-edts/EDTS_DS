# EDTSCoachmark
The `EDTSCoachmark` component is a visual overlay element that helps guide users through the app's features and functionality.

## Features
-  Customizable coachmark UI implementation
-  Provides step-by-step coachmark by using Arrays
-  Provides an option to attach/anchor to a specific view in the layout

## Preview
![Coachmark Preview](https://res.cloudinary.com/dr6cm6n5f/image/upload/c_scale,w_200/q_auto/f_auto/v1775039040/Coachmark_ko1uju.gif)

## Methods
- `configureSteps(steps: [CoachmarkStepConfig])`
- `show(animated: Bool = true, completion: (() -> Void)? = nil)`
- `dismiss(animated: Bool = true, completion: (() -> Void)? = nil)`

#### Parameters:
| Parameters              | Description                 | Type          | Default Value                     |
|-------------------------|-----------------------------|---------------|-----------------------------------|
| `coachmarkType`         | Type of Coachmark           | `Enum String` | `CoachmarkType.multiple.rawValue` |
| `stepConjunction`       | Conjunction of Step Text    | `String`      | `dari`                            |
| `titleFontName`         | Font name of title          | `String`      | `nil`                             |
| `titleFontSize`         | Font size of title          | `CGFloat`     | `18`                              |
| `titleFontWeight`       | Font weight of title        | `Enum String` | `FontWeight.regular.rawValue`     |
| `descFontName`          | Font name of description    | `String`      | `nil`                             |
| `descFontSize`          | Font size of description    | `CGFloat`     | `14`                              |
| `descFontWeight`        | Font weight of description  | `Enum String` | `FontWeight.regular.rawValue`     |
| `stepFontName`          | Font name of step           | `String`      | `nil`                             |
| `stepFontSize`          | Font size of step           | `CGFloat`     | `14`                              |
| `stepFontWeight`        | Font weight of step         | `Enum String` | `FontWeight.regular.rawValue`     |
| `iconTint`              | Icon tint color             | `UIColor`     | `nil`                             |
| `iconBgColor`           | Background Icon color       | `UIColor`     | `nil`                             |
| `isIconShow`            | Hide/Show Icon              | `Bool`        | `false`                           |
| `btnOutlinedTint`       | Button outlined tint color  | `UIColor`     | `nil`                             |
| `btnFilledTint`         | Button filled tint color    | `UIColor`     | `nil`                             |

#### Step Configuration:
| Step Configuration        | Description                                                  | Type                | Default Value       |
|---------------------------|--------------------------------------------------------------|---------------------|---------------------|
| `title`                   | Title of the coachmark                                       | `String`            | `required`          |
| `titleAttributted`        | Title attributted text of the coachmark                      | `NSAttributedString`| `nil`               |
| `description`             | Description of the coachmark                                 | `String`            | `required`          |
| `descriptionAttributted`  | Description attributted text of the coachmark                | `NSAttributedString`| `nil`               |
| `targetView`              | Relative view for coachmark's spotlight anchor               | `UIView`            | `nil`               |
| `endTargetView`           | Relative view for coachmark's end spotlight anchor           | `UIView`            | `nil`               |
| `btnOutlinedText`         | Change Text of Button Outlined                               | `String`            | `nil`               |
| `btnFilledText`           | Change Text of Button Filled                                 | `String`            | `nil`               |
| `isBtnOutlinedHide`       | Hide the Button Outlined                                     | `Bool`              | `false`             |
| `isBtnFilledHide`         | Hide the Button Filled                                       | `Bool`              | `false`             |
| `contentMargin`           | Horizontal Margin of coachmark to parent view (Left & Right) | `CGFloat`           | `24`                |
| `offsetMargin`            | Horizontal Offset of coachmark to parent view (Left)         | `CGFloat`           | `-1`                |
| `spotlightRadius`         | Corner radius of the spotlight                               | `CGFloat`           | `4`                 |
| `spotlightPadding`        | Spotlight padding (top,left,bottom,right)                    | `CGFloat`           | `8`                 |
| `spotlightPaddingLeft`    | Spotlight padding left                                       | `CGFloat`           | `nil`               |
| `spotlightPaddingRight`   | Spotlight padding right                                      | `CGFloat`           | `nil`               |
| `isTargetAList`           | Identify if the target is a list                             | `Bool`              | `false`             |
| `isHideSpotlight`         | For showing the coachmark without spotlight                  | `Bool`              | `false`             |

## Installation
To use the `EDTSCoachmark` component, please follow this step.
For now, It's available only when you add the coachmark class file of swift and XIB into your project. It placed at `EDTS_DS/Views/Components/General/Coachmark`
- Add file EDTSCoachmark.swift and EDTSCoachmark.XIB into your project

## Usage
Call function inside main thread
```
        DispatchQueue.main.async {
            self.showCoachmark()
        }
```

### Usage Example Show One Step
```Example Show One Step
        func showCoachmark() {
                let coachmark = EDTSCoachmark(frame: .zero)
                      
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
### Usage Example Show More Than One Step
```Example Show More Than One Step
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
                        description: "This step shows both start and end targets with dual spotlights",
                        targetView: vCard2
                    )
                ])
        
                coachmark.show()
        }
```

---

For further customization or to extend this component, you can ask UX Engineer or Inherit the `EDTSCoachmark` and override its methods or add additional functionality as required.
