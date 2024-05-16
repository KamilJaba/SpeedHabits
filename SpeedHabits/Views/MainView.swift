//
//  ContentView.swift
//  SpeedHabits
//
//  Created by Kamil Jablonski on 30/12/2023.
//

import SwiftUI

struct MainView: View {
    @StateObject var viewModel = MainViewViewModel()
    
    var body: some View {
        if viewModel.isSignedIn, !viewModel.currentUserId.isEmpty {
            accountView
        }
        else{
            LoginView()
        }
    }
    
    @ViewBuilder
    var accountView: some View {
        //signed in
        TabView {
//            RunView(userId: viewModel.currentUserId)
//                .tabItem{
//                    Label("Runs", systemImage: "person.circle")
//                }
//            RunView(userId: viewModel.currentUserId)
//                .tabItem{
//                    Label("Runs", systemImage: "person.circle")
//                }
            RunSelectorView(viewModel: RunSelectorViewModel(userId: viewModel.currentUserId))
                .tabItem{
                    Label("Runs", systemImage: "person.circle")
                }
            ToDoListView(userId: viewModel.currentUserId)
                .tabItem{
                    Label("Habits", systemImage: "repeat")
                }
//            TimerView()
//                .tabItem{
//                    Label("Timer", systemImage: "clock.arrow.2.circlepath")
//                }
            PomodoroView()
                            .tabItem {
                                Label("Pomodoro", systemImage: "clock.arrow.2.circlepath")
                            }
                            
    
            ProfileView()
                .tabItem{
                    Label("Profile", systemImage: "person.circle")
                }
            
            
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

