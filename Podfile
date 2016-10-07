source 'https://github.com/CocoaPods/Specs.git'
use_frameworks!
platform :ios, '8'

workspace 'SebastiaanSchool'
project 'SebastiaanSchool.xcodeproj'

pod 'JsonApiClient' , :git => 'https://github.com/jeroenleenarts/JsonApiClient.git'

target 'SebastiaanSchool' do
    pod 'Fabric'
    pod 'Crashlytics'
    pod 'TTTAttributedLabel'
    pod 'RealmSwift'
    pod 'OneSignal'
end

target 'SebastiaanSchoolTests' do
    pod 'RealmSwift'
end

post_install do | installer |
    require 'fileutils'
    FileUtils.cp_r('Pods/Target Support Files/Pods-SebastiaanSchool/Pods-SebastiaanSchool-Acknowledgements.plist', 'Resources/Settings.bundle/Acknowledgements.plist', :remove_destination => true)
end
