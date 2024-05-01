//
//  BloodView.swift
//  TomatoMurderer
//
//  Created by mg0 on 29/04/24.
//

import SwiftUI
import AVFoundation

struct BloodView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        ZStack {
            Spacer()
        }
        .background(.colorBloodRed)
        .ignoresSafeArea()
        .onAppear() {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                appState.switchView = .hideKnife
            }
        }
    }
}

//#Preview {
//    BloodView()
//}
