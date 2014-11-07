source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '7'

workspace 'SebastiaanSchool'
xcodeproj 'SebastiaanSchool.xcodeproj'

target 'SebastiaanSchool' do
    pod 'Facebook-iOS-SDK'
    pod 'ParseUI'
    pod 'ReactiveCocoa'
    pod 'TTTAttributedLabel'
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
