//
//  User.swift
//  stem-and-mantle-ios
//
//  Created by Jessica Dyer on 8/27/23.
//

import Foundation

class User {

    var api: SAMAuthenticatedAPI
    
    init(userData: UserAccountAccessData) {
        self.api = SAMAuthenticatedAPI(userData: userData)
    }
    
}
