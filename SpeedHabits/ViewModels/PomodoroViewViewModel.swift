//
//  PomodoroViewModel.swift
//  SpeedHabits
//
//  Created by Kamil Jablonski on 17/04/2024.
//

import Foundation

import Combine

class PomodoroViewViewModel: ObservableObject {
    @Published var timer: PomodoroTimer
    @Published var timerIsActive: Bool = false
    @Published var timeRemaining: Int
    @Published var isWorkInterval: Bool = true  // Indicates if the current interval is a work interval
    private var cancellables: Set<AnyCancellable> = []
    private var timerPublisher: AnyPublisher<Date, Never>?

    init(timer: PomodoroTimer) {
        self.timer = timer
        self.timeRemaining = timer.workDuration * 60  // Start with the work duration
    }

    func startTimer() {
        timerIsActive = true
        timerPublisher = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect().eraseToAnyPublisher()

        timerPublisher?.sink(receiveValue: { [weak self] _ in
            guard let strongSelf = self else { return }
            if strongSelf.timeRemaining > 0 {
                strongSelf.timeRemaining -= 1
            } else {
                strongSelf.toggleInterval()
            }
        })
        .store(in: &cancellables)
    }

    func stopTimer() {
        timerIsActive = false
        cancellables.forEach { $0.cancel() }
    }

    func resetTimer() {
        timerIsActive = false
        isWorkInterval = true
        timeRemaining = timer.workDuration * 60
        cancellables.forEach { $0.cancel() }
    }

    private func toggleInterval() {
        isWorkInterval.toggle()
        timeRemaining = isWorkInterval ? timer.workDuration * 60 : timer.breakDuration * 60
    }
}
