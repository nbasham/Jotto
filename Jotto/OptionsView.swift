import SwiftUI

struct OptionsView: View {
    @State private var allowRepeats = false
    @State private var selectedCount = "5"
    let counts = ["4", "5", "6"]

    init() {
        self.selectedCount = UserDefaults.standard.value(forKey: "letter_count") as? String ?? "5"
        self.allowRepeats = UserDefaults.standard.value(forKey: "allow_repeats") as? Bool ?? false
    }

    var body: some View {
        Form {
            Section {
                Toggle("Allow repeats", isOn: $allowRepeats)
                    .onChange(of: allowRepeats) { oldState, newState in
                        UserDefaults.standard.setValue(newState, forKey: "allow_repeats")
                    }
            } footer: {
                Text("Allow words where a letter is used more than once e.g. 'Peep'")
            }

            Section {
                Picker("Number of letters", selection: $selectedCount) {
                    ForEach(counts, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.segmented)
                .onChange(of: selectedCount) { oldState, newState in
                    UserDefaults.standard.setValue(newState, forKey: "letter_count")
                }
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
