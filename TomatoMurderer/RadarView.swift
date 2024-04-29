//
//  RadarView.swift
//  TomatoMurderer
//
//  Created by mg0 on 29/04/24.
//

import SwiftUI

struct RadarView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        Text("Radar View!")
        Button(action: {
//                appState.switchView = .murder
        }) {
            Image("blueStartButton")
                .resizable()
                .frame(width: 110, height: 100)
        }
    }
}

#Preview {
    RadarView()
}
