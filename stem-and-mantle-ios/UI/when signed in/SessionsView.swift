//
//  SessionsView.swift
//  stem-and-mantle-ios
//
//  Created by Jessica Dyer on 9/8/23.
//

import SwiftUI

struct SessionsView: View {
    @EnvironmentObject var app: SAMApp
    @EnvironmentObject var user: User
    
    @State var sessions: [TrainingSession]? = nil
    @State var errorMessage: String? = nil
    
    var body: some View {
        NavigationView {
            self.contentView
                .navigationTitle("Training Sessions")
                .toolbar {
                    NavigationLink {
                        EditSessionView()
                            .environmentObject(app)
                            .environmentObject(user)
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                .onAppear() {
                    self.loadUserSessions()
                }
        }
    }
    
    var contentView: some View {
        ZStack {
            if self.errorMessage != nil {
                self.errorView
            } else if self.sessions == nil {
                self.loadingView
            } else if self.sessions?.isEmpty ?? false {
                self.noSessionsView
            } else {
                self.sessionListView
            }
        }
    }
    
    var loadingView: some View {
        VStack {
            ProgressView()
            Text("Loading...")
        }
    }
    
    var noSessionsView: some View {
        VStack {
            Text("Add your first training session!")
            
            NavigationLink {
                EditSessionView()
                    .environmentObject(app)
                    .environmentObject(user)
            } label: {
                Image(systemName: "plus")
            }
        }
    }
    
    var sessionListView: some View {
        ZStack {
            if let sessions = self.sessions {
                List {
                    ForEach(sessions) { session in
                        Text(session.date)
                    }
                }
            } else {
                Text("Should never happen.")
            }
        }
    }
    
    var errorView: some View {
        Text(self.errorMessage ?? "Unknown error")
            .foregroundColor(.red)
    }
    
    func loadUserSessions() {
        self.user.api.getTrainingSessions() { (result) in
            switch result {
            case .success(let trainingSessions):
                self.errorMessage = nil 
                self.sessions = trainingSessions.training_sessions
            case .failure(let error):
                self.errorMessage =
                getWhyString(forError: error)
            }
            
        }
    }
}

struct SessionsView_Previews: PreviewProvider {
    static var previews: some View {
        SessionsView()
    }
}
