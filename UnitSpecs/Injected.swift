import Testable

class Injected<Service> {
    @Inject private var service: Service

    static var instance: Service {
        Injected().service
    }
}
