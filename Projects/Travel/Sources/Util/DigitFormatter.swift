import Foundation

struct DigitFormatter {
    let map: [String: String]
    
    func format(_ number: Int) -> [String] {
        String(number).map { map[String($0)] ?? String($0) }
    }
}
