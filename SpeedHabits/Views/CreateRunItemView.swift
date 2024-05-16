//
//  CreateRunItemView.swift
//  SpeedHabits
//
//  Created by Kamil Jablonski on 17/04/2024.
//

import SwiftUI

struct CreateRunItemView: View {
    @ObservedObject var viewModel: RunViewViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var title: String = ""
    @State private var previousTimeString: String = ""
    @State private var currentTime: Int = 0
    @State private var isDone: Bool = false
    @State private var timeStamp: Int?


    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Details")) {
                    TextField("Title", text: $title)
                        .textContentType(.name)
                        .autocapitalization(.words)
                }
                
                Section(header: Text("Performance")) {
                    HStack {
                        Text("Previous Best Time")
                        Spacer()
                        TextField("(Optional)", text: $previousTimeString)
                            .keyboardType(.numberPad)
                    }
                    
//                    HStack {
//                        Text("Current Time")
//                        Spacer()
//                        TextField("Time in seconds", value: $currentTime, formatter: NumberFormatter())
//                            .keyboardType(.numberPad)
//                    }
                }
                
//                Section {
//                    Toggle("Completion Status", isOn: $isDone)
//                }
                
                Section {
                    Button("Save") {
                        let previousTime = Int(previousTimeString) ?? 100000  // Default to 100000 so it can show as not done
                        let newItem = RunItem(id: UUID().uuidString, title: title, previousTime: previousTime, currentTime: currentTime, isDone: isDone)
                        viewModel.addRunItem(newItem)
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(title.isEmpty)
                }
            }
            .navigationBarTitle("New Run Item", displayMode: .inline)
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
       private func setCurrentTimeStamp() {
           // Get current time in seconds
           let currentTimeInSeconds = Int(Date().timeIntervalSince1970)
           timeStamp = currentTimeInSeconds
       }
}
