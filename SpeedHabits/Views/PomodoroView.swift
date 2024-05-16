//
//  PomodoroView.swift
//  SpeedHabits
//
//  Created by Kamil Jablonski on 17/04/2024.
//

import SwiftUI

struct PomodoroView: View {
    @StateObject var viewModel: PomodoroViewViewModel = PomodoroViewViewModel(timer: PomodoroTimer(workDuration: 25, breakDuration: 5))
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Text("Time Remaining")
                .font(.headline)
            
            Text(timeString(time: viewModel.timeRemaining))
                .font(.system(size: 40, weight: .bold, design: .rounded))
            
            ZStack {
                Circle()
                    .stroke(lineWidth: 20)
                    .opacity(0.3)
                    .foregroundColor(Color.red)
                
                Circle()
                    .trim(from: 0.0, to: CGFloat(min(Double(viewModel.timeRemaining) / Double(viewModel.timer.workDuration * 60), 1.0)))
                    .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                    .foregroundColor(Color.red)
                    .rotationEffect(Angle(degrees: 270.0))
                    .animation(.linear, value: viewModel.timeRemaining)
                
                Text(timeString(time: viewModel.timeRemaining))
                    .font(.system(size: 20, weight: .medium, design: .rounded))
                    .padding(40)
            }
            .frame(width: 200, height: 200)
            
            Spacer()
            
            HStack(spacing: 30) {
                            Button(action: {
                                self.viewModel.startTimer()
                            }) {
                                Label("Start", systemImage: "play.circle.fill")
                            }
                            .buttonStyle(CustomButtonStyle(color: .green))
                            
                            Button(action: {
                                self.viewModel.stopTimer()
                            }) {
                                Label("Stop", systemImage: "pause.circle.fill")
                            }
                            .buttonStyle(CustomButtonStyle(color: .red))
                            
                            Button(action: {
                                self.viewModel.resetTimer()
                            }) {
                                Label("Reset", systemImage: "gobackward")
                            }
                            .buttonStyle(CustomButtonStyle(color: .blue))
                        }

            VStack(spacing: 10) {
                DurationInputField(label: "Work Duration (min):", duration: $viewModel.timer.workDuration)
                DurationInputField(label: "Break Duration (min):", duration: $viewModel.timer.breakDuration)
            }
            .padding(.horizontal, 30)
            
            Spacer()
        }
        .padding()
    }
    
    func timeString(time: Int) -> String {
        let minutes = time / 60
        let seconds = time % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct DurationInputField: View {
    var label: String
    @Binding var duration: Int
    
    var body: some View {
        HStack {
            Text(label)
                .font(.headline)
            Spacer()
            TextField("", value: $duration, formatter: NumberFormatter())
                .keyboardType(.numberPad)
                .textFieldStyle(.roundedBorder)
                .frame(width: 70)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("Done") {
                            UIApplication.shared.endEditing()
                        }
                    }
                }
        }
    }
}

struct CustomButtonStyle: ButtonStyle {
    var color: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding()
            .background(LinearGradient(gradient: Gradient(colors: [color, color.opacity(0.7)]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
            .shadow(radius: configuration.isPressed ? 2 : 5)
    }
}

// Help getting rid of keypad
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
