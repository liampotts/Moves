//
//  MovesApp.swift
//  Moves
//
//  Created by Liam Potts on 4/21/23.
//

import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct MovesApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var moveVM = MoveViewModel()
    
    var body: some Scene {
        WindowGroup {
            LoginView()
                .environmentObject(moveVM)
        }
    }
}
