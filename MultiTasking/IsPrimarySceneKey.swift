//
//  IsPrimarySceneKey.swift
//  MultiTasking
//
//  Created by 0x67 on 2025-08-31.
//
import SwiftUI

private struct IsPrimarySceneKey: EnvironmentKey {
    static let defaultValue: Bool = false
}
extension EnvironmentValues {
    var isPrimaryScene: Bool {
        get { self[IsPrimarySceneKey.self] }
        set { self[IsPrimarySceneKey.self] = newValue }
    }
}

struct PrimarySceneObserver: ViewModifier {
    @State private var isPrimary = false
    @State private var mySceneID: String?
    
    func body(content: Content) -> some View {
        content
            .environment(\.isPrimaryScene, isPrimary)
            .background(
                WindowIDCapture(onSceneID: { id in
                    mySceneID = id
                })
            )
            .onAppear {
                NotificationCenter.default.addObserver(
                    forName: .primarySceneChanged,
                    object: nil,
                    queue: .main
                ) { note in
                    guard let announcedID = note.userInfo?["sceneID"] as? String else { return }
                    isPrimary = (announcedID == mySceneID)
                    debugPrint("isPrimary: \(isPrimary), announcedID: \(announcedID), mySceneID: \(mySceneID ?? "nil")")
                }
            }
    }
}

extension View {
    func injectPrimaryScene() -> some View {
        self.modifier(PrimarySceneObserver())
    }
}

// Helper to grab sceneID once view is attached
private struct WindowIDCapture: UIViewRepresentable {
    var onSceneID: (String) -> Void
    func makeUIView(context: Context) -> UIView {
        let v = UIView()
        DispatchQueue.main.async {
            if let id = v.window?.windowScene?.session.persistentIdentifier {
                onSceneID(id)
            }
        }
        return v
    }
    func updateUIView(_ uiView: UIView, context: Context) {}
}
