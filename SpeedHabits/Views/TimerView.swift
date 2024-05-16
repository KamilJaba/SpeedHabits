//
//  TimerView.swift
//  SpeedHabits
//
//  Created by Kamil Jablonski on 08/02/2024.
//

import SwiftUI

struct TimerView: View {
    @State var countdownTimer = 0
    @State var timerRunning = false
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    let hours = 0
    let minutes = 0
    let seconds = 0
    
    
    var body: some View {
        NavigationView{
            
            
            VStack {
                Text("\(countdownTimer) seconds")
                //Text("Duration: \(hours) hours, \(minutes) minutes, \(seconds) seconds")
                    .padding()
                    .onReceive(timer) { _ in
                        if countdownTimer >= 0 && timerRunning {
                            countdownTimer += 1
                            
                            let hours = countdownTimer / 3600
                            let minutes = (countdownTimer % 3600) / 60
                            let seconds = countdownTimer % 60
                        } else {
                            timerRunning = false
                        }
                        
                    }
                    .font(.system(size: 40, weight: .bold))
                
                HStack(spacing:30) {
                    Button("Start") {
                        timerRunning = true
                    }
                    
                    Button("Stop") {
                        timerRunning = false
                    }.foregroundColor(.yellow)
                    
                    Button("Reset") {
                        countdownTimer = 0
                    }.foregroundColor(.red)
                    
                    Button("Lap") {
                        
                    }.foregroundColor(.green)
                }
            }
            .navigationTitle("Timer Test")
            .toolbar{
                Button{
                    // Action
                } label: {
                    Image(systemName: "plus")
                }
            }}}}
