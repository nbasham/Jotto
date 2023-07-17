import SwiftUI

enum KeyState {
    case unused, used, found, foundInPosition
}

enum TileState {
    case target, active(String), unused, used(String, KeyState)
}

@Observable class GameState {
    let answer: String
    let maxNumGuesses = 6
    var keyStates: [String: KeyState] = [:]
    var tileStates: [[TileState]] = []
    var row = 0
    var rowIndex = 0
    var wordLength: Int { answer.count }
    var guessIsValid = false
    var guess = ""
    var gameOver = false
    var message: String?

    init() {
        let alphabet: [String] = [
            "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"
        ]

        answer = Dictionary.random.uppercased()
        print(answer)
        alphabet.forEach {
            keyStates[$0.uppercased()] = .unused
        }
        let row: [TileState] = Array(repeating: .unused, count: answer.count)
        tileStates = Array(repeating: row, count: maxNumGuesses)
        tileStates[0][0] = .target
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
            } else if found {
                keyStates[letter] = .found
                tileStates[row][i] = .used(letter, .found)
            } else {
                keyStates[letter] = .used
                tileStates[row][i] = .used(letter, .used)
            }
        }
        rowIndex = 0
        row += 1
        if guess == answer {
            won()
        } else if row > maxNumGuesses {
            lost()
        } else {
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
