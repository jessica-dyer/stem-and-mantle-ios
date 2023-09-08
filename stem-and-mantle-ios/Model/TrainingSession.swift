//
//  Session.swift
//  stem-and-mantle-ios
//
//  Created by Jessica Dyer on 9/8/23.
//

import Foundation

struct TrainingSession: Codable, Identifiable {
    let id: Int
    let date: String
    let notes: String
}
