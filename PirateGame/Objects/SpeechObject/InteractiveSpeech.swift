//
//  InteractiveSpeech.swift
//  PirateGame
//
//  Created by Student on 6/17/24.
//

import Foundation
import SwiftUI

class InteractiveSpeech {
    
    var Interactives:(any View)
    var Informatives:(any View)
    
    init(Informatives:(any View), Interactives:(any View)) {
        self.Interactives = Interactives
        self.Informatives = Informatives.frame(width: 150, height: 300, alignment: .center)   .multilineTextAlignment(.center).padding(5)
    }
    
    func getInteractives() -> some View {
        return AnyView(Interactives)
    }
    
    func getInformatives() -> some View {
        return AnyView(Informatives)
    }
    
    func setInteractives(_ view: any View) {
        self.Interactives = view
    }
    
}
