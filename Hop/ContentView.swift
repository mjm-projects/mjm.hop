import SwiftUI

struct ContentView: View {
    static let initialMessage = "Pronto per configurare la prima macchina"

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "terminal")
                .font(.largeTitle)
                .accessibilityHidden(true)
            Text("Hop")
                .font(.title)
            Text(Self.initialMessage)
                .foregroundStyle(.secondary)
        }
        .frame(minWidth: 480, minHeight: 320)
        .accessibilityElement(children: .combine)
    }
}
