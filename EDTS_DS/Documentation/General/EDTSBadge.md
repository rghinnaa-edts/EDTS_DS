# EDTSBadge

The `EDTSBadge` component is a customable Stepper component for incrementing and decrementing numeric values through an intuitive, interactive interface.

## Parameters

| Parameters                | Description                                                | Data Type                   |  Default Value               |
|---------------------------|------------------------------------------------------------|-----------------------------|------------------------------|
| `label`                   | Text value of label                                        | String                      | `nil`        |
| `labelAttributted`        | Text attributed value of label                             | NSAttributedString          | `nil`        |
| `labelColor`              | Text color of label                                        | UIColor                     | `nil`        |
| `labelFont`               | Text font of label                                         | UIFont                      | `nil`        |
| `icon`                    | Icon of badge                                              | UIImage                     | `nil`        |
| `iconTint`                | Icon color of badge                                        | UIColor                     | `nil`        |
| `iconPadding`             | Distance between icon and label                            | CGFloat                     | `0.0`        |
| `bgColor`                 | Background color of badge                                  | UIColor                     | `nil`        |
| `cornerRadius`            | Corner radius of badge                                     | CGFloat                     | `0.0`        |
| `borderWidth`             | Width of badge border                                      | CGFloat                     | `0.0`        |
| `borderColor`             | Color of badge border                                      | UIColor                     | `nil`        |
| `shadowColor`             | Color of badge shadow                                      | UIColor                     | `nil`        |
| `shadowOffset`            | Offset of badge shadow                                     | CGSize                      | `CGSize.zero`|
| `shadowRadius`            | Radius of badge shadow                                     | CGFloat                     | `0.0`        |
| `paddingTop`              | Distance between label and container top                   | CGFloat                     | `0.0`        |
| `paddingBottom`           | Distance between label and container bottom                | CGFloat                     | `0.0`        |
| `paddingLeading`          | Distance between label and container leading               | CGFloat                     | `0.0`        |
| `paddingTrailing`         | Distance between label and container trailing              | CGFloat                     | `0.0`        |
| `isSkeleton`              | Hide/Show skeleton of badge                                | Boolean                     | `false`      |


## Installation

To use the `EDTSBadge` component, please follow this step.

For now, It's available only when you add the Badge class file of swift and XIB into your project. It placed at `EDTS_DS/Views/Components/General/Badge` and Add file Badge.swift. and then add Badge.XIB into your project

### Usage

1. if you're using view to storyboard, implement the class to `EDTSBadge`
2. add the IBOutlet that extend class Badge
```Example
   @IBOutlet weak var badgeCoupon: EDTSBadge!
        
   badgeCoupon.label = "i-Kupon"
   badgeCoupon.bgColor = UIColor.blue20
   badgeCoupon.labelColor = UIColor.blue50
   badgeCoupon.cornerRadius = 4
   badgeCoupon.labelFont = UIFont.systemFont(ofSize: 10, weight: .semibold)

  ...
```

*For further customization, inherit `EDTSTooltip` and override its private layout methods, or contact the UX Engineering team.*
