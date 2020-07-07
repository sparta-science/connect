import Combine
import Testable

final class MockDownloader: Downloading {
    var downloadedUrl: URL? {
        didSet {
            try! "some contents\n".write(to: downloadedUrl!, atomically: true, encoding: .ascii)
        }
    }
    var didProvideReporting: ((Progress) -> Void)?
    func createDownload(url: URL, reporting: @escaping (Progress) -> Void) -> AnyPublisher<URL, Error> {
        didProvideReporting = reporting
        return CurrentValueSubject<URL, Error>(downloadedUrl!).eraseToAnyPublisher()
    }
}

extension MockDownloader: CreateAndInject {
    typealias ActAs = Downloading
}
