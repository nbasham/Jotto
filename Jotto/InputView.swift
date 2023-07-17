import SwiftUI

struct InputView: View {
    let state: GameState

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
            .padding(.trailing)
            Spacer()
            ForEach((0..<state.wordLength), id: \.self) { index in
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(.white)
                    .aspectRatio(1, contentMode: .fit)
            }
        }
    }
}

#Preview {
    InputView(state: GameState())
}
