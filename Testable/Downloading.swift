import Combine

public typealias DownloadPublisher = AnyPublisher<URL, Error>
public typealias Progressing = (Progress) -> Void

public protocol Downloading {
    func createDownload(url: URL,
                        reporting: @escaping Progressing) -> DownloadPublisher
}
