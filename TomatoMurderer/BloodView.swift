//
//  BloodView.swift
//  TomatoMurderer
//
//  Created by mg0 on 29/04/24.
//

import SwiftUI

struct BloodView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        ZStack {
            Spacer()
        }
        .background(.red).ignoresSafeArea()
        .onAppear() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                appState.switchView = .hideKnife
            }
        }
    }
}

#Preview {
    BloodView()
}
