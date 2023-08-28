//
//  SAMPersistentStore.swift
//  stem-and-mantle-ios
//
//  Created by Jessica Dyer on 8/27/23.
//

import Foundation

class SAMPersistentStore {
    
    static let forUserAccountAccess = LocalJsonFileHandler("userAccountAccess", UserAccountAccessData.self)
}
