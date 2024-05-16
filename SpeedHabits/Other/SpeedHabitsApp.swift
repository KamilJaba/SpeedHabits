//
//  SpeedHabitsApp.swift
//  SpeedHabits
//
//  Created by Kamil Jablonski on 30/12/2023.
//

import FirebaseCore
import SwiftUI

@main
struct SpeedHabitsApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
