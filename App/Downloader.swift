import Alamofire
import Combine
import Testable

public typealias DownloadPublisher = AnyPublisher<URL, Error>
public typealias Progressing = (Progress) -> Void

private struct CurrentDownload {
    let url: URL
    let reporting: Progressing

    var publisher: DownloadPublisher {
        Future<URL?, AFError>(fullfill(promise:))
            .compactMap { $0 }
            .mapError { $0 }
            .eraseToAnyPublisher()
    }
    var request: DownloadRequest {
        AF.download(url)
            .validate()
            .downloadProgress(closure: reporting)
    }
    func fullfill(promise: @escaping Future<URL?, AFError>.Promise) {
        request.response { promise($0.result) }
    }
}

public class Downloader: Downloading {
    public func createDownload(url: URL,
                               reporting: @escaping Progressing)
        -> DownloadPublisher {
            CurrentDownload(url: url, reporting: reporting).publisher
    }
}
