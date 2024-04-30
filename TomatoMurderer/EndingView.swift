//
//  EndingView.swift
//  TomatoMurderer
//
//  Created by mg0 on 29/04/24.
//

import SwiftUI

enum ImageEnum: String {
    case farmerLayingDown = "farmerLayingDown"
    case farmerBlood = "farmerBlood"
    
    func next() -> ImageEnum {
        switch self {
        case .farmerBlood: return .farmerBlood
        case .farmerLayingDown: return .farmerBlood
        }
    }
}


struct EndingView: View {
    @State private var fadeOut = false
    @State private var emojiFadeOut = false
    @State private var img = ImageEnum.farmerLayingDown
    
    @State private var showEmoji = false
    
    
    var body: some View {
        ZStack {
            if showEmoji {
                HStack {
                    Image("sob")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    Image("tomato")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                .frame(maxWidth: 150)
                .offset(y: -230)
                .opacity(emojiFadeOut ? 0 : 1)
                .animation(.easeInOut(duration: 1), value: emojiFadeOut)
//                .onAppear(perform: {
//                    self.emojiFadeOut.toggle()
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                        self.emojiFadeOut.toggle()
//                    }
//                })
            }
            Image(img.rawValue)
                .resizable()
                .frame(width: img == ImageEnum.farmerBlood ? 19*10: 25*10, height: img == ImageEnum.farmerBlood ? 32*10: 25*10)
                .opacity(fadeOut ? 1 : 0)
                .animation(.easeInOut(duration: 0.25), value: fadeOut)
                .onAppear(perform: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.fadeOut.toggle()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                            withAnimation {
                                self.img = self.img.next()
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation {
                                    showEmoji.toggle()
                                }
                            }
                        }
                    }
                })
            
            
        }
    }
}

//#Preview {
//    EndingView()
//}
