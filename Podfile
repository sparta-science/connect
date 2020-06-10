platform :macos, '10.15'
inhibit_all_warnings!
use_frameworks!

def bdd
  pod 'Quick'
  pod 'Nimble'
end


target 'App' do
  pod 'Sparkle'             # auto-update the app
  pod 'LetsMove'            # move app to Applications folder
  pod 'NSBundle+LoginItem', # launch at login option
    :git => 'https://github.com/gotow/NSBundle-LoginItem.git'

  target 'AppSpecs' do
    inherit! :search_paths
    bdd
  end
end

target 'UnitSpecs' do
  inherit! :search_paths
  bdd
end

target 'UITests' do
  pod 'NSBundle+LoginItem', # launch at login option
    :git => 'https://github.com/gotow/NSBundle-LoginItem.git'
end
