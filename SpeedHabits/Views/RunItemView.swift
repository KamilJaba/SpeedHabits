//
//  ToDoListItemView.swift
//  SpeedHabits
//
//  Created by Kamil Jablonski on 11/01/2024.
//

import SwiftUI


struct RunItemView: View {
    @ObservedObject var viewModel: RunItemViewViewModel

    var body: some View {
            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.runItem.title)
                    .font(.headline)

                HStack {
                    Text("Current: \(viewModel.runItem.currentTime)s")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    if viewModel.runItem.previousTime == 100000 {
                        Text("Best Time: N/A")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    } else {
                        Text("Best Time: \(viewModel.runItem.previousTime)s")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding()
            .background(viewModel.runItem.color) // Background color based on item performance
            .cornerRadius(8)
        }
    }
