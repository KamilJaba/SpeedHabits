//
//  ProfileView.swift
//  SpeedHabits
//
//  Created by Kamil Jablonski on 11/01/2024.
//

import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel = ProfileViewViewModel()
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            VStack {
                if let user = viewModel.user {
                    profile(user: user)
                        .padding()
                } else {
                    ProgressView("Loading Profile...")
                }
            }
            .navigationTitle("Profile")
            .navigationBarItems(trailing: logoutButton)
            .background(colorScheme == .dark ? Color.black : Color.white) // Adapt background color to theme
            .onAppear {
                viewModel.fetchUser()
            }
        }
    }
    
    @ViewBuilder
    private func profile(user: User) -> some View {
        VStack(spacing: 20) {
            // Avatar
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .clipShape(Circle())
                .shadow(radius: 10)
                .overlay(Circle().stroke(Color.blue, lineWidth: 3))
                .padding(.top, 20)
            
            // Info Card
            VStack(spacing: 10) {
                Text(user.name)
                    .font(.title)
                    .fontWeight(.bold)
                
                Text(user.email)
                    .foregroundColor(.secondary)
                
                Text("Member Since: \(Date(timeIntervalSince1970: user.joined).formatted(date: .abbreviated, time: .shortened))")
                    .foregroundColor(.secondary)
                    .font(.footnote)
            }
            .padding()
            .background(Color(UIColor.systemBackground)) // Use system background color
            .cornerRadius(10)
            .shadow(radius: 5)
            
            Spacer()
        }
        .padding(.horizontal)
    }
    
    private var logoutButton: some View {
        Button("Log Out") {
            viewModel.logOut()
        }
        .foregroundColor(.red)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
