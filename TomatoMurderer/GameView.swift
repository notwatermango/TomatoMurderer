//
//  GameView.swift
//  TomatoMurderer
//
//  Created by mg0 on 29/04/24.
//

import SwiftUI


class AppState: ObservableObject {
    enum CurrentView: Int {
        case murder
        case blood
        case hideKnife
    }
    
    @Published var switchView = CurrentView.murder
    
}


struct GameView: View {
    @StateObject var appState = AppState()
    @State private var currentView: AppState.CurrentView = .murder
    var body: some View {
        NavigationView {
            switch appState.switchView { // Access directly
            case .murder:
                MurderView()
                    .environmentObject(appState)
            case .blood:
                BloodView()
                    .environmentObject(appState)
            case .hideKnife:
                HideKnifeView()
                    .environmentObject(appState)
            }
        }
    }
}

#Preview {
    GameView()
}
