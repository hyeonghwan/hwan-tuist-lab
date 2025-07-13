import UIKit


protocol CellIdentifialble {
    static var id: String { get }
}

extension CellIdentifialble {
    static var id: String {
        String(describing: Self.self)
    }
}
