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
    @State var userId: Int? = nil
    @State var errorMessage: String? = nil
    
    var body: some View {
        VStack{
            Text("Hello, \(user.accountAccessData.userName)!")
            if let userId = self.userId {
                Text("You're UserId is \(userId)")
            }
            if let errorMessage = self.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
        }
        .onAppear() {
            self.loadUserInfo()
        }
    }
    
    func loadUserInfo() {
        self.user.api.getUserData() { (result) in
            switch result {
            case .success(let userInfo):
                self.userId = userInfo.id
            case .failure(let error):
                self.errorMessage = getWhyString(forError: error)
            }
        }
    }
}

struct WelcomeUserView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeUserView()
    }
}
