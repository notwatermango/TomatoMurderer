//
//  Knife.swift
//  TomatoMurderer
//
//  Created by mg0 on 29/04/24.
//

import Foundation
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
                        .rotationEffect(Angle(degrees: 180))
                        .draggable(knife)
                }
            }
        }
        .frame(width: 150, height: 150)
    }
}

extension UTType {
    static let knife = UTType(exportedAs: "com.nwm.knife")
}
