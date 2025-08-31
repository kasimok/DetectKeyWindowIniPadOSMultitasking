import SwiftUI

// MARK: - Public API
struct ContentView: View {
    @Environment(\.isPrimaryScene) private var isPrimary
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        VStack {
            Text("ScenePhase: \(scenePhase == .active ? "Active" : "Inactive")")
            Text("Primary: \(isPrimary ? "Yes" : "No")")
        }
        .padding()
        .injectPrimaryScene()
    }
}

