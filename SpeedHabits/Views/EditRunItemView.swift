//
//  EditRunItemView.swift
//  SpeedHabits
//
//  Created by Kamil Jablonski on 17/04/2024.
//

import SwiftUI

struct EditRunItemView: View {
    @Binding var runItem: RunItem
    
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Run Details").font(.headline)) {
                    TextField("Name", text: $runItem.title)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.vertical, 5)

                    HStack {
                        Text("Previous Best Time:")
                        Spacer()
                        TextField("Seconds", value: $runItem.previousTime, formatter: NumberFormatter())
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                    }
                    .padding(.vertical, 5)
                }

                Section {
                    Button(action: {
                        saveRunItem()
                    }) {
                        Text("Save Changes")
                            .bold()
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, minHeight: 44)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .navigationBarTitle("Edit Run Item", displayMode: .inline)
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
        .padding(.horizontal)
    }
    
    private func saveRunItem() {
        presentationMode.wrappedValue.dismiss()
    }
}
