import Combine
import Testable

final class WaitingToBeCancelled: Downloading {
    var startDownloading: (() -> Void)?
    var wasCancelled = false
    func createDownload(url: URL, reporting: @escaping Progressing) -> DownloadPublisher {
        Empty<URL, Error>(completeImmediately: false)
            .handleEvents(receiveSubscription: { _ in self.startDownloading!() },
                          receiveCancel: { self.wasCancelled = true })
            .eraseToAnyPublisher()
    }
}

extension WaitingToBeCancelled: CreateAndInject {
    typealias ActAs = Downloading
}
