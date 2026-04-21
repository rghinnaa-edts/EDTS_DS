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
  spec.source_files = "EDTS_DS/**/*.{h,m,swift}"
  spec.resources    = "EDTS_DS/**/*.{xib,storyboard,xcassets,png,jpg,jpeg}"
  
  spec.framework    = "UIKit"
end