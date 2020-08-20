platform :macos, '10.15'
inhibit_all_warnings!
use_frameworks!

def bdd
  pod 'Quick'
  pod 'Nimble'
end

pod 'SwiftLint'                   # enforce Swift style and conventions

target 'SpartaConnect' do
  pod 'Alamofire'                 # networking
  pod 'SwinjectAutoregistration'  # autoregister using init for dependency injection
  pod 'Sparkle'                   # auto-update the app
  pod 'LetsMove'                  # move app to Applications folder
  pod 'NSBundle+LoginItem',       # launch at login option
    # fix memory issues, expose setter in header
    # https://github.com/nklizhe/NSBundle-LoginItem/pull/7
    :git => 'https://github.com/paulz/NSBundle-LoginItem.git'
  pod 'USBDeviceSwift'            # monitor connected force plate

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

already_migrated = 9999
post_install do |installer|
  # Disable Xcode warning about available Swift conversion to the latest version of Swift
  # https://github.com/CocoaPods/CocoaPods/issues/8674#issuecomment-524097348
  installer.pods_project.root_object.attributes['LastSwiftMigration'] = already_migrated
  installer.pods_project.root_object.attributes['LastSwiftUpdateCheck'] = already_migrated
  installer.pods_project.root_object.attributes['LastUpgradeCheck'] = already_migrated

  # Fix Xcode warning update to recommended settings caused by overriding architecture settings
  # https://github.com/CocoaPods/CocoaPods/issues/8242#issuecomment-572046678
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete('ARCHS')
    end
  end
end
