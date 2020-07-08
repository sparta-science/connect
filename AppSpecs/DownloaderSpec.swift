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
                it("should download a text file reporting size") {
                    var cancellables = Set<AnyCancellable>()

                    let url = URL(string: "https://raw.githubusercontent.com/sparta-science/connect/master/LICENSE")!
                    waitUntil(timeout: 30.0) { done in
                        subject.createDownload(url: url) { progress in
                            expect(progress.totalUnitCount) == -1
                            expect(progress.completedUnitCount) == 1_074
                        }.sink(receiveCompletion: { completion in
                            if case .finished = completion {
                                done()
                            }
                        }) { downloadedUrl in
                            let contents = try! String(contentsOf: downloadedUrl)
                            expect(contents).to(contain("Copyright (c) 2020 sparta-developers"))
                        }.store(in: &cancellables)
                    }
                }
            }
        }
    }
}
