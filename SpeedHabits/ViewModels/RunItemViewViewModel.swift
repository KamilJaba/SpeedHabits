//
//  ToDoListItemViewViewModel.swift
//  SpeedHabits
//
//  Created by Kamil Jablonski on 11/01/2024.
//

import SwiftUI

import FirebaseFirestore

class RunItemViewViewModel: ObservableObject {
    @Published var runItem: RunItem
    private var db = Firestore.firestore()

    init(runItem: RunItem) {
        self.runItem = runItem
    }

    func toggleIsDone() {
        runItem.isDone.toggle()
        updateRunItem(runItem)
    }

    private func updateRunItem(_ item: RunItem) {
        let itemRef = db.collection("users").document("userId").collection("runItems").document(item.id)
        
        itemRef.updateData([
            "isDone": item.isDone
        ]) { error in
            if let error = error {
                print("Error updating item: \(error.localizedDescription)")
                self.runItem.isDone.toggle()

            }
        }
    }
    
    func updateRunItemInFirestore() {
            let itemRef = db.collection("users").document("userId").collection("runItems").document(runItem.id)
            do {
                try itemRef.setData(from: runItem)
            } catch let error {
                print("Error updating item: \(error.localizedDescription)")
            }
        }
}
