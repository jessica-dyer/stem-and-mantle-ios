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
        self.app.api.signIn(username: "jessica@gmail.com", password: "password") { (result) in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error)
            }
        }
    }
    var body: some Scene {
        WindowGroup {
//            ContentView()
            NavigationView {
                NavigationLink {
                    LogInView().environmentObject(app)
                } label: {
                    Text("Login")
                        .foregroundColor(.blue)
                }
            }
        }
    }
}
