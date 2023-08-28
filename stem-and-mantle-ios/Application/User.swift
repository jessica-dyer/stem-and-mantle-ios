//
//  User.swift
//  stem-and-mantle-ios
//
//  Created by Jessica Dyer on 8/27/23.
//

import Foundation

class User {
    
    var accountAccessData: UserAccountAccessData
    var api: SAMAuthenticatedAPI
    
    init(userData: UserAccountAccessData) {
        self.accountAccessData = userData
        self.api = SAMAuthenticatedAPI(userData: userData)
    }
    
    func loadSavedData() {
        // TODO: load anything else from SAMPersistantStore
    }
    
}
