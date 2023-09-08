//
//  TabBarView.swift
//  stem-and-mantle-ios
//
//  Created by Jessica Dyer on 9/8/23.
//

import SwiftUI

struct TabBarView: View {
    @EnvironmentObject var app: SAMApp
    @EnvironmentObject var user: User
    
    var body: some View {
        TabView {
            SessionsView()
                .environmentObject(app)
                .environmentObject(user)
                .tabItem {
                    Label("Training Sessions", systemImage: "list.dash")
                }

            StatsView()
                .tabItem {
                    Label("Stats", systemImage: "square.and.pencil")
                }
        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
