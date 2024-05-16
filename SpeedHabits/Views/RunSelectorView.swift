//
//  RunSelectorView.swift
//  SpeedHabits
//
//  Created by Kamil Jablonski on 18/04/2024.
//

import SwiftUI

//struct RunSelectorView: View {
//    @ObservedObject var viewModel: RunSelectorViewModel
//    @State private var showingAddRunCollection = false
//    @State private var selectedRunId: String?
//    
//    var body: some View {
//            NavigationView {
//                List(viewModel.runs, id: \.id) { run in
//                    Button(run.title) {
//                        self.selectedRunId = run.id
//                    }
//                    .background(
//                        NavigationLink(destination: RunView(userId: viewModel.userId, runCollection: run.firestoreCollection, title: run.title), tag: run.id, selection: $selectedRunId) {
//                            EmptyView()
//                        }
//                        .hidden()
//                    )
//                }
//                .navigationBarTitle("Select a Run")
//                            .navigationBarItems(trailing: Button(action: {
//                                showingAddRunCollection = true
//                            }) {
//                                Image(systemName: "plus")
//                            })
//                            .sheet(isPresented: $showingAddRunCollection) {
//                                AddRunCollectionView(viewModel: viewModel)
//                            }
//            }
//        }
//}

struct RunSelectorView: View {
    @ObservedObject var viewModel: RunSelectorViewModel
    @State private var showingAddRunCollection = false
    @State private var selectedRunId: String?
    
    var body: some View {
            NavigationView {
                List {
                    ForEach(viewModel.runs, id: \.id) { run in
                        Button(run.title) {
                            self.selectedRunId = run.id
                        }
                        .background(
                            NavigationLink(destination: RunView(userId: viewModel.userId, runCollection: run.firestoreCollection, title: run.title), tag: run.id, selection: $selectedRunId) {
                                EmptyView()
                            }
                            .hidden()
                        )
                    }
                    .onDelete(perform: deleteRun)
                }
                .navigationBarTitle("Select a Run")
                .navigationBarItems(trailing: Button(action: {
                    showingAddRunCollection = true
                }) {
                    Image(systemName: "plus")
                })
                .sheet(isPresented: $showingAddRunCollection) {
                    AddRunCollectionView(viewModel: viewModel)
                }
            }
        }

        private func deleteRun(at offsets: IndexSet) {
            viewModel.deleteRuns(at: offsets)
        }
    }
