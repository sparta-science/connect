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
    var didProvideReporting: Progressing?
    func createDownload(url: URL, reporting: @escaping Progressing) -> AnyPublisher<URL, Error> {
        didProvideReporting = reporting
        reporting(Progress(totalUnitCount: 100))
        let result = Result<URL, Error>(catching: { tempUrl })
        return result.publisher.eraseToAnyPublisher()
    }
}

extension MockDownloader: CreateAndInject {
    typealias ActAs = Downloading
}
