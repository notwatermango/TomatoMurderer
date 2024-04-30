//
//  FindingObjectView.swift
//  TomatoMurderer
//
//  Created by mg0 on 29/04/24.
//

import SwiftUI

struct FindingObjectView: View {
    @EnvironmentObject var appState: AppState
    
    @State private var objectFound = false
    
    var body: some View {
        VStack {
            Text("Finding Object View!")
            Button(action: {
                appState.switchView = .ending
            }) {
                Image(systemName: "camera.viewfinder")
                    .resizable()
                    .frame(width: 110, height: 100)
            }
        }
    }
}

#Preview {
    FindingObjectView()
}
