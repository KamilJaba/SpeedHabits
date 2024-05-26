//
//  RunView.swift
//  SpeedHabits
//
//  Created by Kamil Jablonski on 11/01/2024.
//
//

import SwiftUI

struct RunView: View {
    @StateObject var viewModel: RunViewViewModel
    @State private var selectedItem: RunItem?
    @State private var showEditModal = false
    @State private var showingCreateModal = false
    @Environment(\.colorScheme) var colorScheme
    var userId: String
        var runCollection: String
    var title: String

    init(userId: String, runCollection: String, title: String) {
            self.userId = userId
            self.runCollection = runCollection
            self.title = title
            // Initialize the viewModel here after all other properties
            _viewModel = StateObject(wrappedValue: RunViewViewModel(userId: userId, collection: runCollection))
        }
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(viewModel.items) { item in
                        RunItemView(viewModel: RunItemViewViewModel(runItem: item))
                            .listRowBackground(backgroundColor(for: item))
                            .onTapGesture {
                                self.selectedItem = item
                                self.showEditModal = true
                            }
                    }
                }
                .sheet(isPresented: $showEditModal, onDismiss: {
                    self.selectedItem = nil
                }) {
                    if let selectedItem = selectedItem {
                        EditRunItemView(runItem: .constant(selectedItem))
                    }
                }

                Spacer()
                timerDisplay
                timerControls
            }
            .scrollContentBackground(.hidden)
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button(action: {
                            showingCreateModal = true
                        }) {
                            Image(systemName: "plus")
                        })
                        .sheet(isPresented: $showingCreateModal) {
                            CreateRunItemView(viewModel: viewModel)
                        }
        }
    }
    
    var timerControls: some View {
           HStack {
               Button(action: viewModel.startTimer) {
                   Label("Start", systemImage: "play.fill")
               }
               .buttonStyle(TimerButtonStyle())

               Button(action: viewModel.resetTimer) {
                   Label("Reset", systemImage: "gobackward")
               }
               .buttonStyle(TimerButtonStyle())

               Button(action: viewModel.splitTimer) {
                   Label("Split", systemImage: "scissors")
               }
               .buttonStyle(TimerButtonStyle())
           }
       }

       var timerDisplay: some View {
           Text("\(viewModel.timer.formatted()) seconds")
           
               .font(.system(.title, design: .monospaced))
               .padding()
               .frame(minWidth: 0, maxWidth: 320, minHeight: 60)
               .background(Color.teal.opacity(0.50))
               .foregroundColor(.white)
               .clipShape(RoundedRectangle(cornerRadius: 15))
               .shadow(radius: 10)
               .transition(.slide)
       }
    
    private func backgroundColor(for item: RunItem) -> Color {
            if item.color == .white && colorScheme == .dark {
                return .black
            } else {
                return item.color
            }
        }
   }

   struct TimerButtonStyle: ButtonStyle {
       func makeBody(configuration: Configuration) -> some View {
           configuration.label
               .padding()
               .background(Color.teal.opacity(configuration.isPressed ? 0.5 : 1.0))
               .foregroundColor(.white)
               .clipShape(Capsule())
               .shadow(radius: configuration.isPressed ? 0 : 5)
               .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
               .animation(.spring(), value: configuration.isPressed)
               .padding(.bottom, 10)
       }
   }

extension Int {
    func toTimerFormat() -> String {
        let minutes = self / 60
        let seconds = self % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
