import Alamofire
import Combine
import Testable

class Downloader: Downloading {
    func createDownload(url: URL, to destination: URL, reporting: @escaping (Progress) -> Void) -> AnyPublisher<URL, Error> {
        futureDownload(url: url, reporting: reporting)
        .compactMap { $0 }
        .mapError { $0 }
        .eraseToAnyPublisher()
    }

    func downloadDestination() -> (destinationURL: URL, options: DownloadRequest.Options) {
        (
            destinationURL: self.downloadUrl(),
            options: [.createIntermediateDirectories, .removePreviousFile]
        )
    }

    func destination(_ temporaryURL: URL, _ response: HTTPURLResponse)
        -> (destinationURL: URL, options: DownloadRequest.Options) {
            print("download status: \(response.statusCode)")
            print("download temp file: \(temporaryURL.path)")
            return downloadDestination()
    }

    func futureDownload(url: URL, reporting: @escaping (Progress) -> Void) -> Future<URL?, AFError> {
        Future<URL?, AFError> { promise in
            AF.download(url, to: self.destination(_:_:))
                .response { promise($0.result) }
                .downloadProgress(closure: reporting)
        }
    }
}
