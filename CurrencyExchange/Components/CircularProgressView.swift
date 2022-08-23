//
//  CircularProgressView.swift
//  CurrencyExchange
//
//  Created by Rizky Hasibuan on 17/08/22.
//

import SwiftUI

struct CircularProgressView: View {
    // MARK: - Private Properties
    
    @State private var currentTime = Date()
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    private let counter: TimeInterval = 0
    
    // MARK: - Public Properties
    
    let expiredTime: Date
    
    let expiryDuration: TimeInterval
    
    var onExpired: () -> Void
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    Color.gray.opacity(0.5),
                    lineWidth: 3
                )
            Circle()
                .trim(from: 0, to: progress())
                .stroke(
                    Color.pink,
                    style: StrokeStyle(
                        lineWidth: 3,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeOut, value: progress())
            
            Text("\(String(remainingMinutes()))m")
                .font(.system(size: 10))

        }
        .onReceive(timer) { time in
            currentTime = time
            
            if progress() >= 1 {
                onExpired()
            }
        }
    }
}

private extension CircularProgressView {
    func remainingInterval() -> TimeInterval {
        let interval = expiredTime.timeIntervalSince1970 -
                       currentTime.timeIntervalSince1970 +
                       expiryDuration +
                       counter
        
        return interval
    }
    
    func remainingMinutes() -> Int {
        let interval = remainingInterval()
        let minutesInHour = 60
        let secondsInMinutes = 60
        let minutes = Int(interval) / secondsInMinutes % minutesInHour
        return Int(minutes)
    }
    
    func progress() -> Double {
        return Double(expiryDuration - remainingInterval()) / expiryDuration
    }
}
