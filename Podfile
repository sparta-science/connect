platform :macos, '10.15'
use_frameworks!

def bdd
  pod 'Quick'
  pod 'Nimble'
end

pod 'SwiftLint'                   # enforce Swift style and conventions

def bundle_login
  pod 'NSBundle+LoginItem',       # launch at login option
    :inhibit_warnings => true,   # 'LSSharedFileListItemCopyResolvedURL' has been marked as being introduced in macOS 10.10
    # fix memory issues, expose setter in header
    # https://github.com/nklizhe/NSBundle-LoginItem/pull/7
    :git => 'https://github.com/paulz/NSBundle-LoginItem.git'
end

target 'SpartaConnect' do
  pod 'Alamofire'                 # networking
  pod 'SwinjectAutoregistration'  # autoregister using init for dependency injection
  pod 'Sparkle'                   # auto-update the app
  bundle_login
  pod 'LetsMove',                 # move app to Applications folder
    :inhibit_warnings => true   # 'trashItemAtURL:resultingItemURL:error:' has been marked as being introduced in macOS 10.8 here
  pod 'USBDeviceSwift', :inhibit_warnings => true # monitor connected force plate
  pod 'Swifter'                   # http server for offline msk health

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
  bundle_login
end

target 'ReleaseUITests' do
  bundle_login
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
