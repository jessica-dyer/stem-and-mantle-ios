//
//  EditSessionView.swift
//  stem-and-mantle-ios
//
//  Created by Jessica Dyer on 9/8/23.
//

import SwiftUI

struct EditSessionView: View {
    @EnvironmentObject var app: SAMApp
    @EnvironmentObject var user: User
    
    @State private var selectedDate = Date()
    @State private var selectedGym = Gym.allCases.first!
    @State private var notes = ""
    
    var body: some View {
        Form {
            VStack(alignment: .leading, spacing: 2) {
                Section() {
                    DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                }
            }
                Section() {
                    Picker("Gym", selection: $selectedGym) {
                        ForEach(Gym.allCases) { gym in
                            Text(gym.rawValue).tag(gym)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    Text("Notes:")
                    TextEditor(text: $notes)
                        .frame(height: 90) // Adjust the height as needed
                }
        }
            Section {
                Button(action: {
                    print(selectedDate)
                }) {
                    Text("Save")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding() // Add padding to the button
                        .background(Color.blue) // Set the button background color to blue
                        .foregroundColor(.white) // Set the text color to white
                        .cornerRadius(8)
                }
            }
        }}


struct EditSessionView_Previews: PreviewProvider {
    static var previews: some View {
        EditSessionView()
    }
}
