//
//  GameCard.swift
//  PirateGame
//
//  Created by Student on 6/8/24.
//

import Foundation
import RealityKit
import RealityKitContent
import _RealityKit_SwiftUI
import SwiftUI

class PhysicalCard:Object {

    var count:Int
    static var overall:Int = 0
    
    init() async{
        let CardModel = try? await Entity(named: "GameCard", in: realityKitContentBundle)
        count = PhysicalCard.overall
        PhysicalCard.overall += 1
        super.init(Entity: CardModel!, ID: ID.PHYSICAL_CARD)
    }
    
    func getNum() -> Int {
        return count
    }
}

class GameCard {
    
    var speech:InteractiveSpeech
    var action:(() async -> Void)?
    
    init(speech:InteractiveSpeech, action: @escaping () async -> Void) async {
        
        self.speech = speech
        self.action = action
        
        self.speech.setInteractives(
            VStack {
                Button("Pick Card!") {
                    Task.init {
                        await action()
                    }
                }
                Button("Cancel") {
                    keeper.SideHUDState = .STANDARD
                    keeper.BottomHUDState = .STANDARD
                }
            }
        )
        
    }
    
    init() async {
        self.speech = InteractiveSpeech(Informatives: VStack{}, Interactives: VStack{})
        self.action = {}
    }
    
    func getSpeech() -> InteractiveSpeech {
        return speech
    }
    
}

class doubleCannonballCard:GameCard {
    
    
    override init() async {
        let speech = InteractiveSpeech(Informatives: (VStack {
            Text("This card will double\nthe output of cannonballs\nfor the rest of the game,\nbut reward you with x1.75\nthe final reward for this game.")
        }), Interactives: (VStack{
        }
        ))
        await super.init(speech:speech){
            print("DoubleCannonballs")
            await getManager()?.endIntermission()
            keeper.SideHUDState = .STANDARD
            keeper.BottomHUDState = .STANDARD
        }
    }
    
}

class largeCannonballCard:GameCard {
    
    override init() async {
        let speech = InteractiveSpeech(Informatives: (VStack {
            Text("This card will double the size of cannonballs for the rest of the game, but reward you with x1.5 the final reward for this game.")
        }), Interactives: (VStack{
        }
        ))
        await super.init(speech:speech) {
            print("DoubleSize")
            await getManager()?.endIntermission()
            keeper.SideHUDState = .STANDARD
            keeper.BottomHUDState = .STANDARD
        }
    }
    
}
