//
//  IsPrimarySceneKey.swift
//  MultiTasking
//
//  Created by 0x67 on 2025-08-31.
//
import SwiftUI

// Helper to grab window directly when the view is added to hierarchy
struct WindowCapture: UIViewRepresentable {
    var onWindow: (UIWindow) -> Void
    
    func makeUIView(context: Context) -> WindowCaptureView {
        let view = WindowCaptureView()
        view.onWindow = onWindow
        return view
    }
    
    func updateUIView(_ uiView: WindowCaptureView, context: Context) {}
}

class WindowCaptureView: UIView {
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
