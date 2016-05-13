platform :ios, '8.0'
use_frameworks!

pod 'TesseractOCRiOS', '4.0.0'
# pod 'MMDrawerController', '~> 0.5.7'
pod 'LGSideMenuController', '~> 1.0.0'
# pod 'FVVerticalSlideView', '~> 0.1.1'
pod 'FVVerticalSlideView', :git => 'git@github.com:superarts/FVVerticalSlideView.git'

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ENABLE_BITCODE'] = 'NO'
    end
  end
end