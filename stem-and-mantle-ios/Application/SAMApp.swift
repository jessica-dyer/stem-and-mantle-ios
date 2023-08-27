//
//  SAMApp.swift
//  stem-and-mantle-ios
//
//  Created by Jessica Dyer on 8/27/23.
//

import Foundation

class SAMApp {
    let api: SAMUnauthenticatedAPI
    var user: User?
    
    init() {
        self.api = SAMUnauthenticatedAPI(host: .prod)
        self.user = nil
    }
    
}
