//
//  marketShip.swift
//  PirateGame
//
//  Created by Student on 6/8/24.
//

import Foundation
import RealityKit
import RealityKitContent
import _RealityKit_SwiftUI

class MarketShip: Object {
    
    var cards:[GameCard] = Array()
    
    init() async{
        let MarketShipModel = try? await Entity(named: "MarketShip", in: realityKitContentBundle)
        super.init(Entity: MarketShipModel!, ID: ID.MARKET_SHIP)
    }
    
    override func onRegister() {
                
        for i in 0...2 {
            Task {
                let card = await manager!.pickRandomCard()
                cards.append(card)
                
                card.setPosition(pos: SIMD3<Float>(x:-8.2,y:0.5,z:-0.5 * Float((1-i))))
                
                manager?.registerObject(object: card)
                await card.getEntity()?.components.set(InputTargetComponent())
                await card.getEntity()?.components.set(HoverEffectComponent())
            }
        }
        
    }
    
    override func onUnregister() {
        for i in 0...2 {
            manager?.unregisterObject(object: cards[i])
        }
        cards.removeAll()
    }
    
}
