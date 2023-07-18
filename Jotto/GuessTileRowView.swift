import SwiftUI

struct GuessTileRowView: View {
    let wordLen: Int
    let states: [GuessTileState]

    var body: some View {
        HStack {
            ForEach((0..<wordLen), id: \.self) { index in
                GuessTileView(state: states[index])
            }
        }
    }
}

struct GuessTileView: View {
    let state: GuessTileState

    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .foregroundColor(state.color)
            .aspectRatio(1, contentMode: .fit)
            .frame(maxHeight: 64)
            .overlay (
                Text(state.letter)
                    .foregroundColor(state.textColor)
            )
    }
}

enum GuessTileState {
    case past(String), pastFound(String), pastFoundInPlace(String), currentTarget, current(String), currentNoGuess, future

    static func initialize(cols: Int, rows: Int) -> [[GuessTileState]] {
        let row: [GuessTileState] = Array(repeating: .future, count: cols)
        var tileStates = Array(repeating: row, count: rows)
        tileStates[0][0] = .currentTarget
        return tileStates
    }

    var letter: String {
        switch self {
            case .past(let guess):
                return guess
            case .pastFound(let guess):
                return guess
            case .pastFoundInPlace(let guess):
                return guess
            case .currentTarget:
                return ""
            case .current(let guess):
                return guess
            case .currentNoGuess:
                return ""
            case .future:
                return ""
        }
    }

        var textColor: Color {
            switch self {
                case .past(_):
                        .white
                case .pastFound(_):
                        .white
                case .pastFoundInPlace(_):
                        .white
                case .currentTarget:
                        .primary
                case .current(_):
                        .primary
                case .currentNoGuess:
                        .clear
                case .future:
                        .clear
            }
        }

        var color: Color {
            switch self {
                case .past(_):
                        .gray
                case .pastFound(_):
                        .orange
                case .pastFoundInPlace(_):
                        .green
                case .currentTarget:
                        .white
                case .current(_):
                        .white
                case .currentNoGuess:
                        .gray.opacity(0.2)
                case .future:
                        .gray.opacity(0.2)
            }
        }
    }

#Preview {
    ZStack {
        Color.orange.opacity(0.2)
//            .frame(height: 256)
        VStack {
            //  Past. B doesn't make sense
            GuessTileRowView(wordLen: 5, states: [.past("A"), .past("B"), .pastFound("C"), .pastFoundInPlace("D"), .pastFoundInPlace("E")])
            //  Current
            GuessTileRowView(wordLen: 5, states: [.current("J"), .currentTarget, .currentNoGuess, .currentNoGuess, .currentNoGuess])
            //  Future
            GuessTileRowView(wordLen: 5, states: [.future, .future, .future, .future, .future])
        }
    }
}
