//
//  SceneDelegate.swift
//  shiftman
//
//  Created by Stefan OShea on 25/3/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(frame: windowScene.coordinateSpace.bounds)
            window.windowScene = windowScene
            window.rootViewController = HomeViewController()
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}

