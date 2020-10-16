# Uncomment the next line to define a global platform for your project
platform :ios, '12.2'

target 'DoubleRoulette' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for SampleLocation 
  pod 'Firebase/Analytics'
  pod 'Firebase/Core'
  pod 'Firebase/AdMob'
  pod 'CellAnimator'
  pod 'R.swift'
  pod 'SwiftLint'

  # Pods for DoubleRoulette
  target 'DoubleRouletteUITests' do
    inherit! :search_paths
    pod 'Firebase'
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.2'
    end
  end
end