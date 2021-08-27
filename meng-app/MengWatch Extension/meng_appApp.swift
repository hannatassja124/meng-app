//
//  meng_appApp.swift
//  MengWatch Extension
//
//  Created by Hannatassja Hardjadinata on 27/08/21.
//

import SwiftUI

@main
struct meng_appApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
