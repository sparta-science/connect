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
        let result = Result<URL, Error>(catching: { downloadedUrl! })
        return result.publisher.eraseToAnyPublisher()
    }
}

extension MockDownloader: CreateAndInject {
    typealias ActAs = Downloading
}
