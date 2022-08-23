//
//  CircularProgressView.swift
//  CurrencyExchange
//
//  Created by Rizky Hasibuan on 17/08/22.
//

import SwiftUI

struct CircularProgressView: View {
    // MARK: - Private Properties
    
    private let currentDate = Date()
    
    // MARK: - Public Properties
    
    let expires: Date
    
    let expiredDuration: TimeInterval
    
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

    }
}

private extension CircularProgressView {
    func remainingInterval() -> TimeInterval {
        let interval = expires.timeIntervalSince1970 - currentDate.timeIntervalSince1970 + expiredDuration
        
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
        return Double(expiredDuration - remainingInterval()) / expiredDuration
    }
}
