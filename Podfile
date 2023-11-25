# Uncomment the next line to define a global platform for your project
platform :ios, '13.4'
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.4'
      end
    end
  end

target 'Tracker' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Tracker
  pod 'SwiftGen', '~> 6.0'
  pod 'YandexMobileMetrica/Dynamic', '4.5.2'

  target 'TrackerTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'TrackerUITests' do
    # Pods for testing
  end

end
