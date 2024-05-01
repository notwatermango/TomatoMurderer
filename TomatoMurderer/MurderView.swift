//
//  ContentView.swift
//  TomatoMurderer
//
//  Created by mg0 on 26/04/24.
//

import SwiftUI
import AVFoundation

enum BloodImageEnum: String {
    case one = "bloodOne"
    case two = "bloodTwo"
    case three = "bloodThree"
    case four = "bloodFour"
    case five = "bloodFive"
    case six = "bloodSix"
    
    func next() -> BloodImageEnum {
        switch self {
        case .one: return .two
        case .two: return .three
        case .three: return .four
        case .four: return .five
        case .five: return .six
        case .six:
            return .one
        }
    }
}

struct MurderView: View {
    @State private var knifeInContainer: [Knife] = [Knife(image: "knifeOriginal")]
    @State private var knifeInVictim: [Knife] = []
    
    @State private var isKnifeContainerTargeted = false
    @State private var isVictimTargeted = false
    
    @EnvironmentObject var appState: AppState
    
    @State private var animateKnife = false
    @State private var showBlood = false
    @State private var img = BloodImageEnum.one
    
    var body: some View {
        ZStack {
            if showBlood {
                VStack{
                    
                Image(img.rawValue)
                    .resizable()
                    .onAppear() {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            withAnimation {
                                self.img = self.img.next()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    withAnimation {
                                        self.img = self.img.next()
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                            withAnimation {
                                                self.img = self.img.next()
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                    withAnimation {
                                                        self.img = self.img.next()
                                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                            withAnimation {
                                                                self.img = self.img.next()
                                                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                                    appState.switchView = .blood
                                                                        
                                                                    
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .ignoresSafeArea()
            }
            VStack {
                KnifeContainerView(knives: knifeInContainer, isTargeted: isKnifeContainerTargeted)
                VictimContainerView(knives: knifeInVictim, isTargeted: isVictimTargeted)
                    .dropDestination(for: Knife.self) { droppedKnives, location in
                        for knife in droppedKnives {
                            knifeInContainer.removeAll { $0 == knife }
                        }
                        knifeInVictim += droppedKnives
                        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            showBlood = true
                        }
                        return true
                    } isTargeted: { isTargeted in
                        isVictimTargeted = isTargeted
                    }
            }
            .padding()
            
            
        }
        
    }
}


struct VictimContainerView: View {
    let knives: [Knife]
    let isTargeted: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            //                .foregroundColor(isTargeted ? .teal.opacity(0.15): Color(.secondarySystemFill))
                .foregroundColor(.clear)
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
    MurderView()
}
