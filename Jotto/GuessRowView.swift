import SwiftUI

struct GuessRowView: View {
    let wordLen: Int
    let states: [TileState]

    func color(index: Int) -> Color {
        let state = states[index]
        switch state {
            case .target:
                return .white
            case .active:
                return .white
            case .unused:
                return .gray.opacity(0.2)
            case .used(_, _):
                return .white
        }
    }

    @ViewBuilder
    func key(index: Int) -> some View {
        let state = states[index]
        switch state {
            case .target:
                EmptyView()
            case .active(let letter):
                Text(letter).foregroundColor(.black)
            case .unused:
                KeyView(letter: "", state: .unused)
            case let .used(letter, keystate):
                KeyView(letter: letter, state: keystate)
        }
    }

    var body: some View {
        HStack {
            ForEach((0..<wordLen), id: \.self) { index in
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(color(index: index))
                    .aspectRatio(1, contentMode: .fit)
                    .frame(maxHeight: 64)
                    .overlay (
                        key(index: index)
                    )
            }
        }
    }
}

#Preview {
    GuessRowView(wordLen: 5, states: [.unused, .unused, .unused, .unused, .unused])
}
