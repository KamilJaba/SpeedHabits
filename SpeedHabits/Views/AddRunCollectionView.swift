//
//  AddRunCollectionView.swift
//  SpeedHabits
//
//  Created by Kamil Jablonski on 18/04/2024.
//

import SwiftUI

struct AddRunCollectionView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: RunSelectorViewModel

    @State private var title: String = ""
    @State private var collectionName: String = ""
    @State private var uniqueCode: String = ""

    var body: some View {
        NavigationView {
            VStack{
                Form {
                    TextField("Title", text: $title)
                    TextField("Prebuilt Run Code (optional)", text: $uniqueCode)
                    Button("Add Run Collection") {
                        if uniqueCode.isEmpty {
                            viewModel.addRunCollection(title: title)
                        } else {
                            viewModel.fetchCollectionByUniqueCode(uniqueCode, title: title) { runCollection in
                                if let runCollection = runCollection {
                                    viewModel.runs.append(runCollection)
                                }
                            }
                        }
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(title.isEmpty)
                }
                Text("Some Optional Codes")
                                   .opacity(0.5)
                Text("Gym Pull Routine: 030303")
                                   .opacity(0.5)
                Text("Sample Night Routine: Night")
                                   .opacity(0.5)
            }
            .navigationBarTitle("New Run Collection", displayMode: .inline)
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
