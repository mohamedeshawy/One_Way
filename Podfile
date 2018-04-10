# Uncomment the next line to define a global platform for your project
 platform :ios, '9.0'

target 'Graduation Project' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Graduation Project

pod 'Firebase/Core'
pod 'FirebaseUI/Auth'
pod 'Firebase/Database'
pod 'Firebase/Storage'
pod 'Alamofire', '~> 4.5'
pod 'SDWebImage/WebP'
pod 'GoogleMaps'
pod 'SwiftyJSON'
pod 'MapboxNavigation', '~> 0.14'

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |configuration|
            # these libs work now only with Swift3.2 in Xcode9
            if ['ObjectMapper'].include? target.name
                configuration.build_settings['SWIFT_VERSION'] = "3.2"
            end
        end
      end
    end
end
