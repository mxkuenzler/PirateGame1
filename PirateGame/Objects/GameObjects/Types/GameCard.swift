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

enum GameCardID {
    case NIL, DOUBLE_CANNONBALLS, LARGE_CANNONBALLS
}

class GameCard:Object {

    var cardID:GameCardID
    var action:( ()async->Void )
    public var canObtainOnce:Bool = false
    
    init(cardID:GameCardID, EntityName:String, action: @escaping () async -> Void) async{
        let CardModel = try? await Entity(named: EntityName, in: realityKitContentBundle)
        self.cardID = cardID
        self.action = action
        super.init(Entity: CardModel!, ID: ID.PHYSICAL_CARD)
    }
    
    init(cardID:GameCardID, EntityName:String, action: @escaping () -> Void) async{
        let CardModel = try? await Entity(named: EntityName, in: realityKitContentBundle)
        self.cardID = cardID
        self.action = action
        super.init(Entity: CardModel!, ID: ID.PHYSICAL_CARD)
    }
    
    func act() async {
        await action()
    }
    
}

class DoubleCannonballCard:GameCard {
    init() async {
        await super.init(cardID: .DOUBLE_CANNONBALLS, EntityName:"GameCard") {
            print("double balls")
        }
    }
}

class LargeCannonballCard:GameCard {
    init() async {
        await super.init(cardID: .LARGE_CANNONBALLS, EntityName:"GameCard") {
            print("large balls")
        }
    }
}

