import enum Alamofire.AFError
import Combine
import Nimble
import Quick
import class SpartaConnect.Downloader
import Testable

class DownloaderSpec: QuickSpec {
    override func spec() {
        describe(Downloader.self) {
            var subject: Downloader!
            var cancellables: Set<AnyCancellable>!
            beforeEach {
                subject = Injected.instance
                cancellables = .init()
            }
            context(Downloader.createDownload(url:reporting:)) {
                it("should download a text file reporting size") {
                    let url = URL(string: "https://raw.githubusercontent.com/sparta-science/connect/master/LICENSE")!
                    waitUntil(timeout: 30.0) { done in
                        subject.createDownload(url: url) { progress in
                            expect([1_074, -1]).to(contain(progress.totalUnitCount))
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
                it("should report http errors") {
                    let url = URL(string: "https://raw.githubusercontent.com/foo")!
                    waitUntil(timeout: 30.0) { done in
                        subject.createDownload(url: url) { progress in
                            expect(progress.totalUnitCount) == 20
                            expect(progress.completedUnitCount) == 20
                        }.sink(receiveCompletion: { completion in
                            if case let .failure(err) = completion {
                                expect(err).to(matchError(
                                    AFError.responseValidationFailed(
                                        reason: .unacceptableStatusCode(code: 400)
                                    )
                                ))
                                done()
                            }
                        }) {
                            fail($0.debugDescription)
                        }.store(in: &cancellables)
                    }
                }
            }
        }
    }
}
