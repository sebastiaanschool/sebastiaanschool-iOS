source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8'

workspace 'SebastiaanSchool'
xcodeproj 'SebastiaanSchool.xcodeproj'

target 'SebastiaanSchool' do
    pod 'ParseUI'
    pod 'Fabric'
    pod 'Crashlytics'
    pod 'ReactiveCocoa'
    pod 'TTTAttributedLabel'
    pod 'OneSignal'
end

target :test, :exclusive => true do 
    pod 'KIF', '~> 3.0'
    link_with 'SebastiaanSchool Tests'

    pod 'OCMock'
end

post_install do | installer |
    require 'fileutils'
    FileUtils.cp_r('Pods/Target Support Files/Pods-SebastiaanSchool/Pods-SebastiaanSchool-Acknowledgements.plist', 'Resources/Settings.bundle/Acknowledgements.plist', :remove_destination => true)
end
