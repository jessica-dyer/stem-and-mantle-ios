//
//  LogInView.swift
//  stem-and-mantle-ios
//
//  Created by Jessica Dyer on 8/27/23.
//

import SwiftUI

class LogInViewModel: ObservableObject {
    var userName: String = ""
    var password: String = ""
    var onLoginButtonTapped: (() -> Void)? = nil
}

struct LogInView: View {
    @EnvironmentObject var app: SAMApp
    @ObservedObject var viewModel = LogInViewModel()
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        Button {
            self.viewModel.onLoginButtonTapped?()
        } label: {
            Text("Stuff")
                .foregroundColor(.blue)
        }
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
