import Combine
import Testable

final class MockDownloader: Downloading {
    let fileManager = FileManager.default
    lazy var tempUrl = fileManager.temporaryDirectory.appendingPathComponent("prentend-downloaded.tar.gz")
    var downloadedContentsUrl: URL? {
        didSet {
            try? fileManager.removeItem(at: tempUrl)
            try! fileManager.copyItem(at: downloadedContentsUrl!, to: tempUrl)
        }
    }
    var didProvideReporting: ((Progress) -> Void)?
    func createDownload(url: URL, reporting: @escaping (Progress) -> Void) -> AnyPublisher<URL, Error> {
        didProvideReporting = reporting
        let result = Result<URL, Error>(catching: { tempUrl })
        return result.publisher.eraseToAnyPublisher()
    }
}

extension MockDownloader: CreateAndInject {
    typealias ActAs = Downloading
}
