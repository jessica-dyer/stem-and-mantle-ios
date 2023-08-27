//
//  UserAccountAccessData.swift
//  stem-and-mantle-ios
//
//  Created by Jessica Dyer on 8/27/23.
//

import Foundation

struct UserAccountAccessData: Codable {
    var host: SAMAPIHost
    var tokenData: SAMTokenData
    
    init(host: SAMAPIHost, tokenData: SAMTokenData) {
        self.host = host
        self.tokenData = tokenData
    }
    
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.host = try container.decode(SAMAPIHost.self, forKey: .host)
//        self.tokenData = try container.decode(SAMTokenData.self, forKey: .tokenData)
//    }
}

struct SAMTokenData: Codable {
    var accessToken: String
    var refreshToken: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}

struct SAMUserData: Codable {
    let username: String
    
    init(username: String) {
        self.username = username
    }
}
