public struct ProductOfVendor: Equatable {
    public var vendor, product: Int
    public init(vendor: Int, product: Int) {
        self.vendor = vendor
        self.product = product
    }
}
