platform :macos, '10.15'
inhibit_all_warnings!
use_frameworks!

def bdd
  pod 'Quick'
  pod 'Nimble'
end

pod 'SwiftLint'                   # enforce Swift style and conventions

target 'SpartaConnect' do
  pod 'SwinjectAutoregistration'  # autoregister using init for dependency injection
  pod 'Sparkle'                   # auto-update the app
  pod 'LetsMove'                  # move app to Applications folder
  pod 'NSBundle+LoginItem',       # launch at login option
    # fix memory issues, expose setter in header
    # https://github.com/nklizhe/NSBundle-LoginItem/pull/7
    :git => 'https://github.com/paulz/NSBundle-LoginItem.git'

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
    :git => 'https://github.com/paulz/NSBundle-LoginItem.git'
end
