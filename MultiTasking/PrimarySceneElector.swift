//
//  PrimarySceneElector.swift
//  MultiTasking
//
//  Created by 0x67 on 2025-08-31.
//
import Foundation
import UIKit

final class PrimarySceneElector {
    static let shared = PrimarySceneElector()
    private init() {}
    
    private(set) var primarySceneID: String? {
        didSet {
            if let id = primarySceneID {
                NotificationCenter.default.post(
                    name: .primarySceneChanged,
                    object: nil,
                    userInfo: ["sceneID": id]
                )
            }
        }
    }
    
    func sceneDidReceiveEvent(_ scene: UIScene) {
        primarySceneID = scene.session.persistentIdentifier
    }
}

extension Notification.Name {
    static let primarySceneChanged = Notification.Name("PrimarySceneChangedNotification")
}
