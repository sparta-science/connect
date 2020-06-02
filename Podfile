platform :macos, '10.15'
inhibit_all_warnings!

target 'App' do
  use_frameworks!
  pod 'Sparkle'
  
  target 'UnitSpecs' do
    pod 'Quick'
    pod 'Nimble'
    inherit! :search_paths
  end
end
