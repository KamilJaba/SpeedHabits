//
//  ToDoListView.swift
//  SpeedHabits
//
//  Created by Kamil Jablonski on 11/01/2024.
//
//
//import FirebaseFirestoreSwift
//import SwiftUI
//
//struct RunView: View {
//    @StateObject var viewModel: RunViewViewModel
//    @FirestoreQuery var items: [RunItem]
//    
//    @State var countdownTimer = 100
//    @State var timerRunning = false
//    @State var split = 0
//    @State var CurrentColor = Color.gray
//    
//    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
//    
//    let hours = 0
//    let minutes = 0
//    let seconds = 0
//    
//    
//    
//    init(userId: String) {
//        // users/<id>/todos/<entries>
//        self._items = FirestoreQuery(collectionPath: "users/\(userId)/runItems")
//        
//        self._viewModel = StateObject(
//            wrappedValue: RunViewViewModel(userId: userId))
//        
//    }
//    
//    var body: some View {
//        NavigationView{
//            VStack{
//                VStack{
//                    List(items) { item in
//                        RunItemView(item: item)
//                            .swipeActions {
//                                Button("Delete") {
//                                    viewModel.delete(id: item.id)
//                                }
//                                .tint(.red)
//                            }
//                            //.listRowBackground(Color.red.opacity(0.3)) Background of Row
//                            .listRowBackground(CurrentColor)
//                    }
//                    .listStyle(PlainListStyle())
//                    
//                    //.foregroundColor(Color.red) TITLE TEXT "Make Bed"
//                }
//                .navigationTitle("Habit Run")
//                .toolbar{
//                    Button{
//                        // Action
//                        viewModel.showingNewItemView = true
//                    } label: {
//                        Image(systemName: "plus")
//                    }
//                }
//                .sheet(isPresented: $viewModel.showingNewItemView) {
//                    NewRunItemView(newItemPresented: $viewModel.showingNewItemView)
//                }
//                VStack(spacing:0) {
//                    Text(
//                        "\((countdownTimer % 3600) / 60)" + ":" + "\((countdownTimer) % 60)")
//                    //Text("Duration: \(hours) hours, \(minutes) minutes, \(seconds) seconds")
//                        .padding()
//                        .onReceive(timer) { _ in
//                            if countdownTimer >= 0 && timerRunning {
//                                countdownTimer += 1
//                                
//                                let hours = countdownTimer / 3600
//                                let minutes = (countdownTimer % 3600) / 60
//                                let seconds = countdownTimer % 60
//                            } else {
//                                timerRunning = false
//                            }
//                            
//                        }
//                        .font(.system(size: 40, weight: .bold))
//                    
//                    HStack(spacing:20) {
//                        Button("Start") {
//                            timerRunning = true
//                        }
//                        
//                        Button("Split") {
//                        }.foregroundColor(.green)
//                        
//                        
//                        Button("Reset") {
//                            countdownTimer = 0
//                        }.foregroundColor(.red)
//                        
//                        Button("Finish") {
//                            timerRunning = false
//                        }.foregroundColor(.yellow)
//                    }
//                    .padding(.bottom, 50)                }
//                }}}}
//        
//
//
//
//struct RunView_Previews: PreviewProvider {
//    static var previews: some View {
//        RunView(userId: "TV0IJX4Ep9bg6q7dUfClQXVlaRY2")
//    }
//}

//import FirebaseFirestoreSwift
//import SwiftUI
//
//struct RunView: View {
//    @StateObject var viewModel: RunViewViewModel
//    @FirestoreQuery var items: [RunItem]
//    @State var timer = 0  // This will hold the current timer value in seconds
//    @State var timerRunning = false
//
//    let timerPublisher = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
//    
//    init(userId: String) {
//            print("Using userId: \(userId)")
//            self._items = FirestoreQuery(collectionPath: "users/\(userId)/runItems")
//    
//            self._viewModel = StateObject(
//                wrappedValue: RunViewViewModel(userId: userId))
//        }
//
//    var body: some View {
//            VStack {
//                List(items) { item in
//                    RunItemView(item: item)
//                        .listRowBackground(item.color)  // Use dynamic color
//                }
//                .onAppear {
//                    print("Items loaded: \(items.count)")
//                }
//
//                HStack {
//                    Button("Start/Stop") {
//                        timerRunning.toggle()
//                    }
//                    
//                    Button("Split") {
//                        viewModel.handleSplit(lastItem: items.last, splitTime: timer)
//                    }
//                }
//            }
//            .onReceive(timerPublisher) { _ in
//                if timerRunning {
//                    timer += 1
//                }
//            }
//        }
//    }


//import Combine
//import SwiftUI
//
//struct RunView: View {
//    @StateObject var viewModel: RunViewViewModel
//
//    // Initialize RunView with a userId string
//    init(userId: String) {
//        // Initialize the ViewModel with the userId
//        _viewModel = StateObject(wrappedValue: RunViewViewModel(userId: userId))
//    }
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                List {
//                    ForEach(viewModel.items) { item in
//                        RunItemView(viewModel: RunItemViewViewModel(runItem: item, timerPublisher: viewModel.timerPublisher))
//                    }
//                }
//                .navigationTitle("Running Items")
//                
//                Spacer()
//                timerDisplay
//                timerControls
//            }
//        }
//    }
//
//    var timerControls: some View {
//        HStack {
//            Button("Start") {
//                viewModel.startTimer()
//            }
//            Button("Reset") {
//                viewModel.resetTimer()
//            }
//            Button("Split") {
//                viewModel.splitTimer()
//            }
//        }
//        .padding()
//        .background(Color(UIColor.secondarySystemBackground))
//        .cornerRadius(10)
//    }
//
//    var timerDisplay: some View {
//        Text("Timer: \(viewModel.timer) seconds")
//            .font(.title)
//            .padding()
//    }
//}

import SwiftUI

struct RunView: View {
    @StateObject var viewModel: RunViewViewModel
    @State private var selectedItem: RunItem?
    @State private var showEditModal = false
    @State private var showingCreateModal = false
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
                            .listRowBackground(item.color)
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
