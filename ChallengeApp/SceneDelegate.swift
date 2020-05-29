//
//  SceneDelegate.swift
//  ChallengeApp
//
//  Created by Michael Sevy on 4/4/20.
//  Copyright © 2020 Michael Sevy. All rights reserved.
//

import UIKit
import SwiftUI
import Firebase
import FirebaseUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        // Here we can choose to initialize the ContentView() or our auth if there if no user
        // Firebase Auth
        FirebaseApp.configure()
        
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                print("user logged in: \(user!.email!)")
                // Create the SwiftUI view that provides the window contents.
                let contentView = ContentView(user: user)
                
                // Use a UIHostingController as window root view controller.
                if let windowScene = scene as? UIWindowScene {
                    let window = UIWindow(windowScene: windowScene)
                    window.rootViewController = UIHostingController(rootView: contentView)
                    self.window = window
                    window.makeKeyAndVisible()
                }
            } else {
                print("user not logged in")
                // @TODO add an option for no user joining as a guest
                if let authUI = FUIAuth.defaultAuthUI() {
                         
                    authUI.delegate = self as? FUIAuthDelegate
                    let providers: [FUIAuthProvider] = [FUIEmailAuth()]
                    authUI.providers = providers
            
                     // VC
                    let authVC = authUI.authViewController()
                
                    if let windowScene = scene as? UIWindowScene {
                        let window = UIWindow(windowScene: windowScene)
                        window.rootViewController = authVC //UIHostingController(rootView: contentView)
                        self.window = window
                        window.makeKeyAndVisible()
                    }
                }
            }
        }
        
        
            
           
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

    // MARK: - Firebase Handlers
      func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
          let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String?
          
          if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
            print("handler callback handle opened.")
            return true
        }
        // other URL handling goes here.
        return false
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        // handle user and error as necessary
        if let user = user,
            let email = user.email {
            
            print("user signed in successfully!: \(email)")
        }
    }
    
}

