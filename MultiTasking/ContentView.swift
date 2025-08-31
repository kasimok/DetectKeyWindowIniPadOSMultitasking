import SwiftUI

// MARK: - Public API
struct ContentView: View {
    @Environment(\.scenePhase) private var scenePhase

    @State private var isPrimary: Bool = true
    @State private var myWindow: UIWindow? = nil

    var body: some View {
        VStack {
            Text("ScenePhase: \(scenePhase == .active ? "Active" : "Inactive")")
            Text("Primary: \(isPrimary ? "Yes" : "No")")
        }.background(
            WindowCapture(onWindow: { window in
                debugPrint("Window(Scene) created: \(window)")
                myWindow = window
            })
        )
        .onAppear {
            NotificationCenter.default.addObserver(
                forName: .primaryWindowChanged,
                object: nil,
                queue: .main
            ) { note in
                guard let announcedWindow = note.userInfo?["window"] as? UIWindow else { return }
                isPrimary = (announcedWindow == myWindow)
            }
        }
        .padding()
    }
}

