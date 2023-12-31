import SwiftUI

@Observable class GameState {
    private let wordList: WordList
    let answer: String
    let maxNumGuesses = 6
    var keyStates: [String: KeyState] = [:]
    var tileStates: [[GuessTileState]] = []
    var foundLetters: [String] = []
    var row = 0
    var rowIndex = 0
    var wordLength: Int { answer.count }
    var guessIsValid = false
    var guess = ""
    var gameOver = false
    var message: String?

    init() {
        let countStr = UserDefaults.standard.value(forKey: "letterCount") as? String ?? "5"
        let count = Int(countStr) ?? 5
        wordList = WordList.load(count: count)
        let allowRepeats = UserDefaults.standard.value(forKey: "allowRepeats") as? Bool ?? false
        answer = wordList.random(allowRepeats: allowRepeats).uppercased()
        print("----- New game -----")
        print("Answer: \(answer)")
        keyStates = KeyState.initialize()
        tileStates = GuessTileState.initialize(cols: answer.count, rows: maxNumGuesses)
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
                tileStates[row][i] = .pastFoundInPlace(letter)
                foundLetters[i] = letter
            } else if found {
                //  don't change state if it's more specific
                if keyStates[letter] != .foundInPosition {
                    keyStates[letter] = .found
                }
                tileStates[row][i] = .pastFound(letter)
            } else {
                keyStates[letter] = .used
                tileStates[row][i] = .past(letter)
            }
        }
        row += 1
        if guess == answer {
            won()
        } else if row >= maxNumGuesses {
            lost()
        } else {
            rowIndex = 0
            guess = ""
            tileStates[row][rowIndex] = .currentTarget
            for i in 1..<wordLength {
                tileStates[row][i] = .currentNoGuess
            }
        }
    }

    func won() {
        gameOver = true
        message = "You won!"
    }

    func lost() {
        gameOver = true
        message = "The answer is \(answer.uppercased())"
    }

    func deleteTap() {
        _ = guess.popLast()
        rowIndex = max(0, rowIndex - 1)
        tileStates[row][rowIndex] = .currentTarget
    }

    func letterTap(_ letter: String) {
        guard letter != "DEL" else { deleteTap(); return }
        guard rowIndex != wordLength else { return }
        guess.append(letter)
        tileStates[row][rowIndex] = .current(letter)
        rowIndex = min(wordLength, rowIndex + 1)
        guessIsValid = isValid()
    }

    private func isValid() -> Bool {
        guard rowIndex == wordLength else { return false }
        guard wordList.contains(guess.lowercased()) else { return false }
        return true
    }
}
