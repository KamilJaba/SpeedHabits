//
//  RunSelectorViewModel.swift
//  SpeedHabits
//
//  Created by Kamil Jablonski on 18/04/2024.
//

import Foundation
import FirebaseFirestore

class RunSelectorViewModel: ObservableObject {
    @Published var runs: [RunCollection] = []
    private var db = Firestore.firestore()
    var userId: String
    
    init(userId: String) {
        self.userId = userId
        fetchRunCollections()
    }

    func fetchCollectionByUniqueCode(_ code: String,title: String, completion: @escaping (RunCollection?) -> Void) {
        db.collection("runCollectionCodes").whereField("collectionName", isEqualTo: code).getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching collection by unique code: \(error)")
                completion(nil)
            } else if let document = snapshot?.documents.first {
                print("Collection Found: '\(code)'.")
                print("Collection ID: '\(document.documentID)'.")
                print("Title: '\(document.get("title"))'.")
                
                self.copyRunCollection(code: code, newRunName: title)
                
            } else {
                print("No collection found with code '\(code)'.")
                completion(nil)
            }
        }
    }
    
    func copyRunCollection(code: String, newRunName: String){
        // Reference to Firestore
           let db = Firestore.firestore()
           
           // Source document reference in the 'runCollectionCodes' collection
           let sourceDocument = db.collection("runCollectionCodes").document(code)
           
           // Assuming subCollectionName is known or derived beforehand
           let sourceSubCollection = sourceDocument.collection(code)
           
           // Destination collection reference in the user's specific collection
           let destinationCollection = db.collection("users").document(userId).collection(newRunName)
           
           // Fetch all documents in the source sub-collection
           sourceSubCollection.getDocuments { (querySnapshot, error) in
               if let error = error {
                   print("Error fetching sub-collection documents: \(error.localizedDescription)")
                   return
               }
               
               guard let querySnapshot = querySnapshot else {
                   print("No documents found in sub-collection.")
                   return
               }
               
               for document in querySnapshot.documents {
                   // Get the data from each document
                   let data = document.data()
                   
                   // Write the data to the new document in the destination collection
                   destinationCollection.document(document.documentID).setData(data) { error in
                       if let error = error {
                           print("Error writing document to destination: \(error.localizedDescription)")
                       } else {
                           print("Document \(document.documentID) successfully copied!")
                       }
                   }
               }
               self.addRunCollection(title: newRunName)
           }
       }
    
    func addRunCollection(title: String) {
        let newCollection = RunCollection(id: UUID().uuidString, title: title, firestoreCollection: title)
        db.collection("users").document(userId).collection("runCollections").document(newCollection.id).setData([
                "title": title,
                "collectionName": title
            ]) { error in
                if let error = error {
                    print("Error adding new run collection: \(error)")
                } else {
                    self.runs.append(newCollection)
                }
            }
    }
    
    func deleteRuns(at offsets: IndexSet) {
        let idsToDelete = offsets.map { runs[$0].id } // Extract the IDs to delete
        idsToDelete.forEach { id in
            let documentRef = db.collection("users").document(userId).collection("runCollections").document(id)
            documentRef.getDocument { (documentSnapshot, error) in
                    if let error = error {
                        print("Error retrieving document: \(error.localizedDescription)")
                        return
                    }
                    
                    if let document = documentSnapshot, document.exists {
                        // Access the 'title' field
                        if let title = document.data()?["title"] as? String {
                            print("Title: \(title)")
                            print("Deleting User Run with that Title")
                            self.deleteRunCollection(title: "exampleCollection") { success in
                                if success {
                                    print("The collection was successfully deleted.")
                                } else {
                                    print("There was an error deleting the collection.")
                                }
                            }
                        } else {
                            print("Title field not found")
                        }
                    } else {
                        print("Document does not exist")
                    }
                }
            documentRef.delete { error in
                if let error = error {
                    print("Error deleting run collection: \(error.localizedDescription)")
                } else {
                    print("Run collection successfully deleted.")
                }
            }
        }
        runs.remove(atOffsets: offsets) // Remove the run from the local array
    }
    
    func deleteRunCollection(title: String, completion: @escaping (Bool) -> Void) {
        let collectionRef = self.db.collection("users").document(self.userId).collection(title)
        
        collectionRef.getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else {
                print("Error fetching documents for deletion: \(String(describing: error))")
                completion(false)
                return
            }
            
            // Group for tracking completion of deletion tasks
            let group = DispatchGroup()
            
            for document in snapshot.documents {
                group.enter()
                document.reference.delete { error in
                    if let error = error {
                        print("Error removing document: \(error.localizedDescription)")
                        group.leave()
                    } else {
                        print("Document successfully removed")
                        group.leave()
                    }
                }
            }
            
            group.notify(queue: .main) {
                print("All documents in collection '\(title)' have been deleted")
                completion(true)
            }
        }
    }
    
    private func fetchRunCollections() {
        let userRunCollectionsPath = "users/\(userId)/runCollections"
        db.collection(userRunCollectionsPath).getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching collections: \(error.localizedDescription)")
                return
            }
            guard let documents = snapshot?.documents, !documents.isEmpty else {
                print("No documents found in '\(userRunCollectionsPath)'.")
                return
            }
            self.runs = documents.map { document in
                RunCollection(
                    id: document.documentID,
                    title: document.get("title") as? String ?? "No Title",
                    firestoreCollection: document.get("collectionName") as? String ?? "defaultCollection"
                )
            }
        }
    }
}
