source 'https://github.com/CocoaPods/Specs.git'
platform :ios ,'12.0'
inhibit_all_warnings!
target 'ADAlertController-swift' do
use_frameworks!
 pod 'SnapKit'
 pod 'SwiftLint', :configurations => ['Debug']

end

##6.0.7bug修复 消除警告
#post_install do |installer|
#  installer.pods_project.targets.each do |target|
#    target.build_configurations.each do |config|
#      if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 9.0
#        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
#      end
#    end
#  end
#end
