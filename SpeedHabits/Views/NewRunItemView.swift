//
//  NewRunItemView.swift
//  SpeedHabits
//
//  Created by Kamil Jablonski on 11/01/2024.
//

import SwiftUI

struct NewRunItemView: View {
    @StateObject var viewModel = NewRunItemViewViewModel()
    @Binding var newItemPresented: Bool
    
    var body: some View {
        VStack {
            Text("Add Habit to Run")
                .font(.system(size: 32))
                .bold()
                .padding(.top, 100)
            
            Form {
                //Title
                TextField("Habit Name", text: $viewModel.title)
                    .textFieldStyle(DefaultTextFieldStyle())
                
                //Button
                SHButton(title: "Save", background: .pink) {
                    if viewModel.canSave {
                        viewModel.save()
                        newItemPresented = false
                    } else {
                        viewModel.showAlert = true
                    }
                    
                }
                .padding()
            }
            .alert(isPresented: $viewModel.showAlert){
                Alert(title: Text("Error"), message: Text("Please fill in all fields and select due date that isn't in the past"))
            }
        }
    }
}

struct NewRunItemView_Previews: PreviewProvider {
    static var previews: some View {
        NewRunItemView(newItemPresented: Binding(get: {
            return true
        }, set: { _ in }
                                             ))
    }
}
