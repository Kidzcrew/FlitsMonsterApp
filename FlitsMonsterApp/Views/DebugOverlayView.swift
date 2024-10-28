//
//  DebugOverlayView.swift
//  FlitsMonsterApp
//
//  Created by Jeroen de Bruin on 27/10/2024.
//


import SwiftUI

struct DebugOverlayView: View {
    let flitstijdCountdown: Int
    let onzichtbaarnaCountdown: Int
    let knownCount: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("⏳ Flitstijd Timer: \(flitstijdCountdown)s")
            Text("⏳ OnzichtbaarNa Timer: \(onzichtbaarnaCountdown)s")
            Text("✅ Known Words: \(knownCount)")
        }
        .font(.footnote)
        .padding(10)
        .background(Color.black.opacity(0.7))
        .foregroundColor(.white)
        .cornerRadius(8)
        .padding(.top, 20)
        .padding(.leading, 20)
    }
}