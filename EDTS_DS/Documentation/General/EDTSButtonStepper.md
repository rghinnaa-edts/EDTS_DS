# EDTSButtonStepper
The `EDTSButtonStepper` component is a customable Stepper component for incrementing and decrementing numeric values through an intuitive, interactive interface.

## Preview
| Type | Variant `Blue` | Variant `White` |
|----------|-----|-----|
| `Icon` | ![Button Stepper Preview](https://res.cloudinary.com/dr6cm6n5f/image/upload/c_scale,w_100/v1772091335/icon-blue_f742s3.jpg)  | ![Button Stepper Preview](https://res.cloudinary.com/dr6cm6n5f/image/upload/c_scale,w_100/v1772091335/icon-white_lojajh.jpg) |
| `Number` | ![Button Stepper Preview](https://res.cloudinary.com/dr6cm6n5f/image/upload/c_scale,w_100/v1772091335/number-blue_svztcl.jpg) | ![Button Stepper Preview](https://res.cloudinary.com/dr6cm6n5f/image/upload/c_scale,w_100/v1772091335/number-white_thgfzy.jpg) |
| `Stepper` | ![Button Stepper Preview](https://res.cloudinary.com/dr6cm6n5f/image/upload/c_scale,w_200/v1772091338/stepper-blue_zp0eyq.gif) | ![Button Stepper Preview](https://res.cloudinary.com/dr6cm6n5f/image/upload/c_scale,w_200/v1772091338/stepper-white_vyu4b0.gif) |
| `Collapsible` | ![Button Stepper Preview](https://res.cloudinary.com/dr6cm6n5f/image/upload/c_scale,w_200/v1772167459/collapsible-blue_gcthuf.gif) | ![Button Stepper Preview](https://res.cloudinary.com/dr6cm6n5f/image/upload/c_scale,w_200/v1772167459/collapsible-white_hbvjak.gif) |

## Parameters
| Parameters                | Description                                                | Data Type                   |  Default Value               |
|---------------------------|------------------------------------------------------------|-----------------------------|------------------------------|
| `stepperVariant`          | Variant appearance of the button stepper                   | Enum String                 | `StepperVariant.blue`        |
| `stepperType`             | Type of the button stepper                                 | Enum String                 | `StepperType.stepper`        |
| `textQuantity`            | Value of the quantity                                      | Int                         | `0`                          |
| `textQuantityMultiple`    | Multiply value of the quantity when click "+"              | Int                         | `1`                          |
| `bgColor`                 | Background color of the button stepper                     | UIColor                     | `nil`                        |
| `btnMinusColor`           | Minus icon color of the button stepper                     | UIColor                     | `nil`                        |
| `btnMinusBackgroundColor` | Background color of the minus icon                         | UIColor                     | `nil`                        |
| `btnPlusColor`            | Plus icon color of the button stepper                      | UIColor                     | `nil`                        |
| `btnPlusBackgroundColor`  | Background color of the plus icon                          | UIColor                     | `nil`                        |
| `btnIconColor`            | Icon color of the stepper type "Icon"                      | UIColor                     | `nil`                        |
| `btnIconBackgroundColor`  | Background color at Icon of the stepper type "Icon"        | UIColor                     | `nil`                        |
| `btnNumberColor`          | Text color of the stepper type "Number"                    | UIColor                     | `nil`                        |
| `btnNumberBackgroundColor`| Background color at Text of the stepper type "Number"      | UIColor                     | `nil`                        |
| `borderWidth`             | Border width of the button stepper                         | CGFloat                     | `0.0`                        |
| `borderColor`             | Border color of the button stepper                         | UIColor                     | `nil`                        |
| `cornerRadius`            | Corner radius of the button stepper                        | CGFloat                     | `0.0`                        |
| `isDisabled`              | Disabled button stepper                                    | Bool                        | `false`                      |

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

## Installation
To use the `EDTSButtonStepper` component, please follow this step.

For now, It's available only when you add the Button Stepper class file of swift and XIB into your project. It placed at `EDTS_DS/Views/Components/General/ButtonStepper` and Add file ButtonStepper.swift. and then add ButtonStepper.XIB into your project

### Usage
1. if you're using view to storyboard, implement the class to `EDTSButtonStepper`
2. add the IBOutlet that extend class ButtonStepper
```Example
  @IBOutlet public weak var btnStepper: EDTSButtonStepper!
        
   btnStepper.delegate = self
        
   btnStepper.stepperVariant = StepperVariant.blue.rawValue
   btnStepper.stepperType = StepperType.collapsible.rawValue
   btnStepper.textQuantity = productQty
   btnStepper.textQuantityMultiple = 1
   btnStepper.isDisabled = false

  ...
```

## Delegate Protocol
```protocol
  @MainActor
  public protocol ButtonStepperDelegate: AnyObject {
      func didSelectButtonCollapsible(show isShow: Bool)
      func didSelectButtonMinus(qty quantity: Int)
      func didSelectButtonPlus(qty quantity: Int)
  }
```

| Delegate | Description |
|----------|------------|
| didSelectButtonCollapsible | Delegate action from button Collapsible |
| didSelectButtonMinus | Delegate action from button minus |
| disSelectButtonPlus | Delegate action from button plus |

### Notes
- Default value of Variant is `Blue`
- Default value of Type is `Stepper`

*For further customization, inherit `EDTSTooltip` and override its private layout methods, or contact the UX Engineering team.*
