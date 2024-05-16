//
//  ToDoListItem.swift
//  SpeedHabits
//
//  Created by Kamil Jablonski on 11/01/2024.
//

//import Foundation
//
//struct RunItem: Codable, Identifiable {
//    let id: String
//    let title: String
//    var previousTime: Int
//    let currentTime: Int
//    var isDone: Bool
//    
//    mutating func setDone(_ state: Bool) {
//        isDone = state
//    }
//    
//    mutating func setTime(_ state: Int) {
//        previousTime = state
//    }
//}

//import Foundation
//import SwiftUI
//
//struct RunItem: Codable, Identifiable {
//    let id: String
//    let title: String
//    var previousTime: Int
//    var currentTime: Int
//    var isDone: Bool
//    private var colorString: String
//    var color: Color {
//        get {
//            Color(colorString)
//        }
//        set {
//            colorString = newValue.description
//        }
//    }
//
//    enum CodingKeys: String, CodingKey {
//        case id, title, previousTime, currentTime, isDone, colorString
//    }
//
//    mutating func setDone(_ state: Bool) {
//        isDone = state
//    }
//    
//    mutating func setTime(current: Int, previous: Int) {
//        currentTime = current
//        previousTime = previous
//    }
//    
//    mutating func setColor(_ newColor: Color) {
//        color = newColor
//    }
//
//    // Initialize with all properties, defaulting color to gray if not provided
//    init(id: String, title: String, previousTime: Int, currentTime: Int, isDone: Bool, color: Color = .gray) {
//        self.id = id
//        self.title = title
//        self.previousTime = previousTime
//        self.currentTime = currentTime
//        self.isDone = isDone
//        self.colorString = color.description
//    }
//}

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
            } else {
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
