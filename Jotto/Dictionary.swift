import Foundation

enum Dictionary {
    private static func load() -> Set<String> {
        let timer = CodeTimer()
        let count = UserDefaults.standard.value(forKey: "letterCount") ?? "5"
        guard let url = Bundle.main.url(forResource: "\(count)_letter_words", withExtension: "txt") else {
            fatalError("Cannot find dictionary.txt")
        }

        guard let contents = try? String(contentsOf: url) else {
            fatalError("Couldn't load dictionary.txt")
        }

        let result = Set(contents.components(separatedBy: .newlines))
        timer.log("Time elapsed:") // Time elapsed: 0.380 second(s).
        return result
    }

    static func contains(_ word: String) -> Bool {
        Dictionary.load().contains(word)
    }

    static var random: String {
        let allowRepeats = UserDefaults.standard.value(forKey: "allowRepeats") as? Bool ?? false
        let words = Dictionary.load()
        var candidate = words.randomElement()!
        if allowRepeats { return candidate }
        let count = candidate.count
        var nonDupCount = Set(Array(candidate)).count
        while (nonDupCount < count) {
            print("Disguarding \(candidate)")
            candidate = words.randomElement()!
            nonDupCount = Set(Array(candidate)).count
        }
        print("Choosing \(candidate)")
        return candidate
    }
}

final class CodeTimer {
    var startTime: CFAbsoluteTime = 0

    public init() {
        start()
    }

    public func start() {
        startTime = CFAbsoluteTimeGetCurrent()
    }

    public func log(_ message: String) {
        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
        let s = String(format: "%.5f", timeElapsed)
        print("\(message) \(s) second(s).")
    }

}
