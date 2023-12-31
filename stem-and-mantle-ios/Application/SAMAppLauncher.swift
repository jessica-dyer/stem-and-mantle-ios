//
//  stem_and_mantle_iosApp.swift
//  stem-and-mantle-ios
//
//  Created by Jessica Dyer on 8/27/23.
//

import SwiftUI

@main
struct SAMAppLauncher: App {
    @ObservedObject var app: SAMApp
    
    init() {
        self.app = SAMApp()
        self.app.loadSavedUserIfExists()
    }
    var body: some Scene {
        WindowGroup {
            if let user = app.user {
                TabBarView()
                    .environmentObject(self.app)
                    .environmentObject(user)
            } else {
                LandingScreenWhenSignedOutView().environmentObject(self.app)
            }
        }
    }
}
