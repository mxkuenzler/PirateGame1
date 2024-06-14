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
    init() async{
        let CardModel = try? await Entity(named: "GameCard", in: realityKitContentBundle)
        super.init(Entity: CardModel!, ID: ID.PHYSICAL_CARD)
    }
}

class GameCard {
    
    func getView() -> some View {
        AnyView(self.getViews())
    }
    func getViews() -> any View {
        return (VStack {
            Text("This is nothing. There is an error. Whats up?")
        })
    }
}

class doubleCannonballCard:GameCard {
    
    override func getViews() -> any View {
        return (VStack {
            Text("This card will double the output of cannonballs for the rest of the game, but reward you with x1.75 the final reward for this game.")
        })
    }
}

class largeCannonballCard:GameCard {
    override func getViews() -> any View {
         return (VStack {
            Text("This card will double the size of cannonballs for the rest of the game, but reward you with x1.5 the final reward for this game.")
        })
    }
}
