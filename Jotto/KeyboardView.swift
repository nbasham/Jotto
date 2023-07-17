import SwiftUI

struct KeyboardView: View {
    let states: [String: KeyState]
    let action: (String) -> ()

    private let topRow = ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"]
    private let middleRow = ["A", "S", "D", "F", "G", "H", "J", "K", "L"]
    private let bottomRow = ["Z", "X", "C", "V", "B", "N", "M", "DEL"]

    var body: some View {
        GeometryReader { proxy in
            VStack {
                row(keys: topRow, width: proxy.size.width)
                row(keys: middleRow, width: proxy.size.width)
                row(keys: bottomRow, width: proxy.size.width)
            }
        }
        .padding()
    }

    private func row(keys: [String], width: CGFloat) -> some View {
            ZStack {
                HStack() {
                    ForEach(keys, id: \.self) { letter in
                        KeyView(letter: letter, state: states[letter] ?? .unused)
                            .frame(width: keyWidth(numKeys: keys.count, len: width))
                            .onTapGesture {
                                action(letter)
                            }
                    }
                }
            }
            .frame(height: 44)
            .frame(width: width)
    }

    private func keyWidth(numKeys: Int, len: CGFloat) -> CGFloat {
        len / (CGFloat(numKeys))
    }
}

#Preview {
    KeyboardView(states: [:]) { letter in
        print(letter)
    }
    .padding()
}
