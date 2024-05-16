//
//  User.swift
//  SpeedHabits
//
//  Created by Kamil Jablonski on 11/01/2024.
//

import Foundation

struct User: Codable {
    let id: String
    let name: String
    let email: String
    let joined: TimeInterval
    
}
