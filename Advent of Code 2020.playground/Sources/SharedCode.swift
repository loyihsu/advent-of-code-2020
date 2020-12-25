import Foundation

public struct Timer {
    private var startTime = Date()
    public init() { }
    public var runtime: TimeInterval {
        Date().timeIntervalSince(startTime)
    }
}

public func matches(for regex: String, in text: String) -> [String] {
    if let regex = try? NSRegularExpression(pattern: regex) {
        let results = regex.matches(in: text, range: NSRange(text.startIndex..., in: text))
        return results.map { String(text[Range($0.range, in: text)!]) }
    }
    return []
}

public func root2(_ double: Int) -> Int {
    return Int(sqrt(Double(double)))
}
