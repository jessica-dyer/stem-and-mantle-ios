//
//  LogInView.swift
//  stem-and-mantle-ios
//
//  Created by Jessica Dyer on 8/27/23.
//

import SwiftUI

class LoginViewModel: ObservableObject {
    var userName: String = ""
    var password: String = ""
//    var onLoginButtonTapped: (() -> Void)? = nil
    func onLoginButtonTapped(app: SAMApp) {
        app.api.signIn(username: "jessica@gmail.com", password: "password") { (result) in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error)
            }
        }
    }
}

struct LoginView: View {
    @EnvironmentObject var app: SAMApp
    @ObservedObject var viewModel = LoginViewModel()
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        Button {
            self.viewModel.onLoginButtonTapped(app: self.app)
        } label: {
            Text("Login")
                .foregroundColor(.blue)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
