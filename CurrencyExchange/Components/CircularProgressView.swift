//
//  CircularProgressView.swift
//  CurrencyExchange
//
//  Created by Rizky Hasibuan on 17/08/22.
//

import SwiftUI

struct CircularProgressView: View {
    let progress: TimeInterval
    let maxMinutes: TimeInterval
    
    var body: some View {
        let remainingMinutes = Int(maxMinutes * progress)
        
        ZStack {
            Circle()
                .stroke(
                    Color.gray.opacity(0.5),
                    lineWidth: 3
                )
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    Color.pink,
                    style: StrokeStyle(
                        lineWidth: 3,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeOut, value: progress)
            
            Text("\(String(remainingMinutes))m")
                .font(.system(size: 10))

        }

    }
}

struct CircularProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CircularProgressView(progress: 0.25, maxMinutes: 30)
    }
}
