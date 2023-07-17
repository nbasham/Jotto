import SwiftUI

enum KeyState {
    case unused, used, found, foundInPosition

    static func initialize() -> [String: KeyState] {
        let alphabet: [String] = [
            "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"
        ]
        var keyStates: [String: KeyState] = [:]
        alphabet.forEach {
            keyStates[$0.uppercased()] = .unused
        }
        return keyStates
    }
}

enum TileState {
    case target, active(String), unused, used(String, KeyState)

    static func initialize(cols: Int, rows: Int) -> [[TileState]] {
        let row: [TileState] = Array(repeating: .unused, count: cols)
        var tileStates = Array(repeating: row, count: rows)
        tileStates[0][0] = .target
        return tileStates
    }
}

@Observable class GameState {
    let answer: String
    let maxNumGuesses = 6
    var keyStates: [String: KeyState] = [:]
    var tileStates: [[TileState]] = []
    var foundLetters: [String] = []
    var row = 0
    var rowIndex = 0
    var wordLength: Int { answer.count }
    var guessIsValid = false
    var guess = ""
    var gameOver = false
    var message: String?

    init() {
        answer = Dictionary.random.uppercased()
        print(answer)
        keyStates = KeyState.initialize()
        tileStates = TileState.initialize(cols: answer.count, rows: maxNumGuesses)
        foundLetters = Array(repeating: "", count: wordLength)
    }

    func handleGuess() {
        // if a letter is guessed twice but the answer only contains it once, don't mark one as found
        for i in 0..<wordLength {
            let letter = String(Array(guess)[i])
            let found = answer.contains(letter)
            let foundInPosition = String(Array(answer)[i]) == letter
            if foundInPosition {
                keyStates[letter] = .foundInPosition
                tileStates[row][i] = .used(letter, .foundInPosition)
                foundLetters[i] = letter
            } else if found {
                keyStates[letter] = .found
                tileStates[row][i] = .used(letter, .found)
            } else {
                keyStates[letter] = .used
                tileStates[row][i] = .used(letter, .used)
            }
        }
        row += 1
        if guess == answer {
            won()
        } else if row >= maxNumGuesses-1 {
            lost()
        } else {
            rowIndex = 0
            guess = ""
            tileStates[row][rowIndex] = .target
        }
    }

    func won() {
        gameOver = true
        message = "You won!"
    }

    func lost() {
        gameOver = true
        message = "You lost!"
    }

    func deleteTap() {
        _ = guess.popLast()
        rowIndex = max(0, rowIndex - 1)
        tileStates[row][rowIndex] = .target
    }

    func letterTap(_ letter: String) {
        guard letter != "DEL" else { deleteTap(); return }
        guess.append(letter)
        tileStates[row][rowIndex] = .active(letter)
        rowIndex = min(wordLength, rowIndex + 1)
        guessIsValid = isValid()
    }

    private func isValid() -> Bool {
        guard rowIndex == wordLength else { return false }
        guard Dictionary.contains(guess.lowercased()) else { return false }
        return true
    }
}
