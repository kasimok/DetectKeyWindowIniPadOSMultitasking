//
//  IsPrimarySceneKey.swift
//  MultiTasking
//
//  Created by 0x67 on 2025-08-31.
//
import SwiftUI

private struct IsPrimarySceneKey: EnvironmentKey {
    static let defaultValue: Bool = true
}
extension EnvironmentValues {
    var isPrimaryScene: Bool {
        get { self[IsPrimarySceneKey.self] }
        set { self[IsPrimarySceneKey.self] = newValue }
    }
}

struct PrimarySceneObserver: ViewModifier {
    @State private var isPrimary = false
    @State private var myWindow: UIWindow?
    
    func body(content: Content) -> some View {
        content
            .environment(\.isPrimaryScene, isPrimary)
            .background(
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
            .onChange(of: isPrimary) { _,newValue in
                debugPrint("window: \(ObjectIdentifier(myWindow!)), Primary: \(newValue)")
            }
    }
}

extension View {
    func injectPrimaryScene() -> some View {
        self.modifier(PrimarySceneObserver())
    }
}

// Helper to grab window directly when the view is added to hierarchy
private struct WindowCapture: UIViewRepresentable {
    var onWindow: (UIWindow) -> Void
    
    func makeUIView(context: Context) -> WindowCaptureView {
        let view = WindowCaptureView()
        view.onWindow = onWindow
        return view
    }
    
    func updateUIView(_ uiView: WindowCaptureView, context: Context) {}
}

private class WindowCaptureView: UIView {
    // This closure is called upon new created view is added to the window,
    // so that we can get the window
    var onWindow: ((UIWindow) -> Void)?

    override func didMoveToWindow() {
        super.didMoveToWindow()
        if let window = self.window {
            onWindow?(window)
        }
    }
}
