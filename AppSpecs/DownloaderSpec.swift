import Combine
import Nimble
import Quick
import SpartaConnect
import Testable

class DownloaderSpec: QuickSpec {
    override func spec() {
        describe(Downloader.self) {
            var subject: Downloader!
            beforeEach {
                Configure(Inject<Downloader>()) {
                    subject = $0.wrappedValue
                }
            }
            context(Downloader.createDownload(url:reporting:)) {
                it("should download a file") {
                    var cancellables = Set<AnyCancellable>()
                    let url = testBundleUrl("expected_vernal_falls.tar.gz")
                    subject.createDownload(url: url) { progress in
                        print(progress)
                    }.sink(receiveCompletion: { completion in
                        print(completion)
                    }) { downloadedUrl in
                        print(downloadedUrl)
                    }.store(in: &cancellables)
                    RunLoop.run(for: 500)
                }
            }
        }
    }
}
