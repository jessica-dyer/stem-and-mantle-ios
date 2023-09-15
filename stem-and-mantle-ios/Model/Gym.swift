//
//  Gym.swift
//  stem-and-mantle-ios
//
//  Created by Jessica Dyer on 9/14/23.
//

import Foundation

enum Gym: String, CaseIterable, Identifiable {
        case verticalWorldSeattle = "Vertical World: Seattle"
        case verticalWorldNorth = "Vertical World: North"
        case other = "Other"
        
        var id: String { rawValue }
    }
