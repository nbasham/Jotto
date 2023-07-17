import SwiftUI

struct ContentView: View {
    @State var gameState = GameState()

    var body: some View {
        NavigationStack {
            ZStack {
                Color.yellow.opacity(0.2)
                    .ignoresSafeArea(.all)
                VStack() {
                    ForEach(0..<gameState.maxNumGuesses, id: \.self) { row in
                        GuessRowView(states: gameState.tileStates[row])
                    }
                    InputView(state: gameState)
                        .padding()
                    KeyboardView(states: gameState.keyStates, action: gameState.letterTap)
                        .padding(.horizontal)
                }
                .padding()
            }
            .navigationTitle("Jotto!")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $gameState.showAlert) { Text(gameState.message ?? "WFT")
            }
        }
    }
}

#Preview {
    ContentView()
        .padding()
//        .ignoresSafeArea(.all)
}
