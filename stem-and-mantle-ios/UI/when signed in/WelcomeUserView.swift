//
//  WelcomeUserView.swift
//  stem-and-mantle-ios
//
//  Created by Jessica Dyer on 8/27/23.
//

import SwiftUI

struct WelcomeUserView: View {
    @EnvironmentObject var app: SAMApp
    @EnvironmentObject var user: User
    
    var body: some View {
        Text("Hello, \(user.accountAccessData.userName)!")
    }
}

struct WelcomeUserView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeUserView()
    }
}
