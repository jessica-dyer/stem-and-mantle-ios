//
//  LandingScreenWhenSignedOutView.swift
//  stem-and-mantle-ios
//
//  Created by Jessica Dyer on 8/27/23.
//

import SwiftUI

struct LandingScreenWhenSignedOutView: View {
    
    @EnvironmentObject var app: SAMApp
    
    var body: some View {
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

struct LandingScreenWhenSignedOutView_Previews: PreviewProvider {
    static var previews: some View {
        LandingScreenWhenSignedOutView()
    }
}
