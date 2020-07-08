import Alamofire
import Combine
import Testable

public class Downloader: Downloading {
    @Inject var session: Session

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
            .init() { [weak self] promise in
                self?.session.download(url)
                    .response { promise($0.result) }
                    .validate()
                    .downloadProgress(closure: reporting)
                    .response { promise($0.result) }
            }
    }
}
