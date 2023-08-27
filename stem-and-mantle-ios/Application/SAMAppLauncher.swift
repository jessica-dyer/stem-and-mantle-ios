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
        
    }
    var body: some Scene {
        WindowGroup {
//            ContentView()
            NavigationView {
                NavigationLink {
                    LoginView().environmentObject(app)
                } label: {
                    Text("Login")
                        .foregroundColor(.blue)
                }
            }
        }
    }
}
