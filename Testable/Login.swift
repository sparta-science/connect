import Foundation

@objcMembers
public class Login: NSObject {
    @Inject var defaults: UserDefaults
    public lazy var environment: String = defaults.bool(forKey: "offline installation") ? "offline" : "production"
    public var username: String?
    public var password: String?
    public lazy var environment: String =
        defaults.bool(forKey: "offline installation") ? "Sparta Offline System" : "home.spartascience.com"
}
