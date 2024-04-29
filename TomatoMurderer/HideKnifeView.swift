//
//  HideKnifeView.swift
//  TomatoMurderer
//
//  Created by mg0 on 29/04/24.
//

import SwiftUI
import AVFoundation


struct HideKnifeView: View {
    @State private var knifeInContainer: [Knife] = [Knife(image: "knifeBlood")]
    @State private var knifeInHiding: [Knife] = []
    
    @State private var isKnifeContainerTargeted = false
    @State private var isVictimTargeted = false
    
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack {
            KnifeContainerView(knives: knifeInContainer, isTargeted: isKnifeContainerTargeted)
            HidingContainerView(knives: knifeInHiding, isTargeted: isVictimTargeted)
                .dropDestination(for: Knife.self) { droppedKnives, location in
                    for knife in droppedKnives {
                        knifeInContainer.removeAll { $0 == knife }
                    }
                    knifeInHiding += droppedKnives
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        appState.switchView = .detectiveStart
                    }
                    return true
                } isTargeted: { isTargeted in
                    isVictimTargeted = isTargeted
                }
        }
        .padding()
    }
}

struct HidingContainerView: View {
    let knives: [Knife]
    let isTargeted: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            //                .foregroundColor(isTargeted ? .teal.opacity(0.15): Color(.secondarySystemFill))
                .foregroundColor(.clear)
            // TODO change to
            Image("farmerWithTomatoes")
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            VStack {
                ForEach(knives, id: \.self) { knife in
                    Image(knife.image)
                        .resizable()
                        .rotationEffect(Angle(degrees: 180))
                        .frame(width: 70, height: 150)
                        .draggable(knife)
                }
            }
        }
        .padding()
    }
}

#Preview {
    HideKnifeView()
}
