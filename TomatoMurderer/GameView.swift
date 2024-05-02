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
        case murdererStart
        case detectiveStart
        case radar
        case findingObject
        case ending
    }
    
    @Published var switchView = CurrentView.murdererStart
    
}


struct GameView: View {
    @StateObject var appState = AppState()
    @State private var currentView: AppState.CurrentView = .murdererStart
    var body: some View {
        
        NavigationView {
            ZStack {
                Color.yellow.edgesIgnoringSafeArea(.all)
                switch appState.switchView { // Access directly
                case .murder:
                    MurderView()
                        .environmentObject(appState)
                        .transition(.opacity)
                case .blood:
                    BloodView()
                        .environmentObject(appState)
                        .transition(.slide)
                case .hideKnife:
                    HideKnifeView()
                        .environmentObject(appState)
                        .transition(.opacity)
                case .murdererStart:
                    MurdererStartView()
                        .environmentObject(appState)
                        .transition(.opacity)
                case .detectiveStart:
                    DetectiveStartView()
                        .environmentObject(appState)
                        .transition(.opacity)
                case .radar:
                    RadarView()
                        .environmentObject(appState)
                        .transition(.opacity)
                case .findingObject:
                    FindingObjectView()
                        .environmentObject(appState)
                        .transition(.opacity)
                case .ending:
                    EndingView()
                        .environmentObject(appState)
                        .transition(.opacity)
                }
            }
        }
    }
}

#Preview {
    GameView()
}
