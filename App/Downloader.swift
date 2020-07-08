import Alamofire
import Combine
import Testable

public class Downloader: Downloading {
    public func createDownload(url: URL,
                               reporting: @escaping (Progress) -> Void)
        -> AnyPublisher<URL, Error> {
            futureDownload(url: url, reporting: reporting)
                .compactMap { $0 }
                .mapError { $0 }
                .eraseToAnyPublisher()
    }

    private func futureDownload(url: URL,
                                reporting: @escaping (Progress) -> Void)
        -> Future<URL?, AFError> {
            .init() { promise in
                AF.download(url)
                    .response { promise($0.result) }
                    .downloadProgress(closure: reporting)
            }
    }
}
