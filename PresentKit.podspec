#
#  Be sure to run `pod spec lint PresentKit.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "PresentKit"
  spec.version      = "1.0"
  spec.summary      = "PresentKit is a repo  you can create a custom UIPresentationController"

  spec.homepage     = "https://github.com/mozartee/PresentKit"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "zengxiang" => "jone20151208@gmail.com" }
  spec.platform     = :ios, "8.0"

  spec.source       = { :git => "https://github.com/mozartee/PresentKit.git", :tag => "#{spec.version}" }
  spec.source_files  = "PresentKitDemo/PresentKitDemo/PresentKit/**/*.{h,m}"
  spec.framework  = "UIKit"

end
