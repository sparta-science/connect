platform :macos, '10.15'
inhibit_all_warnings!
use_frameworks!

def bdd
  pod 'Quick'
  pod 'Nimble'
end


target 'App' do
  pod 'Sparkle'
  pod 'LetsMove'
  
  target 'AppSpecs' do
    inherit! :search_paths
    bdd
  end
end

target 'UnitSpecs' do
  inherit! :search_paths
  bdd
end
