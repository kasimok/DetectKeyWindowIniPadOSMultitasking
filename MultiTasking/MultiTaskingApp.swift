//
//  MultiTaskingApp.swift
//  MultiTasking
//
//  Created by 0x67 on 2025-08-30.
//

import SwiftUI
import UIKit

// Custom App Delegate that sets up UIEvent interception
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Set up method swizzling to intercept sendEvent
        setupEventInterception()
        return true
    }
    
    private func setupEventInterception() {
        let originalSelector = #selector(UIApplication.sendEvent(_:))
        let swizzledSelector = #selector(UIApplication.swizzled_sendEvent(_:))
        
        guard let originalMethod = class_getInstanceMethod(UIApplication.self, originalSelector),
              let swizzledMethod = class_getInstanceMethod(UIApplication.self, swizzledSelector) else {
            return
        }
        
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
}

// Extension to add the swizzled method
extension UIApplication {
    @objc func swizzled_sendEvent(_ event: UIEvent) {
        // Call the original sendEvent method
        self.swizzled_sendEvent(event)
        
        // Our custom event handling
        if let window = event.allTouches?.first?.window{
            PrimaryWindowElector.shared.sceneDidReceiveEvent(window)
        }
    }
}

@main
struct MultiTaskingApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
