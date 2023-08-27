//
//  stem_and_mantle_iosApp.swift
//  stem-and-mantle-ios
//
//  Created by Jessica Dyer on 8/27/23.
//

import SwiftUI

@main
struct SAMAppLauncher: App {
    let app = SAMApp()
    
    init() {
        self.app.api.signIn(username: "", password: "") { (result) in
            print("bar")
            
        }
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
