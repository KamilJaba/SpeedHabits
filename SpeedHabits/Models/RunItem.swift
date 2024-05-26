//
//  RunItem.swift
//  SpeedHabits
//
//  Created by Kamil Jablonski on 11/01/2024.
//

import SwiftUI
import Foundation

struct RunItem: Codable, Identifiable {
    var id: String
    var title: String
    var previousTime: Int
    var currentTime: Int
    var isDone: Bool
    
    var color: Color {
            // Initially gray if not done or no attempts made
            if !isDone {
                return .white // This starts the item as white.
            }
            else {
                // Once done, calculate color based on times
                guard previousTime > 0 else { return .gray } // Assuming `previousTime` == 0 means no previous record

                if currentTime <= previousTime {
                    return .yellow // Better than previous time
                } else if currentTime - previousTime <= 30 {
                    return .green // Slightly worse
                } else {
                    return .red // Significantly worse
                }
            }
        }
    
    
}
