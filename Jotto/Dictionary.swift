import Foundation

class Dictionary {
    private var words: Set<String> = []

    private init(words: Set<String>) {
        self.words = words
    }

    static func load(count: Int) -> Dictionary {
        let timer = CodeTimer()
        guard let url = Bundle.main.url(forResource: "\(count)_letter_words", withExtension: "txt") else {
            fatalError("Cannot find dictionary.txt")
        }

        guard let contents = try? String(contentsOf: url) else {
            fatalError("Couldn't load dictionary.txt")
        }

        let words = Set(contents.components(separatedBy: .newlines))
        timer.log("Time to load words:")
        return Dictionary(words: words)
    }

    func contains(_ word: String) -> Bool {
        words.contains(word)
    }

    func random(allowRepeats: Bool = false) -> String {
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
