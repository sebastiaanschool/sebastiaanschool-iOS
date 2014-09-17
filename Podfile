platform :ios, '6'
pod 'TestFlightSDK'
pod 'Facebook-iOS-SDK'
pod 'Parse'
pod 'ReactiveCocoa'
pod 'TTTAttributedLabel'

target :test, :exclusive => true do 
    pod 'KIF', '~> 3.0'
    link_with 'SebastiaanSchool Tests'

    pod 'OCMock'
end

post_install do | installer |
    require 'fileutils'
    FileUtils.cp_r('Pods/Pods-Acknowledgements.plist', 'Resources/Settings.bundle/Acknowledgements.plist', :remove_destination => true)
end
