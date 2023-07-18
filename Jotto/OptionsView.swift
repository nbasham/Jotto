import SwiftUI

struct OptionsView: View {
    @AppStorage("allowRepeats") var allowRepeats = false
    @AppStorage("letterCount") var letterCount = "5"
    let counts = ["4", "5", "6"]

    var body: some View {
        Form {
            Section {
                Toggle("Allow repeats", isOn: $allowRepeats)
            } footer: {
                Text("Allow words where a letter is used more than once e.g. 'Peep'")
            }

            Section {
                Picker("Number of letters", selection: $letterCount) {
                    ForEach(counts, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.segmented)
            } footer: {
                Text("Choose the word length")
            }

        }
        .navigationTitle("Options")
    }
}

#Preview {
    OptionsView()
}
