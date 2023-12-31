import SwiftUI

struct ContentView: View {
    @State var gameState = GameState()
    @State var isShowingOptions = false

    var rowsToShow: Int {
        if gameState.gameOver {
            return gameState.row
        }
        return gameState.maxNumGuesses
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.yellow.opacity(0.2)
                    .ignoresSafeArea(.all)
                VStack() {
                    ForEach(0..<rowsToShow, id: \.self) { row in
                        GuessTileRowView(wordLen: gameState.wordLength, states: gameState.tileStates[row])
                    }
                    if gameState.gameOver {
                        Button("Options") {
                            isShowingOptions = true
                        }
                        .buttonStyle(.bordered)
                       Button {
                            gameState = GameState()
                        } label: {
                            Text("Play again")
                        }
                        .buttonStyle(.borderedProminent)
                    } else {
                        InputView(state: gameState)
                            .padding()
                        KeyboardView(states: gameState.keyStates, action: gameState.letterTap)
                            .padding(.horizontal)
                            .frame(height: UIDevice.isPhone ? 156 : 256)
                    }
                }
                .padding()
            }
            .navigationTitle(gameState.message ?? "Jotto!")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $isShowingOptions) {
                NavigationStack {
                    OptionsView()
                }
                .presentationDetents([.medium, .fraction(0.32)])
            }
        }
    }
}

#Preview {
    ContentView()
        .padding()
//        .ignoresSafeArea(.all)
}
