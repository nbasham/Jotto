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

struct KeyView: View {
    let letter: String
    var state: KeyState

    private var used: some View {
        ZStack {
            Color.gray
            Text(letter)
                .foregroundColor(.white)
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private var unused: some View {
        ZStack {
            Color.gray.opacity(0.2)
            if letter == "DEL" {
                Image(systemName: "delete.left.fill")
                    .foregroundColor(.red)
            } else {
            Text(letter)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private var found: some View {
        ZStack {
            Color.orange
            Text(letter)
                .foregroundColor(.white)
                .bold()
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private var foundInPosition: some View {
        ZStack {
            Color.green
            Text(letter)
                .foregroundColor(.white)
                .bold()
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    var body: some View {
        switch state {
            case .unused:
                unused
            case .used:
                used
            case .found:
                found
            case .foundInPosition:
                foundInPosition
        }
    }
}

#Preview {
    VStack {
        KeyView(letter: "W", state: .unused)
            .frame(width: 44, height: 44)
        KeyView(letter: "W", state: .used)
            .frame(width: 44, height: 44)
        KeyView(letter: "W", state: .found)
            .frame(width: 44, height: 44)
        KeyView(letter: "W", state: .foundInPosition)
            .frame(width: 44, height: 44)
    }
}
