# Uncomment the next line to define a global platform for your project
# platform :ios, '13.0'

target 'DoubleRoulette' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for SampleLocation 
  pod 'Firebase/Crashlytics'
  pod 'Firebase/Analytics'
  pod 'Firebase/Core'
  pod 'Google-Mobile-Ads-SDK'
  pod 'CellAnimator'
  pod 'R.swift'
  pod 'SwiftLint'
  pod 'RealmSwift'
  pod 'AMColorPicker'

  # Pods for DoubleRoulette
  target 'DoubleRouletteUITests' do
    inherit! :search_paths
    pod 'Firebase'
  end
end

#post_install do |installer|
#  installer.pods_project.targets.each do |target|
#    target.build_configurations.each do |config|
#      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.2'
#    end
#  end
#end