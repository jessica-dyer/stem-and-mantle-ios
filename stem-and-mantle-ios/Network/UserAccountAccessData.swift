//
//  UserAccountAccessData.swift
//  stem-and-mantle-ios
//
//  Created by Jessica Dyer on 8/27/23.
//

import Foundation

struct UserAccountAccessData: Codable {
    
}

struct SAMTokenData: Codable {
    
}

struct SAMUserData: Codable {
    let username: String
    
    init(username: String) {
        self.username = username
    }
}
