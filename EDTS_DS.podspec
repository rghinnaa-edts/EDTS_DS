Pod::Spec.new do |spec|
  spec.name         = "EDTS_DS"
  spec.version      = "0.1.0"
  spec.summary      = "UI Components and Animation"
  spec.description  = "UI Components and Animation of EDTS Apps"

  spec.homepage     = "https://github.com/rghinnaa-edts/EDTS_DS"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "Rizka Ghinna" => "rizka.ghinna@sg-dsa.com" }

  spec.platform     = :ios, "13.0"
  spec.swift_version = "5.0"

  spec.source       = { :git => "https://github.com/rghinnaa-edts/EDTS_DS.git", :tag => spec.version.to_s }
  spec.framework    = "UIKit"

  # ──────────────────────────────────────────────────────────
  # Helper: only assign `resources` if the pattern actually
  # matches a file. CocoaPods errors out on empty resource
  # patterns (e.g. components with no .xib), so this guards
  # against that for every subspec below.
  # ──────────────────────────────────────────────────────────
  podspec_dir = File.dirname(__FILE__)
  set_resources_if_present = lambda do |ss, pattern|
    ss.resources = pattern unless Dir.glob(File.join(podspec_dir, pattern)).empty?
  end

  # ──────────────────────────────────────────────────────────
  # Assets (shared foundation — Color, Font, xcassets)
  # ──────────────────────────────────────────────────────────

  spec.subspec 'Color' do |ss|
    ss.source_files = 'EDTS_DS/Assets/Color/**/*.swift'
  end

  spec.subspec 'Font' do |ss|
    ss.source_files = 'EDTS_DS/Assets/Font/**/*.swift'
    set_resources_if_present.call(ss, 'EDTS_DS/Assets/Font/Inter/*.{ttf,otf}')
  end

  spec.subspec 'Assets' do |ss|
    ss.resource_bundle = { 'EDTS_DSAssets' => 'EDTS_DS/Assets/**/*.xcassets' }
  end

  # ──────────────────────────────────────────────────────────
  # Animations
  # ──────────────────────────────────────────────────────────

  spec.subspec 'Animations' do |ss|
    ss.source_files = 'EDTS_DS/Views/Animations/**/*.swift'
    ss.dependency 'EDTS_DS/Color'
  end

  # ──────────────────────────────────────────────────────────
  # Helper
  # ──────────────────────────────────────────────────────────

  spec.subspec 'Helper' do |ss|
    ss.source_files = 'EDTS_DS/Views/Helper/**/*.swift'
  end

  # ──────────────────────────────────────────────────────────
  # Extensions
  # ──────────────────────────────────────────────────────────

  # Extensions
  spec.subspec 'Extensions' do |ss|
    ss.source_files = 'EDTS_DS/Views/Extensions/**/*.swift'
    set_resources_if_present.call(ss, "EDTS_DS/Views/Extensions/**/*.xib")
    ss.dependency 'EDTS_DS/Color'
    ss.dependency 'EDTS_DS/Font'
  end

  # ──────────────────────────────────────────────────────────
  # General components (shared across all brands)
  # ──────────────────────────────────────────────────────────

  general_components = %w[
    Card Checkbox Chip
    Loading Ribbon Search Skeleton
    StepPageNav Textfield Toggle Tooltip View
  ]

  general_components.each do |name|
    spec.subspec name do |ss|
      ss.source_files = "EDTS_DS/Views/Components/General/#{name}/**/*.swift"
      set_resources_if_present.call(ss, "EDTS_DS/Views/Components/General/#{name}/**/*.xib")
      ss.dependency 'EDTS_DS/Color'
      ss.dependency 'EDTS_DS/Font'
      ss.dependency 'EDTS_DS/Assets'
      ss.dependency 'EDTS_DS/Extensions'
    end
  end

  # Alertbox
  spec.subspec 'Alertbox' do |ss|
    ss.source_files = 'EDTS_DS/Views/Components/General/Alertbox/**/*.swift'
    set_resources_if_present.call(ss, "EDTS_DS/Views/Components/General/Alertbox/**/*.xib")
    ss.dependency 'EDTS_DS/Button'
  end

  # Badge
  spec.subspec 'Badge' do |ss|
    ss.source_files = 'EDTS_DS/Views/Components/General/Badge/**/*.swift'
    set_resources_if_present.call(ss, "EDTS_DS/Views/Components/General/Badge/**/*.xib")
    ss.dependency 'EDTS_DS/Skeleton'
  end

 # Button Default
  spec.subspec 'Button' do |ss|
    ss.source_files = 'EDTS_DS/Views/Components/General/Button/Default/**/*.swift'
    set_resources_if_present.call(ss, "EDTS_DS/Views/Components/General/Button/Default/**/*.xib")
    ss.dependency 'EDTS_DS/Color'
    ss.dependency 'EDTS_DS/Font'
    ss.dependency 'EDTS_DS/Assets'
    ss.dependency 'EDTS_DS/Signifier'
    ss.dependency 'EDTS_DS/Extensions'
  end

  # Button Icon
  spec.subspec 'ButtonIcon' do |ss|
    ss.source_files = 'EDTS_DS/Views/Components/General/Button/Icon/**/*.swift'
    set_resources_if_present.call(ss, "EDTS_DS/Views/Components/General/Button/Icon/**/*.xib")
    ss.dependency 'EDTS_DS/Button'
    ss.dependency 'EDTS_DS/Signifier'
    ss.dependency 'EDTS_DS/Extensions'
  end

 # Button Stepper
  spec.subspec 'ButtonStepper' do |ss|
    ss.source_files = 'EDTS_DS/Views/Components/General/Button/Stepper/**/*.swift'
    set_resources_if_present.call(ss, "EDTS_DS/Views/Components/General/Button/Stepper/**/*.xib")
    ss.dependency 'EDTS_DS/Color'
    ss.dependency 'EDTS_DS/Font'
    ss.dependency 'EDTS_DS/Assets'
    ss.dependency 'EDTS_DS/Signifier'
    ss.dependency 'EDTS_DS/Extensions'
  end

  # Coachmark
  spec.subspec 'Coachmark' do |ss|
    ss.source_files = 'EDTS_DS/Views/Components/General/Coachmark/**/*.swift'
    set_resources_if_present.call(ss, "EDTS_DS/Views/Components/General/Coachmark/**/*.xib")
    ss.dependency 'EDTS_DS/Button'
    ss.dependency 'EDTS_DS/Extensions'
  end

  # Dialog
  spec.subspec 'Dialog' do |ss|
    ss.source_files = 'EDTS_DS/Views/Components/General/Dialog/**/*.swift'
    set_resources_if_present.call(ss, "EDTS_DS/Views/Components/General/Dialog/**/*.xib")
    ss.dependency 'EDTS_DS/Button'
    ss.dependency 'EDTS_DS/Extensions'
  end

  # Progress Tracker
  spec.subspec 'ProgressTracker' do |ss|
    ss.source_files = 'EDTS_DS/Views/Components/General/ProgressTracker/**/*.swift'
    set_resources_if_present.call(ss, "EDTS_DS/Views/Components/General/ProgressTracker/**/*.xib")
    ss.dependency 'EDTS_DS/Color'
    ss.dependency 'EDTS_DS/Extensions'
    ss.dependency 'EDTS_DS/View'
  end

  # Radio Button
  spec.subspec 'RadioButton' do |ss|
    ss.source_files = 'EDTS_DS/Views/Components/General/RadioButton/**/*.swift'
    set_resources_if_present.call(ss, "EDTS_DS/Views/Components/General/RadioButton/**/*.xib")
    ss.dependency 'EDTS_DS/View'
  end

  # Signifier
  spec.subspec 'Signifier' do |ss|
    ss.source_files = 'EDTS_DS/Views/Components/General/Signifier/**/*.swift'
    set_resources_if_present.call(ss, "EDTS_DS/Views/Components/General/Signifier/**/*.xib")
    ss.dependency 'EDTS_DS/Skeleton'
  end

  # Tab
  spec.subspec 'Tab' do |ss|
    ss.source_files = 'EDTS_DS/Views/Components/General/Tab/**/*.swift'
    set_resources_if_present.call(ss, "EDTS_DS/Views/Components/General/Tab/**/*.xib")
    ss.dependency 'EDTS_DS/Chip'
    ss.dependency 'EDTS_DS/Skeleton'
    ss.dependency 'EDTS_DS/Extensions'
  end

  # Toast
  spec.subspec 'Toast' do |ss|
    ss.source_files = 'EDTS_DS/Views/Components/General/Toast/**/*.swift'
    set_resources_if_present.call(ss, "EDTS_DS/Views/Components/General/Toast/**/*.xib")
    ss.dependency 'EDTS_DS/Button'
    ss.dependency 'EDTS_DS/ButtonIcon'
  end

  # ──────────────────────────────────────────────────────────
  # KlikIDM brand-specific components (nested subspecs)
  # ──────────────────────────────────────────────────────────

  # Card Coupon Offered
  spec.subspec 'CouponOffered' do |ss|
    ss.source_files = 'EDTS_DS/Views/Components/KlikIDM/Card/CouponOffered/**/*.swift'
    set_resources_if_present.call(ss, "EDTS_DS/Views/Components/KlikIDM/Card/CouponOffered/**/*.xib")
    ss.dependency 'EDTS_DS/Badge'
    ss.dependency 'EDTS_DS/Button'
    ss.dependency 'EDTS_DS/Ribbon'
    ss.dependency 'EDTS_DS/Extensions'
    ss.dependency 'EDTS_DS/Helper'
  end

  # Card My Coupon
  spec.subspec 'MyCoupon' do |ss|
    ss.source_files = 'EDTS_DS/Views/Components/KlikIDM/Card/MyCoupon/**/*.swift'
    set_resources_if_present.call(ss, "EDTS_DS/Views/Components/KlikIDM/Card/MyCoupon/**/*.xib")
    ss.dependency 'EDTS_DS/Badge'
    ss.dependency 'EDTS_DS/Ribbon'
    ss.dependency 'EDTS_DS/Extensions'
    ss.dependency 'EDTS_DS/View'
  end

  # Card Product
  spec.subspec 'Product' do |ss|
    ss.source_files = 'EDTS_DS/Views/Components/KlikIDM/Card/Product/**/*.swift'
    set_resources_if_present.call(ss, "EDTS_DS/Views/Components/KlikIDM/Card/Product/**/*.xib")
    ss.dependency 'EDTS_DS/Badge'
    ss.dependency 'EDTS_DS/ButtonStepper'
    ss.dependency 'EDTS_DS/Extensions'
  end

  # Card Shopping Type
  spec.subspec 'ShoppingType' do |ss|
    ss.source_files = 'EDTS_DS/Views/Components/KlikIDM/Card/ShoppingType/**/*.swift'
    set_resources_if_present.call(ss, "EDTS_DS/Views/Components/KlikIDM/Card/ShoppingType/**/*.xib")
    ss.dependency 'EDTS_DS/Color'
    ss.dependency 'EDTS_DS/Font'
  end

  # ──────────────────────────────────────────────────────────
  # Poinku brand-specific components (nested subspecs)
  # ──────────────────────────────────────────────────────────

  spec.subspec 'Poinku' do |poinku|

    poinku.subspec 'Card' do |card|

      card_components = %w[Coupon Poin Stamp]

      card_components.each do |name|
        card.subspec name do |ss|
          ss.source_files = "EDTS_DS/Views/Components/Poinku/Card/#{name}/**/*.swift"
          set_resources_if_present.call(ss, "EDTS_DS/Views/Components/Poinku/Card/#{name}/**/*.xib")
          ss.dependency 'EDTS_DS/Color'
          ss.dependency 'EDTS_DS/Font'
          ss.dependency 'EDTS_DS/Ribbon'
        end
      end

    end   # closes 'Card'

    poinku.subspec 'OnBoarding' do |onboarding|

      # shared page control used by both V1 and V2
      onboarding.subspec 'PageControl' do |ss|
        ss.source_files = 'EDTS_DS/Views/Components/Poinku/OnBoarding/EDTSPageControl.swift'
      end

      onboarding_versions = %w[OnBoardingV1 OnBoardingV2]

      onboarding_versions.each do |name|
        onboarding.subspec name do |ss|
          ss.source_files = "EDTS_DS/Views/Components/Poinku/OnBoarding/#{name}/**/*.swift"
          set_resources_if_present.call(ss, "EDTS_DS/Views/Components/Poinku/OnBoarding/#{name}/**/*.xib")
          ss.dependency 'EDTS_DS/Color'
          ss.dependency 'EDTS_DS/Font'
          ss.dependency 'EDTS_DS/Poinku/OnBoarding/PageControl'
        end
      end

    end   # closes 'OnBoarding'

  end     # closes 'Poinku'

  # ──────────────────────────────────────────────────────────
  # Default install (bare `pod 'EDTS_DS'` with no subspec)
  # ──────────────────────────────────────────────────────────

  spec.default_subspecs = 'Color', 'Font', 'Assets'

end