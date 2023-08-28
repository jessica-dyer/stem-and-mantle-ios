//
//  UserInfo.swift
//  stem-and-mantle-ios
//
//  Created by Jessica Dyer on 8/27/23.
//

import Foundation

struct UserInfo: Codable {
    var id: Int
    var username: String
    var createdAt: String
    var updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
