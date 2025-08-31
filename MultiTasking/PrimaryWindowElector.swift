//
//  PrimarySceneElector.swift
//  MultiTasking
//
//  Created by 0x67 on 2025-08-31.
//
import Foundation
import UIKit

final class PrimaryWindowElector {
    static let shared = PrimaryWindowElector()
    private init() {}
    
    private(set) var primaryWindow: UIWindow? {
        didSet {
            if let window = primaryWindow {
                NotificationCenter.default.post(
                    name: .primaryWindowChanged,
                    object: nil,
                    userInfo: ["window": window]
                )
            }
        }
    }
    
    func sceneDidReceiveEvent(_ window: UIWindow) {
        primaryWindow = window
    }
}

extension Notification.Name {
    static let primaryWindowChanged = Notification.Name("PrimaryWindowChangedNotification")
}
