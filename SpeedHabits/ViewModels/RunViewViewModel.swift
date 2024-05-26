//
//  RunViewViewViewModel.swift
//  SpeedHabits
//
//  Created by Kamil Jablonski on 11/01/2024.
//

import Combine
import FirebaseFirestore
import SwiftUI

class RunViewViewModel: ObservableObject {
    @Published var items: [RunItem] = []
    @Published var timer = 0
    @Published var timerRunning = false

    private var db = Firestore.firestore()
    var userId: String
    private var timerSubscription: AnyCancellable?
    private let collection: String

    init(userId: String, collection: String) {
        self.userId = userId
        self.collection = collection
        fetchItems()
    }
    
    func fetchItems() {
        db.collection("users").document(userId).collection(collection)
            .addSnapshotListener { [weak self] querySnapshot, error in
                guard let self = self else { return }
                if let error = error {
                    print("Error fetching items: \(error.localizedDescription)")
                    return
                }
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                self.items = documents.compactMap { document in
                    try? document.data(as: RunItem.self)
                }
            }
    }

    func startTimer() {
        timerRunning = true
        timerSubscription = Timer.publish(every: 1, on: .main, in: .common).autoconnect().sink { [weak self] _ in
            guard let self = self else { return }
            self.timer += 1
            print("Timer updated: \(self.timer)")
        }
    }

    func resetTimer() {
        // Stop the timer
        timerRunning = false
        timerSubscription?.cancel()

        // Reset the timer count
        timer = 0

        // Reset all items to not done
        for i in 0..<items.count {
            items[i].isDone = false
            items[i].currentTime = 0
        }
        
        // Update all items in Firestore
        for item in items {
            updateItem(item)
        }
    }
    
    func splitTimer() {
        //Make sure theres a non complete item in the run
        guard let index = items.firstIndex(where: { !$0.isDone }) else { return }
        var item = items[index]

        item.isDone = true

        // Determine if the current timer value is a new best time
        //if item.currentTime == 0 || timer < item.currentTime {
        if timer <= item.previousTime {
            print("Worked")
            item.previousTime = timer
            item.currentTime = timer
        } else {
            print("ok")
            item.currentTime = timer
        }

        items[index] = item

        updateItem(item)
    }

    private func updateItem(_ item: RunItem) {
        do {
            let itemData: [String: Any] = [
                "id": item.id,
                "title": item.title,
                "previousTime": item.previousTime,
                "currentTime": item.currentTime,
                "isDone": item.isDone
            ]
            try db.collection("users").document(userId).collection(collection).document(item.id).setData(itemData)
        } catch {
            print("Failed to update item: \(error)")
        }
    }
    
    func addRunItem(_ item: RunItem) {
           let itemRef = db.collection("users").document(userId).collection(collection).document(item.id)
           do {
               try itemRef.setData(from: item)
           } catch let error {
               print("Error adding new item: \(error)")
           }
       }
    
}
