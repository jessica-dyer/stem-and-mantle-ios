//
//  SAMApp.swift
//  stem-and-mantle-ios
//
//  Created by Jessica Dyer on 8/27/23.
//

import Foundation

class SAMApp: ObservableObject {
    let api: SAMUnauthenticatedAPI
    var user: User?
    
    init() {
        self.api = SAMUnauthenticatedAPI(host: .local)
        self.user = nil
    }
    
    func signInFor(_ user: User) {
        self.user = user
    }
    
    func signOut() {
        self.user = nil
    }
}
