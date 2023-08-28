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
        app.api.signIn(username: self.userName, password: self.password) { (result) in
            switch result {
            case .success(let userAccessData):
                print(userAccessData)
                let user = User(userData: userAccessData)
                app.signInFor(user)
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
        VStack {
            FormFieldView(placeholder: "Email", text: self.$viewModel.userName, isSecureField: false)
            FormFieldView(placeholder: "Password", text: self.$viewModel.password, isSecureField: true)
            Button {
                self.viewModel.onLoginButtonTapped(app: self.app)
            } label: {
                Text("Login")
                    .foregroundColor(.blue)
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
