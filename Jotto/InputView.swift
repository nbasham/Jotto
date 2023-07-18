import SwiftUI

struct InputView: View {
    let state: GameState

    private func color(index: Int) -> Color {
        let value = state.foundLetters[index]
        if value.isEmpty {
            return .white
        }
        return .green
    }

    var body: some View {
        HStack {
            Button {
                state.handleGuess()
            } label: {
                Text("Guess")
                    .fixedSize()
            }
            .buttonStyle(.bordered)
            .disabled(!state.guessIsValid)
            Spacer(minLength: 24)
            ForEach((0..<state.wordLength), id: \.self) { index in
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(color(index: index))
                    .aspectRatio(1, contentMode: .fit)
                    .frame(minHeight: 64)
                    .overlay (
                        Text(state.foundLetters[index])
                            .foregroundColor(.white)
                    )
            }
        }
    }
}

#Preview {
    InputView(state: GameState())
}
