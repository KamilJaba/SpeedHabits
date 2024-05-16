//
//  NewItemViewViewModel.swift
//  SpeedHabits
//
//  Created by Kamil Jablonski on 11/01/2024.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation

class NewRunItemViewViewModel: ObservableObject {
    @Published var title = ""
    @Published var dueDate = Date()
    @Published var showAlert = false
    
    init() {}
    
    func save() {
        guard canSave else {
            return
        }
        
        //Get Current user id
        guard let uId = Auth.auth().currentUser?.uid else {
            return
        }
        
        //Create a model for item
        let newId = UUID().uuidString
        let newItem = RunItem(id: newId, title: title, previousTime: 0,currentTime: 0, isDone: false)
        
        
        //Saving Model
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(uId)
            .collection("runItems")
            .document(newId)
            .setData(newItem.asDictionary())
    }
    
    var canSave: Bool {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            return false
        }
        
        
        return true
    }
}
