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
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                TextField(self.placeholder, text: $text)
                    .padding()
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
}

struct FormFieldView_Previews: PreviewProvider {
    static var previews: some View {
        FormFieldView(placeholder: "Placeholder text", text: .constant(""))
    }
}
