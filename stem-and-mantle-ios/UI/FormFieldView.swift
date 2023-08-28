//
//  FormFieldView.swift
//  stem-and-mantle-ios
//
//  Created by Jessica Dyer on 8/27/23.
//

import SwiftUI

struct FormFieldView: View {
    
    let placeholder: String
    @Binding var text: String
    let isSecureField: Bool
    
    @State private var isSecureTextEntry: Bool = true
    
    var body: some View {
            VStack(alignment: .leading) {
                ZStack {
                    if isSecureField {
                        HStack {
                            if isSecureTextEntry {
                                SecureField(self.placeholder, text: $text)
                                    .textContentType(.password)
                                    .keyboardType(.default)
                                    .autocapitalization(.none)
                                    .padding()
                            } else {
                                TextField(self.placeholder, text: $text)
                                    .textContentType(.password)
                                    .keyboardType(.default)
                                    .autocapitalization(.none)
                                    .padding()
                            }
                            revealButton
                        }
                    } else {
                        TextField(self.placeholder, text: $text)
                            .textContentType(.none)
                            .keyboardType(.default)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .padding()
                    }
                }
                .background(self.background)
                .frame(height: 50)
            }
        }
    
    private var background: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color.gray.opacity(0.2))
            .cornerRadius(8)
    }
    
    private var revealButton: some View {
            Button(action: {
                isSecureTextEntry.toggle()
            }) {
                Image(systemName: isSecureTextEntry ? "eye.slash" : "eye")
                    .foregroundColor(.gray)
            }
            .padding(.trailing, 10)
    }
}

struct FormFieldView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            FormFieldView(placeholder: "Username", text: .constant(""), isSecureField: false)
            FormFieldView(placeholder: "Password", text: .constant(""), isSecureField: true)
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
