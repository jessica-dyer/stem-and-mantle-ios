//
//  SAMPersistentStore.swift
//  stem-and-mantle-ios
//
//  Created by Jessica Dyer on 8/27/23.
//

import Foundation

class SAMPersistentStore {
    
    static let forUserAccountAccess = LocalJsonFileHandler("userAccountAccess", UserAccountAccessData.self)
    
    static func eraseAllUserData() {
        forUserAccountAccess.erase()
        // TODO: If any more file handles are added with user specific data, erase their contents too. 
    }
}
