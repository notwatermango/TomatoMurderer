//
//  ContentView.swift
//  TomatoMurderer
//
//  Created by mg0 on 26/04/24.
//

import SwiftUI
import UniformTypeIdentifiers

// Draggable Item
struct Knife: Codable, Transferable, Hashable {
    var id: UUID = UUID()
    let image: String
    
    init(image: String) {
        self.image = image
    }
    
    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .knife)
    }
}

struct MurderView: View {
    @State private var knifeInContainer: [Knife] = [Knife(image: "knifeOriginal")]
    @State private var knifeInVictim: [Knife] = []
    
    @State private var isKnifeContainerTargeted = false
    @State private var isVictimTargeted = false

    
    
    var body: some View {
        VStack {
            KnifeContainerView(knives: knifeInContainer, isTargeted: isKnifeContainerTargeted)
            VictimContainerView(knives: knifeInVictim, isTargeted: isVictimTargeted)
                .dropDestination(for: Knife.self) { droppedKnives, location in
                    for knife in droppedKnives {
                        knifeInContainer.removeAll { $0 == knife }
                    }
                    knifeInVictim += droppedKnives
                    return true
                } isTargeted: { isTargeted in
                    isVictimTargeted = isTargeted
                }
        }
        .padding()
    }
}

struct KnifeContainerView: View {
    let knives: [Knife]
    let isTargeted: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
//                .foregroundColor(isTargeted ? .teal.opacity(0.15): Color(.secondarySystemFill))
                .foregroundColor(.clear)
            VStack {
                ForEach(knives, id: \.self) { knife in
                    Image(knife.image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .draggable(knife)
                }
            }
        }.frame(width: 100, height: 100)
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
                        .draggable(knife)
                }
            }
        }.padding()
    }
}

extension UTType {
    static let knife = UTType(exportedAs: "com.nwm.knife")
}

#Preview {
    MurderView()
}
