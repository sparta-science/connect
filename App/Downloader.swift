import Alamofire
import Combine
import Testable

private struct CurrentDownload {
    let url: URL
    let reporting: Progressing

    var request: DownloadRequest {
        AF.download(url)
            .validate()
            .downloadProgress(closure: reporting)
    }
    var publisher: DownloadPublisher {
        request
            .publishUnserialized()
            .value()
            .mapError { $0 }
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }
}

public class Downloader: Downloading {
    public func createDownload(url: URL,
                               reporting: @escaping Progressing)
        -> DownloadPublisher {
            CurrentDownload(url: url, reporting: reporting).publisher
    }
}
