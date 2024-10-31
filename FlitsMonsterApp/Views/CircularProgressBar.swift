//
//  CircularProgressBar.swift
//  FlitsMonsterApp
//
//  Created by Jeroen de Bruin on 29/10/2024.
//

import SwiftUI

struct CircularProgressBar: View {
    var progress: Double // Value between 0.0 and 1.0
    var knownCount: Int // Count of correctly guessed words

    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 5)
                .opacity(0.3)
                .foregroundColor(.gray)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(progress))
                .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round))
                .foregroundColor(.blue)
                .rotationEffect(Angle(degrees: -90))
            
            // Display the knownCount at the center of the progress bar
            Text("\(knownCount)")
                .font(.title2)
                .bold()
                .foregroundColor(.primary)
        }
        .frame(width: 50, height: 50) // Adjust size as needed
    }
}

// Preview
struct CircularProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            CircularProgressBar(progress: 0.0, knownCount: 0)    // 0% complete
            CircularProgressBar(progress: 0.5, knownCount: 5)    // 50% complete
            CircularProgressBar(progress: 0.75, knownCount: 15)  // 75% complete
            CircularProgressBar(progress: 1.0, knownCount: 20)   // 100% complete
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
